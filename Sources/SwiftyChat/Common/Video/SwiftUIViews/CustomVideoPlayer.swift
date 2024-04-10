import AVKit
import Combine
import SwiftUI

#if os(iOS)
struct CustomVideoPlayer: UIViewRepresentable {
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
}
#endif

#if os(macOS)
struct CustomVideoPlayer: NSViewRepresentable {
    
    @ObservedObject var playerVM: PlayerViewModel

    func makeNSView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }

    func updateNSView(_ nsView: PlayerView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#endif

extension CustomVideoPlayer {
    class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: CustomVideoPlayer
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?

        init(_ parent: CustomVideoPlayer) {
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
            #if os(iOS)
            controller?.canStartPictureInPictureAutomaticallyFromInline = true
            #endif
            controller?.delegate = self
        }

        func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = true
        }

        func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = false
        }
    }
}
