import AVFoundation
import AVKit
import SwiftUI

#if os(iOS)
struct IOSChatVideoPlayer<Message: ChatMessage>: View {
    @StateObject private var playerVM = PlayerViewModel()
    let media: VideoItem
    let message: Message

    @EnvironmentObject var style: ChatMessageCellStyle
    @EnvironmentObject var videoManager: VideoManager<Message>

    private var cellStyle: VideoPlaceholderCellStyle {
        style.videoPlaceholderCellStyle
    }

    init(media: VideoItem, message: Message) {
        self.media = media
        self.message = message

        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }

    var body: some View {
        VStack(spacing: .zero) {
            VideoPlayerRepresentable(playerVM: playerVM)
            VideoPlayerOverlay<Message>(for: playerVM)
        }
        .clipShape(RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius))
        .onAppear {
            playerVM.setCurrentItem(AVPlayerItem(url: media.url))
            playerVM.player.play()
        }
        .onDisappear {
            playerVM.player.pause()
        }
    }
}
#endif

// TODO: - Works for iOS as well but overlay is problematic currently
struct MacOSChatVideoPlayer<Message: ChatMessage>: View {
    @StateObject private var playerVM = PlayerViewModel()
    let media: VideoItem
    let message: Message

    @EnvironmentObject var style: ChatMessageCellStyle
    @EnvironmentObject var videoManager: VideoManager<Message>

    private var cellStyle: VideoPlaceholderCellStyle {
        style.videoPlaceholderCellStyle
    }

    var body: some View {
        VideoPlayer(player: playerVM.player)
            .overlay(alignment: .topTrailing, content: {
                closeButton
            })
            .onAppear {
                playerVM.setCurrentItem(AVPlayerItem(url: media.url))
                playerVM.player.play()
            }
            .onDisappear {
                playerVM.player.pause()
            }
    }

    private var closeButton: some View {
        Color.secondary.colorInvert()
            .cornerRadius(10)
            .frame(width: 50, height: 40)
            .overlay(
                Image(systemName: "xmark")
                    .font(Font.body.weight(.semibold))
                    .foregroundColor(Color.white)
                    .padding()
            )
            .onTapGesture {
                self.videoManager.flushState()
            }
    }
}
