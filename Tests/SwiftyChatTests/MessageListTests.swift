import Foundation
import SwiftUI
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

    @Test func reportsTopOnceUntilOldestMessageChanges() {
        var tracker = TopReachTracker<Int>()

        let first = tracker.shouldReport(10)
        let repeatVisit = tracker.shouldReport(10)
        let newOldest = tracker.shouldReport(5)

        #expect(first)
        #expect(!repeatVisit)
        #expect(newOldest)
    }

    @Test @MainActor func supportsNonUUIDMessageIDsForScrolling() {
        let message = IntMessage(id: 42, user: alice, date: start)
        let scrollTarget = Binding<Int?>.constant(42)

        _ = ChatView(messages: .constant([message]), scrollTo: scrollTarget) {
            EmptyView()
        }
    }

    @Test func identicalCarouselButtonsHaveDistinctIDs() {
        let first = CarouselItemButton(title: "Open")
        let second = CarouselItemButton(title: "Open")

        #expect(first.id != second.id)
    }

    private func message(user: MessageMocker.ChatUserItem, at date: Date) -> MessageMocker.ChatMessageItem {
        .init(user: user, messageKind: .text("Hello"), date: date)
    }
}

private struct IntMessage: ChatMessage {
    let id: Int
    let user: MessageMocker.ChatUserItem
    let date: Date
    let messageKind: ChatMessageKind = .text("Hello")
    let isSender = false
}
