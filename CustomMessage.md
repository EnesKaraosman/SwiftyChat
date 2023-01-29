# swifty_chat

### Custom Message

To create a custom message and look (`MessageKind.custom`) follow these steps below;

1) Register a new custom message cell.

```swift
ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(messages: $messages) {
    // [...]
}
    // ▼ Optional, Implement to register a custom cell for Messagekind.custom. CustomExampleChatCell is an example View.
    .registerCustomCell(customCell: {anyParam in AnyView(CustomExampleChatCell(anyParam: anyParam))})
```

Since `customCell` has the type `(Any) -> AnyView` you can register any View and pass Any type.

Be aware that you need to cast `anyParam` in `CustomExampleChatCell` to the expaced type

2) Add a message to your dataSource with the `MessageKind.custom(dynamic custom)` option.

Since `.custom` constructor expects a `dynamic` parameter you can pass any type.

```swift
MockMessages.ChatMessageItem(
    user: MockMessages.chatbot,
    messageKind: .custom("⚙️ Hey! This is my custom message!!!! ⚙️),
    isSender: false
)
```
