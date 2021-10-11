![Version](https://img.shields.io/badge/version-2.0.1-blue)
![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg)

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

### About 

Simple Chat Interface to quick start with [built-in](#message-kinds) message cells. <br>
Fully written in pure SwiftUI.

### Features
- [x] HTML String support like `<li>, <a>` (not like h1 or font based tag)
- [x] Attributed string support that contains address, date, phoneNumber, url (text is automatically scanned)
- [x] Landscape orientation  support (autoscales message cells with the given `cellWidth` property, if exists)
- [x] User Avatar (with different position options, optional usage)
- [x] Dismiss keyboard (on tapping outside).
- [x] Multiline Input Bar added (investigate [BasicInputView](../master/Sources/SwiftyChat/InputView/BasicInputView.swift))
- [x] Scroll to bottom.
- [x] Round specific corner of text messages.
- [ ] Swipe to dismiss keyboard.


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

SPM: https://github.com/EnesKaraosman/SwiftyChat.git

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

- `ChatView`

Here below is minimum code required to get started (see up & running)<br> 
For detail, visit example project [here](../master/SwiftyChatExample/SwiftyChatExample)

```swift
@State var messages: [MockMessages.ChatMessageItem] = [] // for quick test assign MockMessages.generatedMessages()

// ChatMessageItem & ChatUserItem is a sample objects/structs 
// that conforms `ChatMessage` & `ChatUser` protocols.
ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem> {
    // InputView here, continue reading..
}
// ▼ Required
.environmentObject(
    // All parameters initialized by default, 
    // change as you want.
    ChatMessageCellStyle()
)
...
...
```

- `InputView`

You can investigate existing `BasicInputView` in project. <br>You can use it if it suits your need, or create a new one.<br>
Recommended way is just clone this `BasicInputView` and modify (ex. add camera icon etc.)
```swift

// InputBarView variables
@State private var message = ""
@State private var isEditing = false

var inputBarView: some View {
    BasicInputView(
        message: $message, // Typed text.
        isEditing: $isEditing,
        placeholder: "Type something",
        onCommit: { messageKind in
            self.messages.append(
                .init(user: MockMessages.sender, messageKind: messageKind, isSender: true)
            )
        }
    )
    .padding(8)
    .padding(.bottom, isEditing ? 0 : 8)
    .accentColor(.chatBlue)
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

<br>
Please feel free to contribute.<br>
* Create PR for a feature/bug you'd like to add/fix.

### Dependencies

* [Kingfisher](https://github.com/onevcat/Kingfisher.git) : Image downloading library.
* [VideoPlayer](https://github.com/wxxsw/VideoPlayer.git) : VideoPlayer library.

### Inspiration

* UIKit library [MessageKit](https://github.com/MessageKit/MessageKit).
* SwiftUI library [Nio](https://github.com/niochat/nio).
