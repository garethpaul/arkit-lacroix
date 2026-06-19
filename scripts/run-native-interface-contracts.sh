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

"$DOTNET" "$BUILD_DIR/bin/NativeInterfaceContracts.dll"
