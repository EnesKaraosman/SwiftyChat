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

    @Test func dateHeaderThresholdIsStrictAndGroupNamesAreOptional() {
        let first = message(user: alice, at: start)
        let second = message(user: bob, at: start.addingTimeInterval(3_600))
        let third = message(user: bob, at: start.addingTimeInterval(7_201))

        let metadata = MessageMetadataBuilder.build(
            [first, second, third],
            dateHeaderTimeInterval: 3_600,
            shouldShowGroupChatHeaders: false
        )

        #expect(metadata[first.id] == .init(showDateHeader: true, showDisplayName: false))
        #expect(metadata[second.id] == .init(showDateHeader: false, showDisplayName: false))
        #expect(metadata[third.id] == .init(showDateHeader: true, showDisplayName: false))
    }

    @Test func buildsMetadataForLargeHistory() {
        let messages = (0..<10_000).map {
            IntMessage(id: $0, user: alice, date: start.addingTimeInterval(Double($0)))
        }

        let metadata = MessageMetadataBuilder.build(
            messages,
            dateHeaderTimeInterval: 3_600,
            shouldShowGroupChatHeaders: true
        )

        #expect(metadata.count == messages.count)
        #expect(metadata[0] == .init(showDateHeader: true, showDisplayName: true))
        #expect(metadata[9_999] == .init(showDateHeader: false, showDisplayName: false))
    }

    @Test func followsAppendOnlyWhenReaderIsAtBottom() {
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [1, 2], newIDs: [1, 2, 3], visibleBottomID: 2) == 3)
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [1, 2], newIDs: [1, 2, 3], visibleBottomID: 1) == nil)
    }

    @Test func initiallyLoadedMessagesOpenAtBottom() {
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [], newIDs: [1, 2], visibleBottomID: nil) == 2)
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [1, 2], newIDs: [], visibleBottomID: 2) == nil)
    }

    @Test func preservesPositionWhenHistoryIsPrepended() {
        #expect(MessageScrollPolicy.targetAfterUpdate(oldIDs: [3, 4], newIDs: [1, 2, 3, 4], visibleBottomID: 4) == nil)
    }

    @Test func reportsTopOnceUntilOldestMessageChanges() {
        var tracker = TopReachTracker<Int>()

        let premature = tracker.shouldReport(10, isReady: false)
        let first = tracker.shouldReport(10, isReady: true)
        let repeatVisit = tracker.shouldReport(10, isReady: true)
        let newOldest = tracker.shouldReport(5, isReady: true)

        #expect(!premature)
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

    @Test func replyAndDeliveryMetadataAreOptional() {
        let existingMessage = IntMessage(id: 1, user: alice, date: start)
        #expect(existingMessage.replyPreview == nil)
        #expect(existingMessage.replyToMessageID == nil)
        #expect(existingMessage.deliveryStatus == nil)

        let reply = ChatMessageQuote(author: "Bob", text: "See you soon")
        let sentMessage = MessageMocker.ChatMessageItem(
            user: alice,
            messageKind: .text("Thanks"),
            isSender: true,
            replyPreview: reply,
            deliveryStatus: .delivered
        )
        #expect(sentMessage.replyPreview == reply)
        #expect(sentMessage.deliveryStatus == .delivered)
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
