# SwiftyChat roadmap

SwiftyChat targets iOS 17+ and macOS 14+ with 11 message kinds, five theme presets in the demo, and Kingfisher as its only package dependency. The library renders supplied link-preview metadata; it does not fetch metadata from URLs.

## Foundation completed

- Message headers follow the current message order and dates.
- Appending follows new messages only when the reader is at the bottom; prepending does not trigger a jump to the latest message.
- Quick replies, contact actions, link previews, and video controls use semantic buttons.
- Message IDs used for programmatic scrolling match the consumer's `ChatMessage.ID` type.
- Package tests cover message-list decisions, carousel button identity, video selection, viewport orientation, and empty mock batches.

## Candidates for the next product pass

1. **Streaming chatbot example:** Update a text message in place as tokens arrive and support cancellation. Measure rendering during frequent updates.
2. **Reply and delivery status:** Design optional metadata that existing `ChatMessage` conformers can adopt without adding required protocol properties.
3. **Media sending example:** Use native `PhotosPicker` for image and video selection in the demo before adding a library-level input API.
4. **Optional link metadata helper:** Fetch and cache URL metadata outside message rendering, with an explicit choice by the host app to make network requests.

Audio, reactions, search, and other message types remain open ideas. Add them when a concrete consumer flow and API design justify them.

## Performance gate

Profile long chats, pagination, and repeated same-message updates with SwiftUI Instruments before changing Markdown parsing or custom layout caching. See [performance notes](PERFORMANCE_IMPROVEMENTS.md).
