![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue.svg)
![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue.svg)

# SwiftyChat

A lightweight SwiftUI chat UI with [built-in message types](#message-kinds), theming, and cross-platform support.

Also available for [Flutter](https://github.com/EnesKaraosman/swifty_chat).

## Features

- High-performance rendering (O(n) complexity, cached formatters, async image loading)
- 11 built-in message types including text, image, video, location, carousel, link previews, and quick replies
- 8 pre-built [themes](#pre-built-themes) with full style customization via environment
- [Custom message cells](CustomMessage.md) for any message type you need
- Cross-platform: iOS 17+ and macOS 14+
- Landscape orientation support with auto-scaling cells
- User avatars with configurable positioning
- Keyboard dismiss on tap and scroll
- Scroll to bottom or to a specific message
- Picture-in-Picture video playback
- Per-corner rounding on text bubbles
- Multiline input bar ([BasicInputView](../master/Sources/SwiftyChat/InputView/BasicInputView.swift))
- Attributed string / markdown support

## Preview

<img src="../master/Sources/SwiftyChat/Demo/Preview/swiftyChatGIF.gif" height="240"/>

<details>
  <summary>Basic Example</summary>

  | Light | Dark |
:---:|:---:|
<img src="../master/Sources/SwiftyChat/Demo/Preview/basic-1.png" width="240"/> | <img src="../master/Sources/SwiftyChat/Demo/Preview/basic-2.png" width="240"/>

<img src="../master/Sources/SwiftyChat/Demo/Preview/basic-3.png" height="240"/>

</details>

<details>
  <summary>Advanced Example</summary>

  | Contact, QuickReply, Text, Carousel | Map, Image | ContextMenu |
:---:|:---:|:---:
<img src="../master/Sources/SwiftyChat/Demo/Preview/avatar_contact_qr_carousel_text.png" width="240"/> | <img src="../master/Sources/SwiftyChat/Demo/Preview/map_image.png" width="240"/> | <img src="../master/Sources/SwiftyChat/Demo/Preview/contextMenu.png" width="240"/>

</details>

## Installation

```
https://github.com/EnesKaraosman/SwiftyChat.git
```

Add via Swift Package Manager in Xcode.

## Message Kinds

```swift
public enum ChatMessageKind: CustomStringConvertible {
    case text(String)              // Auto-scales for emoji-only messages
    case image(ImageLoadingKind)   // Local (UIImage/NSImage) or remote (URL)
    case imageText(ImageLoadingKind, String) // Image with caption
    case location(LocationItem)    // MapKit pin
    case contact(ContactItem)      // Shareable contact card
    case quickReply([QuickReplyItem]) // Tappable options, auto-disables after selection
    case carousel([CarouselItem])  // Scrollable cards with buttons
    case video(VideoItem)          // Video with PiP support
    case linkPreview(LinkPreviewItem) // Rich URL preview with Open Graph metadata
    case loading                   // Animated loading indicator
    case custom(Any)               // Your own message type
}
```

## Usage

### Minimal setup

```swift
import SwiftyChat

@State private var messages: [YourMessage] = []
@State private var scrollToBottom = false

ChatView(
    messages: $messages,
    scrollToBottom: $scrollToBottom
) {
    BasicInputView(
        message: $message,
        placeholder: "Type something",
        onCommit: { messageKind in
            messages.append(/* your message */)
        }
    )
}
.environment(\.chatStyle, ChatMessageCellStyle())
```

`YourMessage` must conform to the `ChatMessage` protocol (which has an associated `ChatUser` type). See the [SwiftyChatDemo app](../master/SwiftyChatDemo) for a complete implementation.

### Input view

A built-in `BasicInputView` is included. Use it as-is, or build your own — `ChatView` accepts any view via its `inputView` closure.

### Styling

Every visual aspect is customizable through `ChatMessageCellStyle`:

```swift
public struct ChatMessageCellStyle {
    let incomingTextStyle: TextCellStyle
    let outgoingTextStyle: TextCellStyle
    let incomingCellEdgeInsets: EdgeInsets
    let outgoingCellEdgeInsets: EdgeInsets
    let contactCellStyle: ContactCellStyle
    let imageCellStyle: ImageCellStyle
    let imageTextCellStyle: ImageTextCellStyle
    let quickReplyCellStyle: QuickReplyCellStyle
    let carouselCellStyle: CarouselCellStyle
    let locationCellStyle: LocationCellStyle
    let videoPlaceholderCellStyle: VideoPlaceholderCellStyle
    let linkPreviewCellStyle: LinkPreviewCellStyle
    let incomingAvatarStyle: AvatarStyle
    let outgoingAvatarStyle: AvatarStyle
}
```

Inject via `.environment(\.chatStyle, yourStyle)`. All properties have sensible defaults.

See [Styles.md](../master/Styles.md) for the full style reference and [CustomMessage.md](CustomMessage.md) for custom cell types.

## Pre-built Themes

| Theme | Description |
|-------|-------------|
| **Modern** | Clean blue, minimal design |
| **Classic** | Traditional green messaging |
| **Dark Neon** | Cyberpunk with neon pink accents |
| **Minimal** | Subtle gray tones |
| **Ocean** | Calming teal, sea-inspired |
| **Sunset** | Warm orange gradients |
| **Nature** | Fresh green, eco-friendly |
| **Lavender** | Soft purple, relaxing |

See `ThemeShowcaseView` in the SwiftyChatDemo app for live demos.

## Contributing

PRs are welcome for features, bug fixes, or documentation improvements.

## Inspiration

- [MessageKit](https://github.com/MessageKit/MessageKit) (UIKit)
- [Nio](https://github.com/niochat/nio) (SwiftUI)
