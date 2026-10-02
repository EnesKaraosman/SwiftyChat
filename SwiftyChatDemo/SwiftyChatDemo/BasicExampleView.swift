//
//  BasicExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock
#if os(iOS)
import AVFoundation
import PhotosUI
import UniformTypeIdentifiers
#endif

struct BasicExampleView: View {

    @State private var messages: [MessageMocker.ChatMessageItem] = []
    @State private var message = ""
    @State private var olderPagesRemaining = 3
    @State private var streamTask: Task<Void, Never>?
    @State private var isStreaming = false
    @State private var replyPreview: ChatMessageQuote?
    @State private var replyToMessageID: UUID?
    @State private var unreadMessageIDs: Set<UUID> = []
    @State private var scrollToBottom = false
    @State private var incomingMessageCount = 0
    #if os(iOS)
    @State private var selectedMedia: PhotosPickerItem?
    @State private var isMediaPickerPresented = false
    @State private var mediaError: String?
    #endif

    var body: some View {
        chatView
            .task {
                if messages.isEmpty {
                    messages = MessageMocker.generate(kind: .text, count: 20)
                    let welcome = "Try replying to a message with its context menu."
                    let original = MessageMocker.ChatMessageItem(user: MessageMocker.chatbot, messageKind: .text(welcome))
                    messages.append(original)
                    messages.append(.init(
                        user: MessageMocker.sender,
                        messageKind: .text("Got it!"),
                        isSender: true,
                        replyPreview: .init(author: MessageMocker.chatbot.userName, text: welcome),
                        replyToMessageID: original.id,
                        deliveryStatus: .read
                    ))
                }
            }
            .onDisappear {
                streamTask?.cancel()
            }
            #if os(iOS)
            .onChange(of: selectedMedia) { _, selection in
                guard let selection else { return }
                Task { await addPickedMedia(selection) }
            }
            .alert("Media unavailable", isPresented: Binding(
                get: { mediaError != nil },
                set: { if !$0 { mediaError = nil } }
            )) {
                Button("OK", role: .cancel) { mediaError = nil }
            } message: {
                Text(mediaError ?? "")
            }
            #endif
    }

    private var chatView: some View {
        ChatView(messages: $messages, scrollToBottom: $scrollToBottom, inputView: {
            VStack(spacing: 0) {
                if let replyPreview {
                    HStack {
                        Text("Replying to \(replyPreview.author): \(replyPreview.text)")
                            .font(.caption)
                            .lineLimit(1)
                        Spacer()
                        Button("Cancel reply", systemImage: "xmark") {
                            self.replyPreview = nil
                            replyToMessageID = nil
                        }
                        .labelStyle(.iconOnly)
                    }
                    .padding(8)
                }
                BasicInputView(
                    message: $message,
                    placeholder: "Type something",
                    onAttachment: attachmentAction,
                    onCommit: { messageKind in
                        self.messages.append(.init(
                            user: MessageMocker.sender,
                            messageKind: messageKind,
                            isSender: true,
                            replyPreview: replyPreview,
                            replyToMessageID: replyToMessageID,
                            deliveryStatus: .sent
                        ))
                        replyPreview = nil
                        replyToMessageID = nil
                        scrollToBottom = true
                    }
                )
                #if os(iOS)
                .photosPicker(
                    isPresented: $isMediaPickerPresented,
                    selection: $selectedMedia,
                    matching: .any(of: [.images, .videos])
                )
                #endif
            }
            .background(Color.primary.colorInvert())
        }, reachedTop: loadOlder)
        .unreadMessages(unreadMessageIDs)
        .onReachedBottom { newestID in
            guard let index = messages.firstIndex(where: { $0.id == newestID }) else { return }
            unreadMessageIDs.subtract(messages[...index].map(\.id))
        }
        .onRetryMessage { failedMessage in
            guard let index = messages.firstIndex(where: { $0.id == failedMessage.id }),
                  messages[index].deliveryStatus == .failed else { return }
            messages[index].deliveryStatus = .sent
        }
        .messageCellContextMenu { message in
            switch message.messageKind {
            case .text(let text):
                Button("Reply", systemImage: "arrowshape.turn.up.left") {
                    replyPreview = .init(author: message.user.userName, text: text)
                    replyToMessageID = message.id
                }
                Button(
                    action: {
                        print("Copy Context Menu tapped!!")
                        #if os(iOS)
                        UIPasteboard.general.string = text
                        #endif
                        #if os(macOS)
                        NSPasteboard.general.setString(text, forType: .string)
                        #endif
                    },
                    label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                )
            default:
                EmptyView()
            }
        }
        // ▼ Required
        .environment(\.chatStyle, ChatMessageCellStyle.basicStyle)
        #if os(iOS)
        .navigationBarTitle("Basic")
        #endif
        .toolbar {
            Button(isStreaming ? "Stop stream" : "Stream reply") {
                if isStreaming {
                    streamTask?.cancel()
                } else {
                    startStreaming()
                }
            }
            Menu("Demo actions", systemImage: "ellipsis.circle") {
                Button("Start new conversation", systemImage: "square.and.pencil") {
                    streamTask?.cancel()
                    isStreaming = false
                    messages = []
                    unreadMessageIDs = []
                    replyPreview = nil
                    replyToMessageID = nil
                    incomingMessageCount = 0
                    olderPagesRemaining = 0
                }
                Button("Receive message", systemImage: "bubble.left") {
                    receiveMessage("Incoming message \(incomingMessageCount + 1)")
                }
                Button("Receive long message", systemImage: "text.alignleft") {
                    receiveLongMessage()
                }
                Button("Receive message burst", systemImage: "bubble.left.and.bubble.right") {
                    Task { @MainActor in
                        receiveMessage("The next reply arrives before scrolling finishes.")
                        try? await Task.sleep(for: .milliseconds(80))
                        receiveLongMessage()
                    }
                }
                Button("Simulate failed send", systemImage: "exclamationmark.bubble") {
                    messages.append(.init(
                        user: MessageMocker.sender,
                        messageKind: .text("This message failed to send."),
                        isSender: true,
                        deliveryStatus: .failed
                    ))
                    scrollToBottom = true
                }
            }
            .labelStyle(.iconOnly)
            .accessibilityLabel("Demo actions")
        }
    }

