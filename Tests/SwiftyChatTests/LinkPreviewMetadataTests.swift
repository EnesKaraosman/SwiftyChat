import Foundation
import Testing
@testable import SwiftyChat

@Suite struct LinkPreviewMetadataTests {
    @Test @MainActor func cachesSuccessfulFetches() async throws {
        let url = URL(string: "https://example.com/page")!
        let expected = LinkPreviewMetadata(url: url, title: "Example", host: "example.com")
        var fetchCount = 0
        let loader = LinkPreviewMetadataLoader { _ in
            fetchCount += 1
            return expected
        }

        let first = try await loader.preview(for: url)
        let second = try await loader.preview(for: url)

        #expect(first == expected)
        #expect(second == expected)
        #expect(fetchCount == 1)
    }

    @Test @MainActor func rejectsNonWebURLsBeforeFetch() async {
        let loader = LinkPreviewMetadataLoader { _ in
            Issue.record("Fetch should not run for local URLs")
            return LinkPreviewMetadata(url: URL(fileURLWithPath: "/tmp/example"))
        }

        await #expect(throws: LinkPreviewMetadataError.unsupportedURL) {
            try await loader.preview(for: URL(fileURLWithPath: "/tmp/example"))
        }
    }

    @Test @MainActor func concurrentRequestsShareOneFetch() async throws {
        let url = URL(string: "https://example.com/page")!
        var fetchCount = 0
        let loader = LinkPreviewMetadataLoader { url in
            fetchCount += 1
            try await Task.sleep(for: .milliseconds(30))
            return LinkPreviewMetadata(url: url, title: "Example")
        }

        async let first = loader.preview(for: url)
        async let second = loader.preview(for: url)
        _ = try await (first, second)

        #expect(fetchCount == 1)
    }
}
