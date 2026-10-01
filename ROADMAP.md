# SwiftyChat roadmap

SwiftyChat targets iOS 17+ and macOS 14+ with 11 message kinds, five theme presets in the demo, and Kingfisher as its only package dependency. Link metadata fetching is an explicit, optional API call.

## Foundation completed

- Message headers follow the current message order and dates.
- Appending follows new messages only when the reader is at the bottom; prepending does not trigger a jump to the latest message.
- Quick replies, contact actions, link previews, and video controls use semantic buttons.
- Message IDs used for programmatic scrolling match the consumer's `ChatMessage.ID` type.
- Package tests cover message-list decisions, carousel button identity, video selection, viewport orientation, and empty mock batches.
- Simulator smoke flows cover initial position, pagination, streaming, sending, and reply context menus.
- The text-chat demo exercises older-message loading, cancellable streaming replies, reply quotes, and delivery status. On iOS it also accepts photos and videos with PhotosPicker.
- Existing `ChatMessage` conformers can omit reply and delivery metadata. `LinkPreviewMetadataLoader` caches successful title/host fetches and shares concurrent requests for the same URL.

## Candidates for the next product pass

1. **Link preview richness:** Decide whether the UI should accept local preview images as well as remote image URLs. LinkPresentation does not expose a description or remote image URL through `LPLinkMetadata`.
2. **Delivery transitions:** Connect optional delivery status to a real transport layer in a consuming app. The demo shows static states.
3. **Media input API:** Promote the demo's picker flow into the library only if consumers need a shared attachment interface.

Audio, reactions, search, and other message types remain open ideas. Add them when a concrete consumer flow and API design justify them.

## Performance gate

Profile long chats, pagination, and repeated same-message updates with SwiftUI Instruments before changing Markdown parsing or custom layout caching. See [performance notes](PERFORMANCE_IMPROVEMENTS.md).