    private var attachmentAction: (() -> Void)? {
        #if os(iOS)
        { isMediaPickerPresented = true }
        #else
        nil
        #endif
    }

    private func receiveMessage(_ text: String) {
        incomingMessageCount += 1
        let incoming = MessageMocker.ChatMessageItem(user: MessageMocker.chatbot, messageKind: .text(text))
        unreadMessageIDs.insert(incoming.id)
        messages.append(incoming)
    }

    private func receiveLongMessage() {
        let paragraphs = (1...30).map { "Part \($0): Keep reading this long message without losing your place when another reply arrives." }
        receiveMessage((["Long message begins."] + paragraphs + ["Long message ends."]).joined(separator: "\n\n"))
    }

    private func startStreaming() {
        let reply = "SwiftyChat can update a single message as a chatbot response arrives. Scroll up while this text grows to check that reading history stays comfortable."
        let streamedMessage = MessageMocker.ChatMessageItem(
            user: MessageMocker.chatbot,
            messageKind: .text("")
        )
        messages.append(streamedMessage)
        isStreaming = true
        streamTask = Task { @MainActor in
            var text = ""
            for word in reply.split(separator: " ") {
                guard !Task.isCancelled else { break }
                text += text.isEmpty ? String(word) : " \(word)"
                if let index = messages.firstIndex(where: { $0.id == streamedMessage.id }) {
                    messages[index].messageKind = .text(text)
                }
                try? await Task.sleep(for: .milliseconds(80))
            }
            isStreaming = false
            streamTask = nil
        }
    }

    private func loadOlder() {
        guard olderPagesRemaining > 0, let oldestDate = messages.first?.date else { return }
        let page = olderPagesRemaining
        olderPagesRemaining -= 1
        let olderMessages = (0..<10).map { index in
            MessageMocker.ChatMessageItem(
                user: MessageMocker.chatbot,
                messageKind: .text("Earlier page \(page), message \(index + 1)"),
                date: oldestDate.addingTimeInterval(TimeInterval(index - 10) * 60)
            )
        }
        messages.insert(contentsOf: olderMessages, at: 0)
    }

    #if os(iOS)
    private func addPickedMedia(_ selection: PhotosPickerItem) async {
        defer { selectedMedia = nil }
        do {
            let kind: ChatMessageKind
            if selection.supportedContentTypes.contains(where: { $0.conforms(to: .movie) }) {
                guard let movie = try await selection.loadTransferable(type: PickedMovie.self) else {
                    mediaError = "Could not load the selected video."
                    return
                }
                let generator = AVAssetImageGenerator(asset: AVURLAsset(url: movie.url))
                generator.appliesPreferredTrackTransform = true
                let thumbnail = try? await generator.image(at: .zero).image
                kind = .video(LocalVideo(
                    url: movie.url,
                    thumbnail: thumbnail.map(UIImage.init(cgImage:)) ?? UIImage(systemName: "video.fill") ?? UIImage()
                ))
            } else {
                guard let data = try await selection.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    mediaError = "Could not load the selected photo."
                    return
                }
                kind = .image(.local(image))
            }
            messages.append(.init(
                user: MessageMocker.sender,
                messageKind: kind,
                isSender: true,
                replyPreview: replyPreview,
                replyToMessageID: replyToMessageID,
                deliveryStatus: .sent
            ))
            replyPreview = nil
            replyToMessageID = nil
            scrollToBottom = true
        } catch {
            mediaError = error.localizedDescription
        }
    }
    #endif
}

#if os(iOS)
private struct PickedMovie: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let ext = received.file.pathExtension.isEmpty ? "mov" : received.file.pathExtension
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(ext)
            try FileManager.default.copyItem(at: received.file, to: url)
            return PickedMovie(url: url)
        }
    }
}

private struct LocalVideo: VideoItem {
    let url: URL
    let thumbnail: UIImage
    var placeholderImage: ImageLoadingKind {
        .local(thumbnail)
    }
    let pictureInPicturePlayingMessage = "Your video is playing in picture in picture."
}
#endif

struct BasicExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicExampleView()
    }
}
