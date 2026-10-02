# Appearance verification and screenshots

## What is covered

- `AppearanceTests` resolves the default text and background colors in light and dark mode, composites translucent colors over white/black canvases, and checks a minimum 4.5:1 contrast ratio. It covers incoming/outgoing text, captions, contacts, carousel titles/subtitles/actions, selected/unselected quick replies, and link titles/descriptions/hosts.
- `ComponentRenderingTests` renders local SwiftUI fixtures in both appearances, checks that rendering succeeds, and optionally exports PNGs. It covers text, links, emoji, images, captions, replies, contacts without native actions, quick replies, link previews, loading, custom content, and video thumbnail states. It also measures the contrast of actual rendered reply-quote pixels. The other samples are render smoke tests, not pixel comparison tests.
- Maestro runs the demo's interactive flows. The theme flow cycles through all five presets, sends a message, and checks that it survives theme changes. The media flow opens and closes the video overlay.
- The screenshot flows capture native controls in the running iOS demo, including carousels, contact actions, maps, input fields, and the software keyboard. These need visual inspection; an accessibility assertion alone does not prove contrast or layout.

Custom host backgrounds, fonts, and colors need their own checks. The automated checks do not measure real-device frame rate or verify Picture in Picture behavior on hardware.

## Verification recorded on 2026-10-02

- 22 package tests passed on both Xcode 26.6 and Xcode 27.
- All 10 demo smoke flows passed in each system appearance on the iPhone 17 Pro / iOS 26.5 simulator.
- Native keyboard layout was checked with the theme header and a sent message visible above the keyboard.
- A live system appearance change preserved the open conversation and its sent message.
- The iOS and macOS demos built successfully; native macOS theme selection and message entry were checked.
- The final reply and video fixes received focused smoke checks in both appearances. Documentation images were inspected for contrast and capture artifacts.

## Run the checks

Build and install the demo on a booted iOS simulator, then substitute its UDID below:

```sh
swift test

xcodebuild build \
  -project SwiftyChatDemo/SwiftyChatDemo.xcodeproj \
  -scheme SwiftyChatDemo \
  -destination 'platform=iOS Simulator,id=SIMULATOR_UDID' \
  -derivedDataPath /tmp/swiftychat-demo \
  CODE_SIGNING_ALLOWED=NO

xcrun simctl install SIMULATOR_UDID \
  /tmp/swiftychat-demo/Build/Products/Debug-iphonesimulator/SwiftyChatDemo.app

xcrun simctl ui SIMULATOR_UDID appearance light
maestro test --udid SIMULATOR_UDID Tests/Smoke
xcrun simctl ui SIMULATOR_UDID appearance dark
maestro test --udid SIMULATOR_UDID Tests/Smoke
```

Also switch the simulator appearance while a conversation is open. Verify text, captions, maps, input controls, selected replies, and video controls update without relaunching. In Theme Showcase, select Dark Neon while the system is light, then return to Modern: native controls should return to the system appearance.

## Refresh documentation assets

With the demo installed and [Maestro](https://maestro.mobile.dev/) available:

```sh
bash Tests/Screenshots/capture.sh SIMULATOR_UDID
```

The script saves simulator screenshots to `Documentation/Images`, exports component samples to `Documentation/Images/components`, and restores the simulator's previous appearance. It leaves the demo open. Remote demo photos and map tiles require network access; component fixtures are local.

To export only the component images:

```sh
SWIFTYCHAT_SNAPSHOT_DIR="$PWD/Documentation/Images/components" \
  swift test --filter ComponentRenderingTests
```

Review the images before committing. Check for clipped text, missing remote content, unreadable controls, and unintended appearance overrides. Avoid replacing native controls with `ImageRenderer` captures: it cannot render every platform view.

The README hero uses a `<picture>` element to match the reader's appearance. The style guide shows both modes side by side so differences remain visible. Demo photos are sample content from the URLs in the demo; the gradient and mountain component fixture is drawn with SwiftUI and an SF Symbol.
