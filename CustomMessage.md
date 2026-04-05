# Custom Messages

You can render any message type by registering a custom cell for `ChatMessageKind.custom`.

### 1. Register a custom cell

```swift
ChatView(messages: $messages) {
    // input view ...
}
.registerCustomCell { data in
    MyCustomCell(data: data)
}
```

The closure receives the `Any` value from `.custom(Any)` — cast it to your expected type inside your cell.

### 2. Add a custom message

```swift
MockMessages.ChatMessageItem(
    user: MockMessages.chatbot,
    messageKind: .custom("Hey! This is my custom message!"),
    isSender: false
)
```

You can pass any type — a `String`, a custom struct, a dictionary — whatever your custom cell knows how to render.
