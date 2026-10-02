import Foundation

struct MessageMetadata: Equatable {
    let showDateHeader: Bool
    let showDisplayName: Bool
}

enum MessageMetadataBuilder {
    static func build<Message: ChatMessage>(
        _ messages: [Message],
        dateHeaderTimeInterval: TimeInterval,
        shouldShowGroupChatHeaders: Bool
    ) -> [Message.ID: MessageMetadata] {
        var result: [Message.ID: MessageMetadata] = [:]

        for (index, message) in messages.enumerated() {
            let previous = index > 0 ? messages[index - 1] : nil
            let showDateHeader = previous.map { message.date.timeIntervalSince($0.date) > dateHeaderTimeInterval } ?? true
            let showDisplayName = shouldShowGroupChatHeaders && (
                showDateHeader || previous.map { message.user.id != $0.user.id } ?? true
            )
            result[message.id] = MessageMetadata(
                showDateHeader: showDateHeader,
                showDisplayName: showDisplayName
            )
        }

        return result
    }
}

enum MessageScrollPolicy {
    static func targetAfterUpdate<ID: Equatable>(
        oldIDs: [ID],
        newIDs: [ID],
        visibleBottomID: ID?,
        pendingAutoScrollID: ID? = nil
    ) -> ID? {
        if oldIDs.isEmpty { return newIDs.last }
        guard !oldIDs.isEmpty,
              newIDs.count > oldIDs.count,
              newIDs.starts(with: oldIDs),
              visibleBottomID == oldIDs.last || pendingAutoScrollID == oldIDs.last else { return nil }
        return newIDs.last
    }
}

struct TopReachTracker<ID: Equatable> {
    private var lastReportedID: ID?

    mutating func shouldReport(_ id: ID, isReady: Bool) -> Bool {
        guard isReady else { return false }
        guard lastReportedID != id else { return false }
        lastReportedID = id
        return true
    }
}

struct MessageNavigationState<ID: Hashable> {
    let firstUnreadID: ID?
    let unreadCount: Int

    init<Message: ChatMessage>(messages: [Message], unreadMessageIDs: Set<ID>) where Message.ID == ID {
        let unreadMessages = unreadMessageIDs.isEmpty ? [] : messages.filter { !$0.isSender && unreadMessageIDs.contains($0.id) }
        firstUnreadID = unreadMessages.first?.id
        unreadCount = unreadMessages.count
    }
}

struct MessageBottomPosition<ID: Hashable>: Equatable {
    let messageID: ID?
    let maxY: CGFloat

    func reachedMessageID(in viewport: CGRect, lastMessageID: ID?) -> ID? {
        guard let messageID, messageID == lastMessageID,
              !viewport.isEmpty,
              maxY >= viewport.minY,
              maxY <= viewport.maxY + 1 else { return nil }
        return messageID
    }
}
