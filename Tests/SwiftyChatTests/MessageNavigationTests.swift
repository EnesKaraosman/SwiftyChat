import Foundation
import Testing
@testable import SwiftyChat
import SwiftyChatMock

@Suite struct MessageNavigationTests {
    @Test func unreadMessagesFollowConversationOrder() {
        let messages = [message(30), message(10), message(20)]

        let state = MessageNavigationState(messages: messages, unreadMessageIDs: [10, 20])

        #expect(state.firstUnreadID == 10)
        #expect(state.unreadCount == 2)
    }

    @Test func ignoresOutgoingAndUnloadedUnreadIDs() {
        let messages = [message(1, isSender: true), message(2), message(3)]

        let state = MessageNavigationState(messages: messages, unreadMessageIDs: [1, 3, 99])

        #expect(state.firstUnreadID == 3)
        #expect(state.unreadCount == 1)
    }

    @Test func removingUnreadMessagesRemovesTheirIndicator() {
        let state = MessageNavigationState(messages: [message(1)], unreadMessageIDs: [2])

        #expect(state.firstUnreadID == nil)
        #expect(state.unreadCount == 0)
    }

    @Test func emptyConversationHasNoNavigationTarget() {
        let state = MessageNavigationState(messages: [IntMessage](), unreadMessageIDs: [1])

        #expect(state.firstUnreadID == nil)
        #expect(state.unreadCount == 0)
    }

    @Test func partiallyVisibleLastMessageIsNotRead() {
        let bottom = MessageBottomPosition(messageID: 3, maxY: 1_200)
        let viewport = CGRect(x: 0, y: 100, width: 400, height: 600)

        #expect(bottom.reachedMessageID(in: viewport, lastMessageID: 3) == nil)
    }

    @Test func reachingTheLastMessageBottomCanMarkItRead() {
        let bottom = MessageBottomPosition(messageID: 3, maxY: 699)
        let viewport = CGRect(x: 0, y: 100, width: 400, height: 600)

        #expect(bottom.reachedMessageID(in: viewport, lastMessageID: 3) == 3)
    }

    @Test func staleGeometryCannotMarkANewAppendRead() {
        let bottom = MessageBottomPosition(messageID: 3, maxY: 699)
        let viewport = CGRect(x: 0, y: 100, width: 400, height: 600)

        #expect(bottom.reachedMessageID(in: viewport, lastMessageID: 4) == nil)
        #expect(bottom.reachedMessageID(in: .zero, lastMessageID: 3) == nil)
    }

    @Test func followsAppendsWhileAnEarlierFollowIsPending() {
        let target = MessageScrollPolicy.targetAfterUpdate(
            oldIDs: [1, 2], newIDs: [1, 2, 3],
            visibleBottomID: nil, pendingAutoScrollID: 2
        )

        #expect(target == 3)
    }

    @Test func staleOrCancelledFollowRequestsDoNotPullTheReaderDown() {
        for pendingID: Int? in [1, nil] {
            let target = MessageScrollPolicy.targetAfterUpdate(
                oldIDs: [1, 2], newIDs: [1, 2, 3],
                visibleBottomID: nil, pendingAutoScrollID: pendingID
            )

            #expect(target == nil)
        }
    }

    private func message(_ id: Int, isSender: Bool = false) -> IntMessage {
        IntMessage(id: id, isSender: isSender)
    }
}

private struct IntMessage: ChatMessage {
    let id: Int
    let isSender: Bool
    let user = MessageMocker.chatbot
    let date = Date(timeIntervalSince1970: 0)
    let messageKind = ChatMessageKind.text("Navigation test")
}
