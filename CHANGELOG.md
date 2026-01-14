# CHANGELOG

## [3.0.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/3.0.0)

Released on 2026-01-14.

### ⚡ Performance Improvements

This release brings significant performance optimizations that dramatically improve scroll smoothness and responsiveness:

- **O(n²) → O(n) message rendering**: Cached message metadata (date headers, grouping info) to eliminate redundant calculations during scrolling.
- **Shared DateFormatter**: Replaced repeated `DateFormatter` instantiations with a static cached formatter.
- **Cached emoji detection**: Emoji-only text detection and markdown parsing are now cached per message.
- **Async image cache lookups**: Moved Kingfisher cache lookups off the main thread to prevent UI blocking.
- **Equatable conformance**: Added `Equatable` to `ChatMessageViewContainer` for better SwiftUI diffing.
- **Faster video playback**: Reduced video play delay from 700ms to 100ms.
- **Deterministic CarouselItemButton IDs**: Improved SwiftUI's identity tracking for carousel buttons.
- **Stable image placeholders**: Fixed scroll jitter by using consistent 4:3 aspect ratio placeholders for images.
- **MessageRow optimization**: Introduced `MessageRow` struct with stable IDs for improved list performance.

### 🎨 Example App Enhancements

- **ThemeShowcaseView**: Interactive theme preview with live switching between 8 pre-built themes.
- **MessageTypesGalleryView**: Comprehensive gallery showcasing all message types.
- **InteractiveChatView**: Simulated chatbot conversation demo.
- **ChatThemes**: Pre-built themes (Modern, Classic, Dark Neon, Minimal, Ocean, Sunset, Nature, Lavender).

### 🖥️ Cross-Platform Improvements

- **macOS compatibility**: Full macOS support for the Example app with adaptive colors and navigation.
- **Adaptive colors**: Platform-specific background colors using `NSColor` on macOS and `UIColor` on iOS.
- **Dark mode fixes**: Consistent theme appearance in both light and dark modes.

### 🔧 Maintenance

- **Dependency Updates**: Kingfisher bumped to 8.6.2.
- **CI/CD**: Configured Dependabot, upgraded Xcode to 16.1, macOS runner to v15.
- **GitHub Actions**: Updated stale action to v10.

---

## [2.8.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.8.0)

Released on 2025-09-06.

#### Added

- PIPVideoCellViewModel: centralized sizing, positioning and delayed reposition scheduling for picture-in-picture video cells.

#### Changed

- Refactor: `PIPVideoCell` rewritten to use `PIPVideoCellViewModel`, removed Combine-based cancellables and adopted structured concurrency (`Task`) for delayed actions and lifecycle.
- Main-thread safety: annotate `VideoManager` and `VideoPlayerRepresentable` with `@MainActor`.
- Concurrency: replaced `DispatchQueue` delayed calls with `Task.sleep` in `VideoMessageView`.

#### Update

- Dependency: Kingfisher bumped to 8.5.0

## [2.5.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.5.0)

Released on 2024-04-09.

- refactor: drop iOS-14 and macOS-11 support
- refactor: remove VideoPlayer dependency
- refactor: increase swift tools version to 5.8
- fix(ci): correct swift build github action

## [2.4.1](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.4.1)

Released on 2023-12-10.

#### Update

- chore: upgrade dependencies

## [2.4.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.4.0)

Released on 2023-07-09.

#### Update

- Merged #39, #40, #42 about dependency upgrades
- Dropped macOS v10 support

## [2.3.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.3.0)

Released on 2023-01-29.

#### Update

- Merged #33 thanks to @LeonardMaetzner
- Updated dependencies: Kingfisher (to 7.5.0)

## [2.2.1](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.2.1)

Released on 2022-07-12.

#### Update

- Merged #31 thanks to @bporter95
- Updated dependencies: Kingfisher (to 7.4.1) & WrappingHStack (to 2.2.9)

## [2.2.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.2.0)

Released on 2022-03-16.

#### Update

- Merged #23 thanks to @blakesplay

## [2.1.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.1.0)

Released on 2022-02-18.

#### Update

- Merged #21 & #22 thanks to @blakesplay & @NikitaPokatovich

## [2.0.2](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.0.2)

Released on 2021-10-26.

#### Update

- Merged #18 thanks to @lemonandlime
- GitHub action added (Swift compiler)

## [2.0.1](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.0.1)

Released on 2021-10-11.

#### Update

- Round specific corners of TextMessages (Merged #16, thanks to @lemonandlime)

## [2.0.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/2.0.0)

Released on 2021-10-06.

#### Update

- iOS 13 dropped since iOS 15 released.
- Dependency versions upgraded (to 7.0.0) . (Kingfisher)

## [1.3.5](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.3.5)

Released on 2021-05-05.

#### Added

- ScrollToBottom behaviour added when keyboard appears (iOS14), [#8](https://github.com/EnesKaraosman/SwiftyChat/pull/8)

#### Update

- Dependency versions upgraded (to 6.3.0) . (Kingfisher)

## [1.3.4](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.3.4)

Released on 2021-04-13.

#### Update

- Dependency versions upgraded. (Kingfisher)

#### Fixed

- AttributedText color is same color that is defined in style.

## [1.3.3](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.3.3)

Released on 2021-02-18.

#### Update

- Dependency versions upgraded.

## [1.3.2](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.3.2)

Released on 2020-12-19.

#### Fixed

- Performance improvements
  - [Issue #4](https://github.com/EnesKaraosman/SwiftyChat/issues/4).
  - Some access modifiers changed to internal for optimization.

## [1.3.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.3.0)

Released on 2020-11-16.

#### Added

- Video ChatMessageKind support added.
  - View `ChatMessageKind.video(VideoItem)` for detail.

## [1.2.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.2.0)

Released on 2020-10-21.

#### Added

- Scroll to bottom functionality for iOS14+
  - User proper initializer, with the one has `scrollToBottom`

---

## [1.1.0](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.1.0)

Released on 2020-10-20.

#### Added

- Multiline InputBarView added.
  - Investigate `BasicInputBarView`.
- Example project added.

---

## [1.0.4](https://github.com/EnesKaraosman/SwiftyChat/releases/tag/1.0.4)

Released on 2020-10-6.

#### Added

- You can now set the background of `ChatView`.
