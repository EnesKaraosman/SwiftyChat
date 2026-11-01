# Performance baseline and accessibility follow-up

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

`ChatView.body` calculates metadata and unread navigation from the loaded messages. The measured costs grow roughly linearly. At 50,000 messages, metadata alone exceeds a 16.7 ms frame interval on this Mac. This makes repeated full-history processing a candidate for investigation, but these are operation timings, not UI frame times or a measured hitch rate. SwiftUI invalidation frequency, device performance, rendering, text parsing, and image loading are outside this benchmark.

Before changing this path, profile 10,000 loaded messages on a physical device while streaming one message and prepending history. If this work is significant in the trace, consider reducing repeated metadata work. Preserve existing same-count reorder, date-edit, sender-grouping, unread, and pagination behavior; a count-only cache would be incorrect.

## Simulator navigation and memory observation

The iOS 27 iPhone 18 Pro simulator passed the composer, unread navigation, reply navigation, long-message navigation, and pagination smoke flows on the release source. An additional bounded scroll/burst scenario and eight up/down scroll cycles completed.

During a 30-second window around the scroll scenario, one sample per second of the demo process's host `ps` RSS ranged from **417.813 to 417.875 MiB**, ending at **417.875 MiB**. This was a warm Debug demo after smoke tests, with the normal demo history, not the 10,000-message fixture. The interval included automation startup and only part of the scroll run. It is not a cold-start footprint, media-cache measurement, leak test, or device-memory budget. [Raw RSS samples](Benchmarks/4.3.0-simulator-rss.csv).

Instruments Activity Monitor recording was attempted, but the simulator reported “Activity monitoring service not available on this device.” No valid Activity Monitor trace or FPS result was obtained. The narrow RSS observation does not establish memory safety for large media histories.

Remaining device measurements:

- Release build, 10,000 messages: rapid scrolling, history prepend, and streaming. Record SwiftUI updates and Animation Hitches.
- Repeat image/video open-close cycles with fixed local assets. Record allocations and memory after dismissal; distinguish image cache retention from leaked players.
- Repeat on an older supported iPhone and on macOS. Keep the input fixture and before/after traces with any optimization.

## Next accessibility work

The existing composer has labeled attachment/send buttons and 44-point hit areas. Default text styles use semantic fonts. The next change should preserve these and focus on:

1. **Dynamic Type layout:** test all message types at the largest accessibility size and narrow width. Inspect the contact action footer's fixed 40-point height, video controls' 40-point height, and line limits in link/carousel cards. Prefer a minimum height or expanding layout where truncation or clipping is reproduced.
2. **VoiceOver navigation:** verify reading order for sender, message, quote, delivery state, and retry; verify focus after “scroll to latest” and quote navigation. Decide whether unread arrivals need an opt-in announcement without interrupting reading.
3. **Repeatable checks:** extend component rendering coverage to accessibility text sizes, and add native accessibility audits where supported. Automation finding labeled buttons is not equivalent to a VoiceOver usability check.

These are scoped follow-up tasks, not confirmed accessibility regressions. No global cache, dependency, or public API was added based solely on the benchmark.
