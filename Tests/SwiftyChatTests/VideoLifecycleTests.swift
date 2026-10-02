import Testing
@testable import SwiftyChat
import SwiftyChatMock

@Suite @MainActor struct VideoLifecycleTests {
    @Test func latestSelectionWins() async throws {
        let manager = VideoManager<MessageMocker.ChatMessageItem>()
        let first = MessageMocker.generate(kind: .video)
        let second = MessageMocker.generate(kind: .video)

        manager.play(first)
        let firstPlayback = try #require(manager.pendingPlaybackTask)
        manager.play(second)
        let secondPlayback = try #require(manager.pendingPlaybackTask)
        await firstPlayback.value
        await secondPlayback.value

        #expect(firstPlayback.isCancelled)
        #expect(manager.message?.id == second.id)
    }

    @Test func closingCancelsPendingSelection() async throws {
        let manager = VideoManager<MessageMocker.ChatMessageItem>()

        manager.play(MessageMocker.generate(kind: .video))
        let playback = try #require(manager.pendingPlaybackTask)
        manager.flushState()
        await playback.value

        #expect(playback.isCancelled)
        #expect(manager.message == nil)
    }
}
