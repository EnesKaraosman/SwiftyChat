import AVFoundation
import UIKit

final class PlayerView: UIView {
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
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
