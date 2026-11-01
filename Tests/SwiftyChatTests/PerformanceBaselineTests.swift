import Foundation
import Testing
@testable import SwiftyChat
import SwiftyChatMock

@Suite(.enabled(if: ProcessInfo.processInfo.environment["SWIFTYCHAT_BENCHMARK"] == "1"))
struct PerformanceBaselineTests {
    @Test func longConversationProcessing() {
        let user = MessageMocker.ChatUserItem(userName: "Benchmark")
        let start = Date(timeIntervalSince1970: 1_000)
        for count in [1_000, 10_000, 50_000] {
            let messages = (0..<count).map {
                BenchmarkMessage(id: $0, user: user, date: start.addingTimeInterval(Double($0)))
            }
            let unread = Set((count - 100)..<count)
            measure("metadata", count: count) {
                MessageMetadataBuilder.build(messages, dateHeaderTimeInterval: 3_600,
                                             shouldShowGroupChatHeaders: true).count
            }
            measure("unread", count: count) {
                MessageNavigationState(messages: messages, unreadMessageIDs: unread).unreadCount
            }
            let older = (-50..<0).map {
                BenchmarkMessage(id: $0, user: user, date: start.addingTimeInterval(Double($0)))
            }
            measure("prepend50+metadata", count: count) {
                MessageMetadataBuilder.build(older + messages, dateHeaderTimeInterval: 3_600,
                                             shouldShowGroupChatHeaders: true).count
            }
        }
    }

    private func measure(_ operation: String, count: Int, body: () -> Int) {
        var samples: [Double] = []
        var checksum = 0
        for iteration in 0..<25 {
            let start = ContinuousClock.now
            checksum += body()
            let duration = start.duration(to: .now).components
            if iteration >= 4 {
                samples.append(Double(duration.seconds) * 1_000 + Double(duration.attoseconds) / 1e15)
            }
        }
        samples.sort()
        #expect(checksum > 0)
        print("BENCHMARK \(operation) n=\(count) median_ms=\(samples[samples.count / 2]) p95_ms=\(samples[Int(Double(samples.count - 1) * 0.95)]) checksum=\(checksum)")
    }
}

private struct BenchmarkMessage: ChatMessage {
    let id: Int
    let user: MessageMocker.ChatUserItem
    let date: Date
    let messageKind: ChatMessageKind = .text("Benchmark message")
    let isSender = false
}
