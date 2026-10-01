import Testing
@testable import SwiftyChat
import SwiftyChatMock

@Suite @MainActor struct VideoLifecycleTests {
    @Test func latestSelectionWins() async throws {
        let manager = VideoManager<MessageMocker.ChatMessageItem>()
        let first = MessageMocker.generate(kind: .video)
        let second = MessageMocker.generate(kind: .video)

        manager.play(first)
        manager.play(second)
        try await Task.sleep(for: .milliseconds(150))

        #expect(manager.message?.id == second.id)
    }

    @Test func closingCancelsPendingSelection() async throws {
        let manager = VideoManager<MessageMocker.ChatMessageItem>()

        manager.play(MessageMocker.generate(kind: .video))
        manager.flushState()
        try await Task.sleep(for: .milliseconds(150))

        #expect(manager.message == nil)
    }
}
