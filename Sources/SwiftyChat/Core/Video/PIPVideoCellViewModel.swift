import Foundation
import SwiftUI

@MainActor
final class PIPVideoCellViewModel: ObservableObject {

    enum Corner {
        case leftTop, leftBottom, rightTop, rightBottom, center
    }

    let horizontalPadding: CGFloat = 16
    let aspectRatio: CGFloat = 1.4

    func videoFrameWidth(in size: CGSize, isFullScreen: Bool, orientationIsLandscape: Bool?) -> CGFloat {
        let portraitVideoFrameWidth = abs(size.width - horizontalPadding)

        #if os(iOS)
        if isFullScreen {
            return size.width
        } else {
            if let isLandscape = orientationIsLandscape, isLandscape {
                return (size.width / aspectRatio)
            } else {
                return portraitVideoFrameWidth
            }
        }
        #else
        return portraitVideoFrameWidth
        #endif
    }

    func videoFrameHeight(in size: CGSize, isFullScreen: Bool, orientationIsLandscape: Bool?) -> CGFloat {
        let portraitVideoFrameHeight = videoFrameWidth(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / aspectRatio

        #if os(iOS)
        if isFullScreen && (orientationIsLandscape ?? false) {
            return size.height
        } else {
            return portraitVideoFrameHeight
        }
        #else
        return portraitVideoFrameHeight
        #endif
    }

    func computeLocation(for corner: Corner, in size: CGSize, isFullScreen: Bool, orientationIsLandscape: Bool?) -> CGPoint {
        let inputViewOffset: CGFloat = isFullScreen ? 0 : 60
        let hPadding = isFullScreen ? 0 : horizontalPadding
        switch corner {
        case .center:
            return .init(x: size.width / 2, y: size.height / 2)
        case .leftTop:
            return .init(
                x: (videoFrameWidth(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2) + (hPadding / 2),
                y: videoFrameHeight(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2
            )
        case .leftBottom:
            return .init(
                x: (videoFrameWidth(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2) + (hPadding / 2),
                y: size.height - videoFrameHeight(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2 - inputViewOffset
            )
        case .rightTop:
            return .init(
                x: size.width - (videoFrameWidth(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2) - (hPadding / 2),
                y: videoFrameHeight(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2
            )
        case .rightBottom:
            return .init(
                x: size.width - (videoFrameWidth(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2) - (hPadding / 2),
                y: size.height - videoFrameHeight(in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape) / 2 - inputViewOffset
            )
        }
    }

    /// Schedule a reposition after a short delay. Returns the Task so the caller can cancel it if needed.
    func scheduleReposition(to corner: Corner, in size: CGSize, isFullScreen: Bool, orientationIsLandscape: Bool?, delayNanos: UInt64 = 200_000_000, update: @escaping (CGPoint) -> Void) -> Task<Void, Never> {
        return Task { @MainActor in
            try? await Task.sleep(nanoseconds: delayNanos)
            if Task.isCancelled { return }
            let newLocation = computeLocation(for: corner, in: size, isFullScreen: isFullScreen, orientationIsLandscape: orientationIsLandscape)
            update(newLocation)
        }
    }
}
