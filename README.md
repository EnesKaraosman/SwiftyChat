![Swift 5.8](https://img.shields.io/badge/Swift-5.8-orange.svg)
![iOS 15+](https://img.shields.io/badge/iOS-15%2B-blue.svg)
![macOS 12+](https://img.shields.io/badge/macOS-12%2B-blue.svg)

# SwiftyChat

For Flutter version check [this link](https://github.com/EnesKaraosman/swifty_chat)

### Content

* [About](#about)
* [Features](#features)
* [Quick Preview](#quick-preview)
* [Installation](#installation)
* [Message Kinds](#message-kinds)
* [Usage](#usage)
* [Style & Customization](#style-and-customization)
* [Pre-built Themes](#pre-built-themes)

### About

Simple Chat Interface to quick start with [built-in](#message-kinds) message cells. <br>
Highly optimized for smooth scrolling and responsive user experience.

### Features

- [x] **High Performance**: Optimized rendering with O(n) complexity, cached formatters, and async image loading
* [x] Attributed string support that came with SwiftUI
* [x] Landscape orientation support (autoscales message cells with the given `cellWidth` property, if exists)
* [x] User Avatar (with different position options, optional usage)
* [x] Dismiss keyboard (on tapping outside)
* [x] Multiline Input Bar added (investigate [BasicInputView](../master/Sources/SwiftyChat/InputView/BasicInputView.swift))
* [x] Scroll to bottom
* [x] "Picture in Picture" background mode video playing (to enable, visit >> Xcode "Sign in and Capabilities")
* [x] Round specific corner of text messages
* [x] Implement custom message cells. See [CustomMessage.md](CustomMessage.md) for details
* [x] **Pre-built Themes**: 8 ready-to-use themes for quick customization
* [x] **Cross-platform**: Full iOS and macOS support
* [ ] Swipe to dismiss keyboard

### Quick Preview

<img src="../master/Sources/SwiftyChat/Demo/Preview/swiftyChatGIF.gif" height="240"/>

<details>
  <summary>Basic Example Preview</summary>

  | Text (Light)      | Text (Dark)  |
:-------------------------:|:-------------------------:|
<img src="../master/Sources/SwiftyChat/Demo/Preview/basic-1.png" width="240"/> | <img src="../master/Sources/SwiftyChat/Demo/Preview/basic-2.png" width="240"/>

<img src="../master/Sources/SwiftyChat/Demo/Preview/basic-3.png" height="240"/>

</details>

<details>
  <summary>Advanced Example Preview</summary>

  | Contact, QuickReply, Text, Carousel      | Map, Image  | ContextMenu |
:-------------------------:|:-------------------------:|:-------------------------:
<img src="../master/Sources/SwiftyChat/Demo/Preview/avatar_contact_qr_carousel_text.png" width="240"/> | <img src="../master/Sources/SwiftyChat/Demo/Preview/map_image.png" width="240"/> | <img src="../master/Sources/SwiftyChat/Demo/Preview/contextMenu.png" width="240"/>

</details>

### Installation

SPM: <https://github.com/EnesKaraosman/SwiftyChat.git>

### Message Kinds

```swift
public enum ChatMessageKind {
    
    /// A text message,
    /// supports emoji 👍🏻 (auto scales if text is all about emojis)
    case text(String)
    
    /// An image message, from local(UIImage) or remote(URL).
    case image(ImageLoadingKind)
    
    /// A location message, pins given location & presents on MapKit.
    case location(LocationItem)
    
    /// A contact message, generally for sharing purpose.
    case contact(ContactItem)
    
    /// Multiple options, disables itself after selection.
    case quickReply([QuickReplyItem])
    
    /// `CarouselItem`s that contains title, subtitle, image & button in a scrollable view
    case carousel([CarouselItem])
    
    /// A video message, opens the given URL.
    case video(VideoItem)
}
```

### Usage

* `ChatView`

Here below is minimum code required to get started (see up & running)<br>
For detail, visit example project [here](../master/SwiftyChatExample/Example)

```swift
import SwiftyChat
import SwiftyChatMock

@State private var scrollToBottom = false
@State private var messages: [MockMessages.ChatMessageItem] = [] // for quick test assign MockMessages.generatedMessages()

// ChatMessageItem & ChatUserItem is a sample objects/structs 
// that conforms `ChatMessage` & `ChatUser` protocols.
ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(
    messages: $messages,
    scrollToBottom: $scrollToBottom
) {
    // InputView here, continue reading..
}
// ▼ Required
.environmentObject(
    // All parameters initialized by default, 
    // change as you want.
    ChatMessageCellStyle()
)
.onReceive(
    messages.debounce(for: .milliseconds(650), scheduler: RunLoop.main),
    perform: { _ in
        scrollToBottom = true
    }
)
// ...
```

* `InputView`

You can investigate existing `BasicInputView` in project. <br>You can use it if it suits your need, or create a new one.<br>
Recommended way is just clone this `BasicInputView` and modify (ex. add camera icon etc.)

```swift

// InputBarView variables
@State private var message = ""

var inputBarView: some View {
    BasicInputView(
        message: $message, // Typed text.
        placeholder: "Type something",
        onCommit: { messageKind in
            self.messages.append(
                .init(user: MockMessages.sender, messageKind: messageKind, isSender: true)
            )
        }
    )
    .background(Color.primary.colorInvert())
    // ▼ An extension that wraps view inside AnyView
    .embedInAnyView()
}

// Pass in ChatView
ChatView(messages: $messages) {
    inputBarView 
}
...
...
```

### Style and Customization

```swift
public class ChatMessageCellStyle: ObservableObject {
    
    let incomingTextStyle: TextCellStyle
    let outgoingTextStyle: TextCellStyle
    
    let incomingCellEdgeInsets: EdgeInsets
    let outgoingCellEdgeInsets: EdgeInsets
    
    let contactCellStyle: ContactCellStyle
    
    let imageCellStyle: ImageCellStyle
    
    let quickReplyCellStyle: QuickReplyCellStyle
    
    let carouselCellStyle: CarouselCellStyle
    
    let locationCellStyle: LocationCellStyle
    
    let incomingAvatarStyle: AvatarStyle
    let outgoingAvatarStyle: AvatarStyle
    
}
```

You must initiate this class to build a proper style & inject it as `environmentObject`, <br>
All styles has default initializer; <br>

For detail documentation, visit [Styles.md](../master/Styles.md)

You can also use your own custom message cell, see [CustomMessage.md](CustomMessage.md) for details.

<br>
Please feel free to contribute.<br>

* Create PR for a feature/bug you'd like to add/fix.

### Pre-built Themes

SwiftyChat comes with 8 pre-built themes for quick customization:

| Theme | Description |
|-------|-------------|
| **Modern** | Clean blue accent with minimal design |
| **Classic** | Traditional green messaging style |
| **Dark Neon** | Cyberpunk-inspired with neon pink accents |
| **Minimal** | Subtle gray tones for a clean look |
| **Ocean** | Calming teal and sea-inspired colors |
| **Sunset** | Warm orange gradients |
| **Nature** | Fresh green, eco-friendly appearance |
| **Lavender** | Soft purple, relaxing aesthetic |

Check the Example app's `ThemeShowcaseView` for live theme switching demos.

### Inspiration

* UIKit library [MessageKit](https://github.com/MessageKit/MessageKit).
* SwiftUI library [Nio](https://github.com/niochat/nio).
