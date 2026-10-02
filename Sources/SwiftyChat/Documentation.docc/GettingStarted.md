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

``BasicInputView`` keeps the text field and send action in one adaptive surface. To include an attachment button, pass `onAttachment` and present your app's picker from the callback:

```swift
BasicInputView(
    message: $inputText,
    placeholder: "Write a message…",
    onAttachment: { isPickerPresented = true },
    onCommit: sendMessage
)
```

Omit `onAttachment` for a text-only composer.

Inject a ``ChatMessageCellStyle`` via the environment to control colors, fonts, corner radii, avatars, and more:

```swift
.environment(\.chatStyle, ChatMessageCellStyle(
    incomingTextStyle: TextCellStyle(
        textStyle: CommonTextStyle(textColor: .primary),
        cellBackgroundColor: .gray.opacity(0.2),
        cellCornerRadius: 16
    ),
    outgoingTextStyle: TextCellStyle(
        textStyle: CommonTextStyle(textColor: .white),
        cellBackgroundColor: Color(red: 0.08, green: 0.30, blue: 0.70),
        cellCornerRadius: 16
    )
))
```

Use semantic text colors on adaptive surfaces. SwiftyChat inherits the host app's color scheme; preview custom styles in both light and dark appearances.

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

## Unread Messages and Returning to the Latest Message

Pass your app's unread IDs to ``ChatView``. The first matching incoming message receives an unread divider. While the reader is above the latest message, a button displays the number of loaded unread incoming messages and scrolls to the bottom when tapped.

```swift
ChatView(messages: $messages) { /* input view */ }
    .unreadMessages(unreadMessageIDs)
    .onReachedBottom { newestID in
        markRead(through: newestID)
    }
```

Your app owns unread state and read persistence. The callback reports the newest message when it is reached; update your unread IDs after handling it. Unknown IDs and outgoing messages do not contribute to the displayed count. The initial conversation still opens at the bottom. To enable only the button, use `.showsScrollToBottomButton()`; `.showsScrollToBottomButton(false)` can hide it after configuring unread indicators.

## Navigate Replies and Retry Failed Messages

Add optional `replyToMessageID` to your message model, using the same type as its `id`. Existing conformances inherit `nil`.

```swift
var replyPreview: ChatMessageQuote?
var replyToMessageID: UUID?
var deliveryStatus: MessageDeliveryStatus?
```

A quote with a loaded target becomes a button and scrolls to that message. Register `.onReplyPreviewTapped` if your app needs to load a missing original. The callback receives the reply message, including its target ID; after loading history, use the existing `scrollTo` binding to navigate. Without a loaded target or handler, the quote stays noninteractive.

```swift
ChatView(messages: $messages, scrollTo: $scrollTarget) { /* input view */ }
    .onReplyPreviewTapped { reply in
        loadOriginalIfNeeded(for: reply)
    }
    .onRetryMessage { message in
        resend(message)
    }
```

The retry handler adds a button only to failed outgoing messages. Your app performs the send and updates `deliveryStatus`; changing it to `.sending` removes the retry action. The demo changes it directly to `.sent` to illustrate the callback without a transport service.

## Next Steps

- Browse the [SwiftyChatDemo app](https://github.com/EnesKaraosman/SwiftyChat/tree/master/SwiftyChatDemo) for complete examples
- See ``ChatMessageKind`` for all 11 supported message types
- Check ``ChatMessageCellStyle`` for full style customization
