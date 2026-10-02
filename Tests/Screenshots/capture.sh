#!/usr/bin/env bash
set -euo pipefail

simulator_id=${1:?Usage: capture.sh SIMULATOR_UDID}
repo_root=$(cd "$(dirname "$0")/../.." && pwd)
output_dir="$repo_root/Documentation/Images"
previous_appearance=$(xcrun simctl ui "$simulator_id" appearance)
trap 'xcrun simctl ui "$simulator_id" appearance "$previous_appearance"' EXIT

cd "$repo_root"
for appearance in light dark; do
    xcrun simctl ui "$simulator_id" appearance "$appearance"
    maestro test --udid "$simulator_id" \
        -e OUTPUT_DIR="$output_dir" -e APPEARANCE="$appearance" Tests/Screenshots
done

SWIFTYCHAT_SNAPSHOT_DIR="$output_dir/components" swift test --filter ComponentRenderingTests
