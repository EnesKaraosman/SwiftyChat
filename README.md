<p align="center">
  <img src="Sources/SwiftyChat/Demo/Preview/swiftyChatGIF.gif" height="380" alt="Animated preview of the SwiftyChat chat UI"/>
</p>

<h1 align="center">SwiftyChat</h1>

<p align="center">
  <strong>A lightweight, cross-platform SwiftUI chat UI framework.<br/>Perfect for AI chatbots, customer support, and messaging apps.</strong>
</p>

<p align="center">
  <a href="https://github.com/EnesKaraosman/SwiftyChat/stargazers"><img src="https://img.shields.io/github/stars/EnesKaraosman/SwiftyChat?style=social" alt="GitHub Stars"/></a>
  <a href="https://github.com/EnesKaraosman/SwiftyChat/network/members"><img src="https://img.shields.io/github/forks/EnesKaraosman/SwiftyChat?style=social" alt="GitHub Forks"/></a>
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/iOS-17%2B-blue.svg" alt="iOS 17+"/>
  <img src="https://img.shields.io/badge/macOS-14%2B-blue.svg" alt="macOS 14+"/>
  <a href="https://swiftpackageindex.com/EnesKaraosman/SwiftyChat"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEnesKaraosman%2FSwiftyChat%2Fbadge%3Ftype%3Dplatforms" alt="Swift Package Index"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/EnesKaraosman/SwiftyChat" alt="License"/></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#message-kinds">Message Types</a> •
  <a href="#pre-built-themes">Themes</a> •
  <a href="#ai--chatbot-use-case">AI & Chatbot</a> •
  <a href="CustomMessage.md">Custom Cells</a>
</p>

---

