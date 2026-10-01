import Foundation
import Testing
@testable import SwiftyChat
import SwiftyChatMock

@Suite struct MessageListTests {
    private let alice = MessageMocker.ChatUserItem(userName: "Alice")
    private let bob = MessageMocker.ChatUserItem(userName: "Bob")
    private let start = Date(timeIntervalSince1970: 1_000)

    @Test func metadataUsesCurrentOrderAndSender() {
        let first = message(user: alice, at: start)
        let second = message(user: alice, at: start.addingTimeInterval(30))
        let third = message(user: bob, at: start.addingTimeInterval(60))

        let metadata = MessageMetadataBuilder.build(
            [first, second, third],
            dateHeaderTimeInterval: 3_600,
            shouldShowGroupChatHeaders: true
        )

        #expect(metadata[first.id] == .init(showDateHeader: true, showDisplayName: true))
        #expect(metadata[second.id] == .init(showDateHeader: false, showDisplayName: false))
        #expect(metadata[third.id] == .init(showDateHeader: false, showDisplayName: true))
    }

    @Test func metadataReflectsSameCountReorderAndDateEdit() {
        let first = message(user: alice, at: start)
        var second = message(user: bob, at: start.addingTimeInterval(30))
        second.date = start.addingTimeInterval(7_200)

        let metadata = MessageMetadataBuilder.build(
            [second, first],
            dateHeaderTimeInterval: 3_600,
            shouldShowGroupChatHeaders: true
        )

        #expect(metadata[second.id] == .init(showDateHeader: true, showDisplayName: true))
        #expect(metadata[first.id] == .init(showDateHeader: false, showDisplayName: true))
    }

    @Test func followsAppendOnlyWhenReaderIsAtBottom() {
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [1, 2], newIDs: [1, 2, 3], visibleBottomID: 2) == 3)
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [1, 2], newIDs: [1, 2, 3], visibleBottomID: 1) == nil)
    }

    @Test func preservesPositionWhenHistoryIsPrepended() {
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [3, 4], newIDs: [1, 2, 3, 4], visibleBottomID: 4) == nil)
    }

    private func message(user: MessageMocker.ChatUserItem, at date: Date) -> MessageMocker.ChatMessageItem {
        .init(user: user, messageKind: .text("Hello"), date: date)
    }
}
