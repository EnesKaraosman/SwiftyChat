import AVFoundation
import Combine
import Observation

@MainActor
@Observable
final class PlayerViewModel {
    let player: AVPlayer

    var isEditingCurrentTime = false {
        didSet {
            if oldValue && !isEditingCurrentTime {
                // When editing ends, seek to the new position
                player.seek(
                    to: CMTime(seconds: currentTime, preferredTimescale: 1),
                    toleranceBefore: .zero,
                    toleranceAfter: .zero
                )

                if player.rate != 0 {
                    player.play()
                }
            }
        }
    }

    var currentTime: Double = .zero
    var isInPipMode: Bool = false
    private(set) var isPlaying = false
    private(set) var duration: Double?

    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?

    deinit {
        // timeObserver cleanup handled by AVPlayer when it's deallocated
    }

    init() {
        player = AVPlayer()

        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            Task { @MainActor [weak self] in
                guard let self else { return }
                if self.isEditingCurrentTime == false {
                    self.currentTime = time.seconds
                }
            }
        }
    }

    func setCurrentItem(_ item: AVPlayerItem) {
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: item)

        item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                Task { @MainActor in
                    if let duration = try? await item.asset.load(.duration) {
                        self?.duration = duration.seconds
                    }
                }
            })
            .store(in: &subscriptions)
    }
}
