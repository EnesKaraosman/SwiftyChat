# Performance baseline

Measured on 2026-10-02 against the 4.3.0 source (release commit `f05143ad5ad7f2addec57db11cfd804a953a14b3`). No production code was changed for this baseline.

## Message processing

Environment: Apple M5 Max, arm64 macOS 27, Swift 6.4 / Xcode 27. Run:

```sh
SWIFTYCHAT_BENCHMARK=1 swift test -c release --filter PerformanceBaselineTests
```

The opt-in benchmark is skipped during ordinary `swift test`. Each case has four warm-up iterations and 21 recorded samples. Input construction is excluded, except the `older + messages` allocation explicitly included in pagination. Messages have integer IDs, one sender identity, one-second date spacing, and the last 100 incoming messages are unread. Results apply to this fixture; different ID/user implementations can change costs. No timing thresholds are enforced in CI.

| Loaded messages | Metadata median / p95 (ms) | Unread median / p95 (ms) | Prepend 50 + metadata median / p95 (ms) |
| ---: | ---: | ---: | ---: |
| 1,000 | 0.439 / 0.470 | 0.108 / 0.115 | 0.442 / 0.482 |
| 10,000 | 3.946 / 4.177 | 1.001 / 1.030 | 4.262 / 4.441 |
| 50,000 | 19.741 / 19.984 | 5.093 / 5.158 | 20.797 / 21.654 |

[Raw results](Benchmarks/4.3.0-macos.txt) · [Benchmark source](../Tests/SwiftyChatTests/PerformanceBaselineTests.swift).

Re-run on 2026-11-15 against 5.0.1 (Swift 6.2 minimum, Kingfisher 8.14) on the same machine with Swift 6.4: every median is within 10% of the 4.3.0 value, and the metadata and prepend cases at 10,000 and 50,000 messages are within 2% (for example 3.999 ms metadata at 10,000 messages and 19.886 ms at 50,000). [Raw 5.0.1 results](Benchmarks/5.0.1-macos.txt).

`ChatView.body` calculates metadata and unread navigation from the loaded messages. The measured costs grow roughly linearly. At 50,000 messages, metadata alone exceeds a 16.7 ms frame interval on this Mac. This makes repeated full-history processing a candidate for investigation, but these are operation timings, not UI frame times or a measured hitch rate. SwiftUI invalidation frequency, device performance, rendering, text parsing, and image loading are outside this benchmark.

Before changing this path, profile 10,000 loaded messages on a physical device while streaming one message and prepending history. If this work is significant in the trace, consider reducing repeated metadata work. Preserve existing same-count reorder, date-edit, sender-grouping, unread, and pagination behavior; a count-only cache would be incorrect.

## Next measurements

- Release build, 10,000 messages: rapid scrolling, history prepend, and streaming. Record SwiftUI updates and Animation Hitches.
- Repeat image/video open-close cycles with fixed local assets. Record allocations and memory after dismissal; distinguish image cache retention from leaked players.
- Repeat on an older supported iPhone and on macOS. Keep the input fixture and before/after traces with any optimization.

## Accessibility

The Dynamic Type and VoiceOver label work this baseline originally listed shipped in 5.0.0. See [Accessibility](Accessibility.md) for what is covered and the remaining hands-on VoiceOver pass.
