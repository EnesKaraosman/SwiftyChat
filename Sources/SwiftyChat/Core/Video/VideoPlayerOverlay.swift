import SwiftUI

struct VideoPlayerOverlay<Message: ChatMessage>: View {
    @Bindable var playerVM: PlayerViewModel

    @Environment(VideoManager<Message>.self) var videoManager

    init(for playerViewModel: PlayerViewModel) {
        self.playerVM = playerViewModel
    }

    var body: some View {
        HStack {
            playPauseButton
            durationSlider
            fullScreenButton
            closeButton
        }
        .imageScale(.large)
        .padding()
        .background(.thinMaterial)
    }

    private var playPauseButton: some View {
        controlButton(
            playerVM.isPlaying ? "pause.fill" : "play.fill",
            label: playerVM.isPlaying ? "Pause video" : "Play video"
        ) {
            if playerVM.isPlaying {
                playerVM.player.pause()
            } else {
                playerVM.player.play()
            }
        }
    }

    @ViewBuilder
    private var durationSlider: some View {
        if let duration = playerVM.duration {
            Slider(
                value: $playerVM.currentTime,
                in: 0...duration,
                onEditingChanged: { isEditing in
                    playerVM.isEditingCurrentTime = isEditing
                }
            )
            .accessibilityLabel("Playback position")
        } else {
            Spacer()
        }
    }

    private var fullScreenButton: some View {
        controlButton(
            videoManager.isFullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right",
            label: videoManager.isFullScreen ? "Exit full screen" : "Enter full screen"
        ) { [weak videoManager] in
            withAnimation {
                videoManager?.isFullScreen.toggle()
            }
        }
    }

    private var closeButton: some View {
        controlButton("xmark", label: "Close video") { [weak videoManager] in
            videoManager?.flushState()
        }
    }

    private func controlButton(_ symbol: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(Font.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 50, height: 40)
                .background(Color.secondary.colorInvert())
                .clipShape(.rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
