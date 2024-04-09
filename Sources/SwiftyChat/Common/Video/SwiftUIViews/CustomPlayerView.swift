import AVFoundation
import SwiftUI

struct CustomPlayerView<Message: ChatMessage>: View {
    @StateObject private var playerVM = PlayerViewModel()
    public let media: VideoItem
    public let message: Message

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
            CustomVideoPlayer(playerVM: playerVM)
            CustomControlsView<Message>(for: playerVM)
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
