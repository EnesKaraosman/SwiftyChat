#if os(iOS)
import AVKit
import SwiftUI

@MainActor
struct VideoPlayerRepresentable: UIViewRepresentable {
    var playerVM: PlayerViewModel

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        // Handle PiP mode changes
        context.coordinator.updatePipMode(playerVM.isInPipMode)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    @MainActor
    class Coordinator: NSObject, @preconcurrency AVPictureInPictureControllerDelegate {
        private let playerVM: PlayerViewModel
        private var controller: AVPictureInPictureController?
        private var lastPipMode: Bool = false

        init(_ parent: VideoPlayerRepresentable) {
            self.playerVM = parent.playerVM
            super.init()
        }

        func updatePipMode(_ isInPipMode: Bool) {
            guard isInPipMode != lastPipMode else { return }
            lastPipMode = isInPipMode

            guard let controller = controller else { return }
            if isInPipMode {
                if !controller.isPictureInPictureActive {
                    controller.startPictureInPicture()
                }
            } else if controller.isPictureInPictureActive {
                controller.stopPictureInPicture()
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
            playerVM.isInPipMode = true
        }

        func pictureInPictureControllerWillStopPictureInPicture(
            _ pictureInPictureController: AVPictureInPictureController
        ) {
            playerVM.isInPipMode = false
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
