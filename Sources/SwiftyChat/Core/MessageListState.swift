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
        visibleBottomID: ID?
    ) -> ID? {
        guard !oldIDs.isEmpty,
              newIDs.count > oldIDs.count,
              newIDs.starts(with: oldIDs),
              visibleBottomID == oldIDs.last else { return nil }
        return newIDs.last
    }
}
