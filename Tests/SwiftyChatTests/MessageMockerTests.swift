import Testing
import SwiftyChatMock

@Suite struct MessageMockerTests {
    @Test func zeroRequestedMessagesReturnsEmpty() {
        #expect(MessageMocker.generate(kind: .text, count: 0).isEmpty)
        #expect(MessageMocker.generate(count: 0).isEmpty)
    }
}