Also available for [Flutter](https://github.com/EnesKaraosman/swifty_chat).

## Why SwiftyChat?

- **11 built-in message types** — text, image, video, location, carousel, quick replies, link previews, contacts, loading indicators, and more
- **5 demo themes** with full style customization via SwiftUI environment
- **Cross-platform** — iOS 17+ and macOS 14+ from a single codebase
- **Lazy message rendering** with linear header calculation and remote image loading
- **Chatbot-ready** — carousels, quick replies, and loading states designed for AI/bot interfaces
- **Lightweight** — Kingfisher is the only package dependency
- [Custom message cells](CustomMessage.md) for any type you need
- Landscape orientation support with auto-scaling cells
- User avatars with configurable positioning
- Keyboard dismiss on tap and scroll
- Scroll to bottom or to a specific message
- Picture-in-Picture video playback
- Per-corner rounding on text bubbles
- Multiline input bar ([BasicInputView](Sources/SwiftyChat/InputView/BasicInputView.swift))
- Attributed string / markdown support

## Preview

| Light | Dark | Theme Showcase |
|:---:|:---:|:---:|
| <img src="Sources/SwiftyChat/Demo/Preview/basic-1.png" width="220" alt="Light mode chat demo"/> | <img src="Sources/SwiftyChat/Demo/Preview/basic-2.png" width="220" alt="Dark mode chat demo"/> | <img src="Sources/SwiftyChat/Demo/Preview/theme-showcase.png" width="220" alt="Theme showcase with carousel and map"/> |

<details>
  <summary>More screenshots</summary>

  | Advanced Features | Theme (Dark) | Chatbot Demo |
  |:---:|:---:|:---:|
  | <img src="Sources/SwiftyChat/Demo/Preview/advanced-features.png" width="220" alt="Advanced features with link preview"/> | <img src="Sources/SwiftyChat/Demo/Preview/theme-showcase-dark.png" width="220" alt="Theme showcase in dark mode"/> | <img src="Sources/SwiftyChat/Demo/Preview/chatbot-demo.png" width="220" alt="Chatbot demo with quick replies"/> |

</details>

## Installation

### Swift Package Manager

Add SwiftyChat in Xcode via **File → Add Package Dependencies**:

```
https://github.com/EnesKaraosman/SwiftyChat.git
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/EnesKaraosman/SwiftyChat.git", from: "4.1.1")
]
```

## Quick Start

```swift
import SwiftyChat

struct ContentView: View {
    @State private var messages: [YourMessage] = []
    @State private var message = ""
    @State private var scrollToBottom = false

    var body: some View {
        ChatView(messages: $messages, scrollToBottom: $scrollToBottom) {
            BasicInputView(
                message: $message,
                placeholder: "Type something",
                onCommit: { messageKind in
                    messages.append(/* your message */)
                }
            )
        }
        .environment(\.chatStyle, ChatMessageCellStyle())
    }
}
```

> `YourMessage` must conform to the `ChatMessage` protocol (which has an associated `ChatUser` type). See the [SwiftyChatDemo app](SwiftyChatDemo) for a complete implementation.

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
    case linkPreview(LinkPreviewItem) // Displays URL metadata supplied by your app
    case loading                   // Animated loading indicator
    case custom(Any)               // Your own message type
}
```

## Customization

### Input View

A built-in `BasicInputView` is included. Use it as-is, or build your own — `ChatView` accepts any view via its `inputView` closure.

The demo's text chat adds pagination, streaming replies, reply quotes, delivery status, and an iOS photo/video picker. `ChatMessage` has optional `replyPreview` and `deliveryStatus` properties with `nil` defaults, so existing message types still compile.

### Link previews

Link metadata is fetched only when your app calls the optional helper. Keep one loader instance to reuse its in-memory cache:

```swift
let loader = LinkPreviewMetadataLoader()
let preview = try await loader.preview(for: url)
let kind = ChatMessageKind.linkPreview(preview)
```

The helper uses Apple's LinkPresentation to retrieve a title and host. It does not provide a description or image URL; supply your own `LinkPreviewItem` for richer previews. The macOS host app needs the network client entitlement to fetch remote metadata.

### Styling

Every visual aspect is customizable through `ChatMessageCellStyle` — text styles, edge insets, avatar styles, and cell styles for every message type. Inject via `.environment(\.chatStyle, yourStyle)`. All properties have sensible defaults.

See [Styles.md](Styles.md) for the full style reference and [CustomMessage.md](CustomMessage.md) for custom cell types.

## Pre-built Themes

| Theme | Description |
|-------|-------------|
| **Modern** | Clean blue, minimal design |
| **Classic** | Traditional green messaging |
| **Dark Neon** | Cyberpunk with glowing accents |
| **Warm Sunset** | Orange and coral tones |
| **Nature** | Green tones inspired by forests |

See `ThemeShowcaseView` in the SwiftyChatDemo app for live demos.

## AI & Chatbot Use Case

SwiftyChat is especially well-suited for AI and chatbot interfaces. Built-in support for carousels, quick reply buttons, loading indicators, and link previews means you can build a rich conversational UI without custom cells:

```swift
// Show a loading indicator while the AI responds
messages.append(Message(user: bot, messageKind: .loading))

// Replace with the actual response
messages[messages.count - 1] = Message(
    user: bot,
    messageKind: .text("Here's what I found...")
)

// Offer follow-up options as quick replies
messages.append(Message(
    user: bot,
    messageKind: .quickReply([
        QuickReplyItem(title: "Tell me more"),
        QuickReplyItem(title: "Something else"),
    ])
))
```

Building a ChatGPT-style app, a customer support bot, or an in-app assistant? SwiftyChat gives you the UI layer so you can focus on the AI logic.

## Testing

Run package tests with `swift test`. The iOS demo also has [Maestro smoke flows](Tests/Smoke) for sending, streaming, replies, and pagination. After building and installing `SwiftyChatDemo` on a booted iOS simulator, run `maestro test --udid <simulator-udid> Tests/Smoke`.

## Contributing

Contributions are welcome! Whether it's a bug fix, new feature, documentation improvement, or a new theme — we'd love your help.

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Acknowledgments

Inspired by [MessageKit](https://github.com/MessageKit/MessageKit) (UIKit) and [Nio](https://github.com/niochat/nio) (SwiftUI).

## License

SwiftyChat is available under the Apache 2.0 license. See the [LICENSE](LICENSE) file for details.
