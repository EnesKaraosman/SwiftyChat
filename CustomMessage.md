# Custom Messages

You can render any message type by registering a custom cell for `ChatMessageKind.custom`.

### 1. Register a custom cell

```swift
ChatView(messages: $messages) {
    // input view ...
}
.registerCustomCell { data in
    Label(data as? String ?? "", systemImage: "puzzlepiece.extension")
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
}
```

The closure receives the `Any` value from `.custom(Any)` — cast it to your expected type inside your cell.

### 2. Add a custom message

```swift
import SwiftyChatMock

MessageMocker.ChatMessageItem(
    user: MessageMocker.chatbot,
    messageKind: .custom("Your own SwiftUI content"),
    isSender: false
)
```

You can pass any type — a `String`, a custom struct, a dictionary — whatever your custom cell knows how to render.

### 3. Check both appearances

Custom cells inherit the host's color scheme. The example above uses the default semantic foreground and a `.quaternary` background, so its colors adapt automatically.

| Light | Dark |
|:---:|:---:|
| <img src="Documentation/Images/components/custom-light.png" width="320" alt="Custom SwiftUI label in light mode"/> | <img src="Documentation/Images/components/custom-dark.png" width="320" alt="Custom SwiftUI label in dark mode"/> |

Preview custom foreground/background combinations in both modes. See the [style guide](Styles.md) and [appearance checks](Documentation/Appearance.md) for more examples.
