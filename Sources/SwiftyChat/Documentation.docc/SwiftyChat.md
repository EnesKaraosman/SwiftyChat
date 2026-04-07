# ``SwiftyChat``

A lightweight, cross-platform SwiftUI chat UI framework with built-in message types, theming, and chatbot support.

## Overview

SwiftyChat provides a ready-to-use chat interface for iOS 17+ and macOS 14+. It ships with 11 message types, 8 pre-built themes, and full style customization — so you can focus on your app logic instead of building chat UI from scratch.

```swift
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
```

## Topics

### Essentials

- <doc:GettingStarted>
- ``ChatView``
- ``BasicInputView``

### Message Types

- ``ChatMessageKind``
- ``ChatMessage``
- ``ChatUser``

### Styling

- ``ChatMessageCellStyle``
- ``TextCellStyle``
- ``CarouselCellStyle``
- ``QuickReplyCellStyle``
- ``ImageCellStyle``
- ``LocationCellStyle``
- ``ContactCellStyle``
- ``AvatarStyle``
- ``LinkPreviewCellStyle``

### Item Protocols

- ``QuickReplyItem``
- ``CarouselItem``
- ``ContactItem``
- ``LocationItem``
- ``VideoItem``
- ``LinkPreviewItem``
