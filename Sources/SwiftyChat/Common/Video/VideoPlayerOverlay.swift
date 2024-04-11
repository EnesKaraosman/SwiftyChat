import SwiftUI

struct VideoPlayerOverlay<Message: ChatMessage>: View {
    @ObservedObject var playerVM: PlayerViewModel
    @EnvironmentObject var videoManager: VideoManager<Message>

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
        Color.secondary.colorInvert()
            .cornerRadius(10)
            .frame(width: 50, height: 40)
            .overlay(
                Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                    .font(Font.body.weight(.semibold))
                    .foregroundColor(Color.white)
                    .padding()
            )
            .onTapGesture {
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
        } else {
            Spacer()
        }
    }

    private var fullScreenButton: some View {
        Color.secondary.colorInvert()
            .cornerRadius(10)
            .frame(width: 50, height: 40)
            .overlay(
                Image(
                    systemName: videoManager.isFullScreen ?
                    "arrow.down.right.and.arrow.up.left" :
                        "arrow.up.left.and.arrow.down.right"
                )
                .font(Font.body.weight(.semibold))
                .foregroundColor(Color.white)
                .padding()
            )
            .onTapGesture {
                withAnimation {
                    videoManager.isFullScreen.toggle()
                }
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
