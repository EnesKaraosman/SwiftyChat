# Performance notes

SwiftyChat uses a `LazyVStack` for message rows and calculates date and sender metadata in one pass over the current messages. This keeps headers correct when messages are edited, reordered, appended, or prepended. A shared `DateFormatter` formats visible date headers. Kingfisher loads remote images.

These are implementation choices, not benchmark results. The repository does not currently have a measured frame-rate or memory baseline.

## What to measure next

Use [SwiftUI Instruments](https://developer.apple.com/documentation/Xcode/understanding-and-improving-swiftui-performance) with long conversations, rapid scrolling, pagination, and repeated edits to one message. Record update frequency, long view updates, hitches, and allocations on iOS and macOS.

Two paths deserve attention if a trace identifies them as hot:

- `TextMessageView` parses Markdown and creates an `NSDataDetector` in its initializer. SwiftUI can recreate the view when its parent updates, so this is not a cache across updates.
- `FlowLayout` measures rows in both `sizeThatFits` and `placeSubviews`.

Keep a before-and-after trace with any performance change. Avoid claiming a frame rate from build success or a small synthetic test.
