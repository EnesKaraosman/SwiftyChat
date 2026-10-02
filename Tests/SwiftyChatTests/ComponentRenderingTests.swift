import ImageIO
import SwiftUI
import Testing
import UniformTypeIdentifiers
@testable import SwiftyChat
import SwiftyChatMock

@Suite @MainActor struct ComponentRenderingTests {
    @Test(arguments: [ColorScheme.light, .dark])
    func rendersSwiftUIComponents(in scheme: ColorScheme) throws {
        let media = try sampleImage()
        let samples: [(String, ChatMessageKind)] = [
            ("text", .text("Hello! **SwiftyChat** follows your app's appearance.")),
            ("text-link", .text("Read the [guide](https://example.com) or visit https://example.com.")),
            ("emoji", .text("👋✨")),
            ("image", .image(.local(media))),
            ("image-text", .imageText(.local(media), "A little room to explore.")),
            ("quick-reply", .quickReply([Reply(title: "Explore"), Reply(title: "Tell me more")])),
            ("contact", .contact(Contact(image: media))),
            ("link-preview", .linkPreview(LinkPreviewMetadata(
                url: URL(string: "https://github.com/EnesKaraosman/SwiftyChat")!,
                title: "SwiftyChat",
                description: "A SwiftUI chat interface for iOS and macOS.",
                host: "github.com"
            ))),
            ("video", .video(Video(placeholderImage: .local(media)))),
            ("video-playing", .video(Video(placeholderImage: .local(media)))),
            ("loading", .loading),
            ("reply", .text("Yes, let's build it.")),
            ("custom", .custom("Your own SwiftUI content"))
        ]

        for (name, kind) in samples {
            let message = MessageMocker.ChatMessageItem(
                user: .init(userName: "Alex"),
                messageKind: kind,
                isSender: name == "reply",
                replyPreview: name == "reply" ? .init(author: "Sam", text: "Ready for dark mode?") : nil
            )
            let videoManager = VideoManager<MessageMocker.ChatMessageItem>()
            if name == "video-playing" { videoManager.message = message }
            let view = ChatMessageViewContainer(
                message: message,
                size: CGSize(width: 440, height: 900),
                customCell: { value in
                    AnyView(Label(value as? String ?? "", systemImage: "puzzlepiece.extension")
                        .padding().background(.quaternary, in: RoundedRectangle(cornerRadius: 12)))
                },
                onQuickReplyItemSelected: { _ in },
                contactFooterSection: { _, _ in [] },
                onCarouselItemAction: { _, _ in },
                onLinkPreviewTapped: { _, _ in }
            )
            .environment(videoManager)
            try render(view, name: name, scheme: scheme)
        }
    }

    private func render(_ view: some View, name: String, scheme: ColorScheme) throws {
        let renderer = ImageRenderer(content: view
            .frame(width: 350, alignment: .leading)
            .padding(20)
            .background(scheme == .light ? Color.white : Color.black)
            .environment(\.colorScheme, scheme))
        renderer.scale = 2
        let image = try #require(renderer.cgImage, "\(name) must render in \(scheme)")
        #expect(image.width == 780)
        #expect(image.height > 40)
        if name == "reply" {
            try checkReplyContrast(image, scheme: scheme)
        }

        if let directory = ProcessInfo.processInfo.environment["SWIFTYCHAT_SNAPSHOT_DIR"] {
            let root = URL(fileURLWithPath: directory, isDirectory: true)
            try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
            let url = root.appendingPathComponent("\(name)-\(scheme == .light ? "light" : "dark").png")
            let destination = try #require(CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil))
            CGImageDestinationAddImage(destination, image, nil)
            #expect(CGImageDestinationFinalize(destination))
        }
    }

    private func checkReplyContrast(_ image: CGImage, scheme: ColorScheme) throws {
        // Sample inside the quote, excluding its rounded edge and the message below it.
        let quote = try #require(image.cropping(to: CGRect(x: 56, y: 56, width: 300, height: 56)))
        let context = try #require(CGContext(
            data: nil, width: quote.width, height: quote.height,
            bitsPerComponent: 8, bytesPerRow: quote.width * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        context.draw(quote, in: CGRect(x: 0, y: 0, width: quote.width, height: quote.height))
        let pixels = try #require(context.data).assumingMemoryBound(to: UInt8.self)
        let luminances = stride(from: 0, to: quote.width * quote.height * 4, by: 4).map { offset in
            let linear = (0..<3).map { channel in
                let value = Double(pixels[offset + channel]) / 255
                return value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
            }
            return zip(linear, [0.2126, 0.7152, 0.0722]).map(*).reduce(0, +)
        }
        let ratio = (try #require(luminances.max()) + 0.05) / (try #require(luminances.min()) + 0.05)
        #expect(ratio >= 4.5, "Rendered reply quote in \(scheme): \(ratio):1 contrast")
    }

    private func sampleImage() throws -> PlatformImage {
        let renderer = ImageRenderer(content: ZStack {
            LinearGradient(colors: [.indigo, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 88))
                .foregroundStyle(.white)
        }.frame(width: 480, height: 270))
        let image = try #require(renderer.cgImage)
        #if os(iOS)
        return PlatformImage(cgImage: image)
        #else
        return PlatformImage(cgImage: image, size: CGSize(width: 480, height: 270))
        #endif
    }
}

private struct Reply: QuickReplyItem {
    let title: String
    var payload: String { title }
}

private struct Contact: ContactItem {
    let displayName = "Alex Morgan"
    let image: PlatformImage?
    let initials = "AM"
    let phoneNumbers: [String] = []
    let emails = ["alex@example.com"]
}

private struct Video: VideoItem {
    let url = URL(string: "https://example.com/video.mp4")!
    let placeholderImage: ImageLoadingKind
    let pictureInPicturePlayingMessage = "Playing in picture in picture"
}
