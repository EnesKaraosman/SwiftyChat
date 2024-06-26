#if os(iOS)
import AVKit
import Combine
import SwiftUI

struct VideoPlayerRepresentable: UIViewRepresentable {
    @ObservedObject var playerVM: PlayerViewModel

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: VideoPlayerRepresentable
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?

        init(_ parent: VideoPlayerRepresentable) {
            self.parent = parent
            super.init()

            cancellable = parent.playerVM.$isInPipMode
                .sink { [weak self] in
                    guard let self = self,
                          let controller = self.controller else { return }
                    if $0 {
                        if controller.isPictureInPictureActive == false {
                            controller.startPictureInPicture()
                        }
                    } else if controller.isPictureInPictureActive {
                        controller.stopPictureInPicture()
                    }
                }
        }

        func setController(_ playerLayer: AVPlayerLayer) {
            controller = AVPictureInPictureController(playerLayer: playerLayer)
            controller?.canStartPictureInPictureAutomaticallyFromInline = true
            controller?.delegate = self
        }

        func pictureInPictureControllerDidStartPictureInPicture(
            _ pictureInPictureController: AVPictureInPictureController
        ) {
            parent.playerVM.isInPipMode = true
        }

        func pictureInPictureControllerWillStopPictureInPicture(
            _ pictureInPictureController: AVPictureInPictureController
        ) {
            parent.playerVM.isInPipMode = false
        }
    }

    final class PlayerView: UIView {
        override static var layerClass: AnyClass {
            AVPlayerLayer.self
        }

        // swiftlint:disable:next force_cast
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

        var player: AVPlayer? {
            get {
                playerLayer.player
            }
            set {
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.player = newValue
            }
        }
    }
}
#endif
