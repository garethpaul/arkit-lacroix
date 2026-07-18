#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DOTNET=${DOTNET:-dotnet}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/arkit-native-interface-contracts.XXXXXX")

cleanup() {
  rm -rf -- "$BUILD_DIR"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

DOTNET_CLI_HOME="$BUILD_DIR/dotnet-home"
NUGET_PACKAGES="$BUILD_DIR/nuget"
DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_CLI_HOME NUGET_PACKAGES DOTNET_CLI_TELEMETRY_OPTOUT

"$DOTNET" build \
  "$ROOT/Tests/NativeInterfaceContracts/NativeInterfaceContracts.csproj" \
  --configuration Release \
  --nologo \
  --verbosity quiet \
  --output "$BUILD_DIR/bin" \
  --property:BaseIntermediateOutputPath="$BUILD_DIR/obj/" \
  --property:UseAppHost=false

MINIMUM_ASSERTIONS=11
CONTRACT_OUTPUT="$BUILD_DIR/contract-output.txt"

contract_status=0
"$DOTNET" "$BUILD_DIR/bin/NativeInterfaceContracts.dll" >"$CONTRACT_OUTPUT" 2>&1 || contract_status=$?
cat -- "$CONTRACT_OUTPUT"

if [ "$contract_status" -ne 0 ]; then
  exit "$contract_status"
fi

# Assert an assertion floor from the runner's own output. A shadowed or removed
# Expect() mechanism reports fewer executed assertions and cannot satisfy this,
# even though every pinned assertion call site stays byte-identical.
executed=$(sed -n 's/^assertions executed: \([0-9][0-9]*\)$/\1/p' "$CONTRACT_OUTPUT" | tail -1)

if [ -z "$executed" ]; then
  printf '%s\n' "Native-interface contracts did not report an executed assertion count." >&2
  exit 1
fi

if [ "$executed" -lt "$MINIMUM_ASSERTIONS" ]; then
  printf 'Native-interface contracts executed %s assertions; at least %s are required.\n' \
    "$executed" "$MINIMUM_ASSERTIONS" >&2
  exit 1
fi
