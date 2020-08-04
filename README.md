# SwiftyChat

### Content
* [About](#about)
* [Quick Preview](#quick-preview)
* [Installation](#installation)
* [Message Kinds](#message-kinds)
* [Usage](#usage)
* [Style & Customization](#style-and-customization)

### About 

Simple Chat Interface to quick start with [built-in](#supported-message-kind) message cells. <br>
Fully written in pure SwiftUI.

### Quick Preview

| Contact, QuickReply, Text      | Map, Image  | ContextMenu |
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/contact_qp_text.png) | ![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/map_image.png) |  ![](https://github.com/EnesKaraosman/SwiftyChat/blob/master/Sources/SwiftyChat/Demo/Preview/contextMenu.png)
### Installation

SPM: https://github.com/EnesKaraosman/SwiftyChat.git

### Message Kinds

```swift
public enum ChatMessageKind: CustomStringConvertible {
    
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
}
```
For displaying remote images (for the `case image(.remote(URL)`) [Kingfisher](https://github.com/onevcat/Kingfisher) library used as dependency.

### Usage

- `ChatView`

```swift
@State var messages: [ChatMessage] = [] // for quick test assign MockMessages.generatedMessages()

ChatView(messages: $messages) { (proxy) -> AnyView in
    // InputView here, continue reading..
}
// ▼ Optional
.onMessageCellTapped { message in
    // You may trigger .sheet here
    // To display images in a full screen for example.
    // Or open MapView for ChatMessageKind.location case
    switch message.messageKind {
        case ..
    }
}
// ▼ Optional
.messageCellContextMenu { message -> AnyView in
    switch message.messageKind {
    case .text(let text):
        return Button(action: {
            print("Forward Context Menu tapped!!")
            // Forward text
        }) {
            Text("Forward")
            Image(systemName: "arrowshape.turn.up.right")
        }.embedInAnyView()
    default:
        // If you don't want to implement contextMenu action 
        // for a specific case, simply return EmptyView like below;
        return EmptyView().embedInAnyView()
    }
}
// ▼ Implement in case ChatMessageKind.carousel
.onCarouselItemAction { (url: URL?, message: ChatMessage) in
    // Here you can use the metadata of selected item in carousel
}
// ▼ Implement in case ChatMessageKind.quickReply
.onQuickReplyItemSelected { quickReply in
    // You may add new item to `messages`
    // Or send an information about it via network.
}
// ▼ Implement in case ChatMessageKind.contact
.contactItemButtons { (contact, message) -> [ContactCellButton] in
    return [
        .init(title: "Save", action: {
            print(contact.displayName)
        })
        ... or more
    ]
}
// ▼ Required
.environmentObject(
    // All parameters iniatilazed by default, 
    // change as you want.
    ChatMessageCellStyle()
)
...
...
```

- `InputView`

You can investigate existing `DefaultInputView` in project. <br>You can use it if it suits your need, or create a new one.<br>It's quite easy to add custom *InputView*
```swift
DefaultInputView(
    // Pass ChatView's proxy (GeometryReader in ChatView)
    proxy: GeometryProxy, 
    sendAction: (ChatMessageKind) -> Void
)

// Pass in ChatView
ChatView(messages: $messages) { (proxy) -> AnyView in
    DefaultInputView(proxy: proxy) { (messageKind) in
        let newMessage = ChatMessage(
            user: .., 
            messageKind: messageKind, 
            isSender: true
        )
        self.messages.append(newMessage)
    }
    .edgesIgnoringSafeArea(.all)
    // ▼ An extension that wraps view inside AnyView
    .embedInAnyView() 
}
...
...
```

For custom InputView you can cheat using Default one.


### Style and Customization

For detail documentation, visit [MessageCellStyles.md](https://github.com/EnesKaraosman/SwiftyChat/blob/master/MessageCellStyles.md)

### Todo
- [ ] Scroll To Bottom
- [ ] User Avatar
- [ ] HTML String support

<br>
Please feel free to contribute.


### Inspiration

A UIKit Chat library [MessageKit](https://github.com/MessageKit/MessageKit).
