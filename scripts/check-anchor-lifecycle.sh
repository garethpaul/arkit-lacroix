#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH='' cd -- "$SCRIPT_DIR/.." && pwd)
ANCHOR_MANAGER="$ROOT_DIR/Assets/Plugins/iOS/UnityARKit/Utility/UnityARAnchorManager.cs"
PLANE_GENERATOR="$ROOT_DIR/Assets/Plugins/iOS/UnityARKit/UnityARGeneratePlane.cs"
failures=0

require_contains() {
  file=$1
  text=$2
  message=$3

  if ! grep -Fq "$text" "$file"; then
    printf '%s\n' "$message" >&2
    failures=$((failures + 1))
  fi
}

for event_handler in \
  "ARAnchorAddedEvent += AddAnchor" \
  "ARAnchorUpdatedEvent += UpdateAnchor" \
  "ARAnchorRemovedEvent += RemoveAnchor"; do
  require_contains "$ANCHOR_MANAGER" "$event_handler" \
    "UnityARAnchorManager subscription is missing: $event_handler"
done

for event_handler in \
  "ARAnchorAddedEvent -= AddAnchor" \
  "ARAnchorUpdatedEvent -= UpdateAnchor" \
  "ARAnchorRemovedEvent -= RemoveAnchor"; do
  require_contains "$ANCHOR_MANAGER" "$event_handler" \
    "UnityARAnchorManager teardown is missing: $event_handler"
done

require_contains "$ANCHOR_MANAGER" "private bool eventsSubscribed;" \
  "UnityARAnchorManager must track whether static anchor events are subscribed."
require_contains "$ANCHOR_MANAGER" "if (!eventsSubscribed)" \
  "UnityARAnchorManager teardown must be idempotent."

destroy_scope=$(sed -n '/public void Destroy()/,/public List<ARPlaneAnchorGameObject>/p' "$ANCHOR_MANAGER")
unsubscribe_line=$(printf '%s\n' "$destroy_scope" | grep -nF "UnsubscribeFromEvents ();" | head -1 | cut -d: -f1 || true)
destroy_planes_line=$(printf '%s\n' "$destroy_scope" | grep -nF "foreach (ARPlaneAnchorGameObject" | head -1 | cut -d: -f1 || true)
if [ -z "$unsubscribe_line" ] || [ -z "$destroy_planes_line" ] || [ "$unsubscribe_line" -ge "$destroy_planes_line" ]; then
  printf '%s\n' "UnityARAnchorManager must unsubscribe before destroying owned planes." >&2
  failures=$((failures + 1))
fi

generator_destroy_scope=$(sed -n '/void OnDestroy()/,/void OnGUI()/p' "$PLANE_GENERATOR")
guard_line=$(printf '%s\n' "$generator_destroy_scope" | grep -nF "if (unityARAnchorManager != null)" | head -1 | cut -d: -f1 || true)
manager_destroy_line=$(printf '%s\n' "$generator_destroy_scope" | grep -nF "unityARAnchorManager.Destroy ();" | head -1 | cut -d: -f1 || true)
if [ -z "$guard_line" ] || [ -z "$manager_destroy_line" ] || [ "$guard_line" -ge "$manager_destroy_line" ]; then
  printf '%s\n' "UnityARGeneratePlane must tolerate OnDestroy before Start initializes its manager." >&2
  failures=$((failures + 1))
fi

if [ "$failures" -ne 0 ]; then
  exit 1
fi

printf '%s\n' "Unity AR anchor lifecycle checks passed."
