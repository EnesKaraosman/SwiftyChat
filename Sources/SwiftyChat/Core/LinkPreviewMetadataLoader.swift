import Foundation
import LinkPresentation

public struct LinkPreviewMetadata: LinkPreviewItem, Equatable, Sendable {
    public let url: URL
    public let title: String?
    public let description: String?
    public let imageURL: URL?
    public let host: String?

    public init(url: URL, title: String? = nil, description: String? = nil, imageURL: URL? = nil, host: String? = nil) {
        self.url = url
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.host = host
    }
}

public enum LinkPreviewMetadataError: Error, Equatable {
    case unsupportedURL
}

@MainActor public final class LinkPreviewMetadataLoader {
    private var cache: [URL: LinkPreviewMetadata] = [:]
    private var inFlight: [URL: Task<LinkPreviewMetadata, Error>] = [:]
    private let fetcher: @MainActor (URL) async throws -> LinkPreviewMetadata

    public init() {
        fetcher = Self.fetch
    }

    init(fetcher: @escaping @MainActor (URL) async throws -> LinkPreviewMetadata) {
        self.fetcher = fetcher
    }

    public func preview(for url: URL) async throws -> LinkPreviewMetadata {
        guard ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            throw LinkPreviewMetadataError.unsupportedURL
        }
        if let cached = cache[url] { return cached }
        if let pending = inFlight[url] { return try await pending.value }
        let pending = Task { try await fetcher(url) }
        inFlight[url] = pending
        defer { inFlight[url] = nil }
        let preview = try await pending.value
        cache[url] = preview
        return preview
    }

    nonisolated private static func fetch(_ url: URL) async throws -> LinkPreviewMetadata {
        let provider = LPMetadataProvider()
        provider.shouldFetchSubresources = false
        provider.timeout = 10
        let metadata = try await provider.startFetchingMetadata(for: url)
        return LinkPreviewMetadata(
            url: url,
            title: metadata.title,
            host: metadata.url?.host() ?? url.host()
        )
    }
}
