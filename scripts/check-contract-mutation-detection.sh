#!/usr/bin/env sh
#
# Meta-check: prove the native-interface contract suite can actually FAIL.
#
# Every other gate in this repository reads a *representation* of the contracts
# (grep pins over Program.cs call sites, the csproj source list, the runner's
# own text). None of them observe whether an assertion mechanism still decides
# anything. Shadowing Expect() in Program.cs keeps all of those pinned strings
# byte-identical while making the suite incapable of reporting a failure.
#
# This harness copies the tree to a scratch directory, PLANTS A REAL DEFECT in a
# production native-interface source, runs the REAL contract suite, and fails if
# the suite still reports success. Detection is established by construction
# rather than by pinning text.
#
# It deliberately uses plain exit codes and shell arithmetic -- never the
# contract executable's own assertion helper -- so the mechanism under test
# cannot shadow the mechanism testing it.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DOTNET=${DOTNET:-dotnet}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/arkit-contract-mutation.XXXXXX")

cleanup() {
  rm -rf -- "$WORK"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

TREE="$WORK/tree"
NATIVE_DIR="$TREE/Assets/Plugins/iOS/UnityARKit/NativeInterface"
failures=0

mkdir -p "$TREE/Assets/Plugins/iOS/UnityARKit"
cp -R -- "$ROOT/Tests" "$TREE/Tests"
cp -R -- "$ROOT/scripts" "$TREE/scripts"
cp -R -- "$ROOT/Assets/Plugins/iOS/UnityARKit/NativeInterface" "$NATIVE_DIR"

run_suite() {
  DOTNET="$DOTNET" sh "$TREE/scripts/run-native-interface-contracts.sh" \
    >"$WORK/suite-output.txt" 2>&1
}

restore_native_sources() {
  rm -rf -- "$NATIVE_DIR"
  cp -R -- "$ROOT/Assets/Plugins/iOS/UnityARKit/NativeInterface" "$NATIVE_DIR"
}

# Replace an exact literal in a scratch production source, asserting up front
# that the anchor occurs exactly as many times as expected. A mutation that did
# not apply would otherwise look identical to a suite that failed to detect it.
mutate() {
  file=$1
  literal=$2
  replacement=$3
  expected_hits=$4

  target="$NATIVE_DIR/$file"
  hits=$(grep -Fc -- "$literal" "$target" || true)
  if [ "$hits" -ne "$expected_hits" ]; then
    printf 'Mutation anchor is stale in %s: matched %s times, expected %s.\n' \
      "$file" "$hits" "$expected_hits" >&2
    printf '%s\n' "This harness is INVALID until the anchor is repaired." >&2
    exit 1
  fi

  python3 - "$target" "$literal" "$replacement" <<'PY'
import sys

path, literal, replacement = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path, encoding='utf-8-sig') as handle:
    source = handle.read()
with open(path, 'w', encoding='utf-8-sig') as handle:
    handle.write(source.replace(literal, replacement))
PY

  applied=$(grep -Fc -- "$replacement" "$target" || true)
  if [ "$applied" -lt 1 ]; then
    printf 'Mutation did not apply to %s; harness is INVALID.\n' "$file" >&2
    exit 1
  fi
  printf '  mutation applied to %s (%s occurrence(s) replaced)\n' "$file" "$hits"
}

expect_suite_detects() {
  description=$1

  if run_suite; then
    printf 'UNDETECTED MUTATION: %s\n' "$description" >&2
    printf '%s\n' "  The contract suite reported success while a real defect was present." >&2
    printf '%s\n' "  The assertion mechanism is not deciding anything." >&2
    sed 's/^/  | /' "$WORK/suite-output.txt" >&2
    failures=$((failures + 1))
  else
    printf '  detected: %s\n' "$description"
  fi

  restore_native_sources
}

printf '%s\n' "Establishing clean baseline for native-interface contracts..."
if ! run_suite; then
  printf '%s\n' "Native-interface contracts fail on an unmutated tree; harness is INVALID." >&2
  sed 's/^/  | /' "$WORK/suite-output.txt" >&2
  exit 1
fi
printf '%s\n' "  clean baseline passes"

printf '%s\n' "Planting production defects; each must be detected..."

mutate ARErrorCode.cs \
  'ARErrorCodeWorldTrackingFailed        = 200,' \
  'ARErrorCodeWorldTrackingFailed        = 299,' 1
expect_suite_detects "ARErrorCode.ARErrorCodeWorldTrackingFailed retagged 200 -> 299"

mutate ARErrorCode.cs \
  'public enum ARErrorCode : long' \
  'public enum ARErrorCode : int' 1
expect_suite_detects "ARErrorCode native backing type narrowed long -> int"

mutate ARHitTestResultType.cs \
  'public enum ARHitTestResultType : long' \
  'public enum ARHitTestResultType : int' 1
expect_suite_detects "ARHitTestResultType native backing type narrowed long -> int"

mutate ARTrackingState.cs \
  '        ARTrackingStateNotAvailable,' \
  '        ARTrackingStateNotAvailable,
        ARTrackingStateInjectedByMutationHarness,' 1
expect_suite_detects "ARTrackingState member inserted, shifting ARTrackingStateNormal off 2"

mutate ARTrackingStateReason.cs \
  '        ARTrackingStateReasonNone,' \
  '        ARTrackingStateReasonNone,
        ARTrackingStateReasonInjectedByMutationHarness,' 1
expect_suite_detects "ARTrackingStateReason member inserted, shifting InsufficientFeatures off 3"

mutate ARSize.cs \
  '		public double height;' \
  '' 1
expect_suite_detects "ARSize.height dropped, breaking the 16-byte native size"

if [ "$failures" -ne 0 ]; then
  printf '%s\n' "" >&2
  printf '%s\n' "$failures planted defect(s) went undetected by the native-interface contracts." >&2
  printf '%s\n' "The contract suite does not verify behaviour. Do not trust a green run." >&2
  exit 1
fi

printf '%s\n' "Native-interface contract mutation detection passed."
