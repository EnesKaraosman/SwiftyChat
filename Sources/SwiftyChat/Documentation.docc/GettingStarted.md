# Getting Started with SwiftyChat

Set up a chat interface in your SwiftUI app in minutes.

## Overview

SwiftyChat requires two things: a message model conforming to ``ChatMessage`` and a user model conforming to ``ChatUser``. Once you have those, you can drop ``ChatView`` into your view hierarchy.

## Define Your Models

```swift
struct User: ChatUser {
    var id = UUID().uuidString
    var userName: String
    var avatar: PlatformImage?
    var avatarURL: URL?
}

struct Message: ChatMessage {
    let id = UUID()
    var user: User
    var messageKind: ChatMessageKind
    var isSender: Bool
    var date: Date = .init()
}
```

## Add ChatView

```swift
import SwiftyChat

let currentUser = User(userName: "Alice")

struct ContentView: View {
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var scrollToBottom = false

    var body: some View {
        ChatView(messages: $messages, scrollToBottom: $scrollToBottom) {
            BasicInputView(
                message: $inputText,
                placeholder: "Type a message...",
                onCommit: { messageKind in
                    messages.append(Message(
                        user: currentUser,
                        messageKind: messageKind,
                        isSender: true
                    ))
                }
            )
        }
        .environment(\.chatStyle, ChatMessageCellStyle())
    }
}
```

## Customize the Style

Inject a ``ChatMessageCellStyle`` via the environment to control colors, fonts, corner radii, avatars, and more:

```swift
.environment(\.chatStyle, ChatMessageCellStyle(
    incomingTextStyle: TextCellStyle(
        cellBackgroundColor: .gray.opacity(0.2),
        cellCornerRadius: 16
    ),
    outgoingTextStyle: TextCellStyle(
        textStyle: CommonTextStyle(textColor: .white),
        cellBackgroundColor: .blue,
        cellCornerRadius: 16
    )
))
```

## Handle Interactive Messages

Use view modifiers on ``ChatView`` to respond to user interactions:

```swift
ChatView(messages: $messages) { /* input view */ }
    .onQuickReplyItemSelected { reply in
        // User tapped a quick reply button
    }
    .onCarouselItemAction { button, message in
        // User tapped a carousel card button
    }
    .onLinkPreviewTapped { url, message in
        // User tapped a link preview
    }
    .contactItemButtons { contact, message in
        [ContactCellButton(title: "Call", action: { /* ... */ })]
    }
```

## Next Steps

- Browse the [SwiftyChatDemo app](https://github.com/EnesKaraosman/SwiftyChat/tree/master/SwiftyChatDemo) for complete examples
- See ``ChatMessageKind`` for all 11 supported message types
- Check ``ChatMessageCellStyle`` for full style customization
