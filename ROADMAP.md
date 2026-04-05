# SwiftyChat — Strategic Analysis & Roadmap

## Current Position

| Metric | SwiftyChat | Exyte/Chat | MessageKit |
|--------|-----------|------------|------------|
| Stars | 331 | 1,700 | 6,300 |
| Platform | SwiftUI (iOS/macOS) | SwiftUI (iOS) | UIKit |
| Message types | 9 + custom | ~8 + custom | ~8 |
| License | Apache 2.0 | MIT | MIT |

## Strengths (Keep/Protect)

- **Chatbot-first message types** — carousel, quick reply, loading indicator. Competitors don't have these.
- **Cross-platform** — iOS + macOS from a single codebase. Most competitors are iOS-only.
- **Theming system** — 8 built-in themes, environment-based `ChatMessageCellStyle`.
- **Performance** — O(n) metadata caching, shared DateFormatter, Equatable cells, LazyVStack.
- **Zero open issues** — well-maintained.

## Feature Gaps vs. Competitors

### High Impact

1. **Reply/Quote messages** — Swipe-to-reply with a quoted message preview. Requires a new `ChatMessageKind` case or a `replyTo` property on `ChatMessage`.
2. **Audio messages** — Record and play voice messages with waveform visualization. New `.audio(AudioItem)` message kind.
3. **Link previews** — Auto-detect URLs in text and show Open Graph previews. Could be a new `.linkPreview` kind or auto-detected within `.text`.
4. **Reactions/Emoji reactions** — Tap-and-hold to add emoji reactions. Overlay on any message type.
5. **Media picker integration** — Built-in `PhotosPicker` for sending images/videos.

### Medium Impact

6. **Swipe actions** — Swipe-to-reply, swipe-to-delete.
7. **Message status indicators** — Sent / delivered / read (single check, double check, blue check). A `MessageStatus` enum on `ChatMessage`.
8. **Typing indicator** — First-class API for "User is typing..." (`.loading` exists but isn't surfaced well).
9. **GIF/Sticker support** — Animated image messages via Giphy or similar.
10. **Search within chat** — Highlight and scroll to matching messages.

## Existing Code Improvements

### API Modernization

- **Drop `AnyView` type erasure** — `inputView: () -> AnyView` and `customCellView: (Any) -> AnyView` lose type safety and hurt diffing performance. Use `@ViewBuilder` generics instead.
- **Replace `then()` modifier pattern** — Chainable modifiers (`.onMessageCellTapped`, `.registerCustomCell`, etc.) mutate copies via `then()`. Consider `ViewModifier` or preference keys.
- **`ChatMessage` protocol is rigid** — Adding replies, reactions, or status requires breaking protocol changes. Use optional properties with defaults.

### Performance

- **Metadata cache index bug** — In `rebuildMessageMetadataCache()` and `buildInitialCache()`, `prevMessage` uses `messages[index]` and `currMessage` uses `messages[index - 1]` — names are swapped. Date headers may appear at wrong boundaries.
- **Image prefetching** — No prefetching for messages about to scroll into view. Kingfisher supports this.

### Customization

- **Composable input view** — Add slots for leading actions (attachments), trailing actions (voice record), and text field customization.
- **Message grouping** — Consecutive same-sender messages could be visually grouped (merged bubbles like iMessage).
- **Custom date headers** — Currently hardcoded in `MessageRow`. Allow consumers to provide a custom date header view.

## Roadmap

### Phase 1 — Foundation Cleanup (v3.1)

- [x] Fix the metadata cache index bug
- [x] Replace `AnyView` with generic view builders
- [ ] Make `ChatMessage` protocol more extensible (optional `replyTo`, `status`, `reactions` with defaults)
- [ ] Composable input view with leading/trailing action slots

### Phase 2 — Catch Up to Competitors (v4.0)

- [ ] Reply/quote messages
- [ ] Message status indicators (sent/delivered/read)
- [ ] Typing indicator as first-class API
- [ ] Link preview detection
- [ ] Swipe gestures (reply, delete)

### Phase 3 — Differentiate (v4.x)

- [ ] Audio messages with waveform
- [ ] Emoji reactions overlay
- [ ] Built-in PhotosPicker integration
- [ ] Message search
- [ ] visionOS support
- [ ] Animated messages (GIF support)
- [ ] Streaming text support (character-by-character, for AI/chatbot use cases)

## Strategic Positioning

Lean into what makes SwiftyChat unique rather than matching Exyte/Chat feature-for-feature:

1. **Chatbot/AI chat UI** — Huge demand for chat UIs that support structured responses (carousels, quick replies, loading states, streaming text). Position as the go-to SwiftUI library for AI/chatbot interfaces.
2. **Cross-platform** — Push macOS support, add visionOS. Few competitors do this.
3. **Lightweight & composable** — Stay simple to integrate. No bundled backends or heavy dependencies.

**Target positioning:** *"The lightweight, cross-platform SwiftUI chat UI — especially good for AI/chatbot apps."*
