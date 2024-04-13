//
//  PIPVideoCell.swift
//
//
//  Created by Enes Karaosman on 9.11.2020.
//

import Combine
import SwiftUI
import SwiftUIEKtensions

private extension CGSize {
    var midX: CGFloat { width / 2 }
    var midY: CGFloat { height / 2 }
}

struct PIPVideoCell<Message: ChatMessage>: View {

    @EnvironmentObject var videoManager: VideoManager<Message>

    #if os(iOS)
    @EnvironmentObject var model: DeviceOrientationInfo
    #endif

    @State private var cancellables: Set<AnyCancellable> = .init()
    @State private var location: CGPoint = .zero
    @GestureState private var startLocation: CGPoint?

    private let horizontalPadding: CGFloat = 16
    private let aspectRatio: CGFloat = 1.4

    private func videoFrameHeight(in size: CGSize) -> CGFloat {
        let portraitVideoFrameHeight = videoFrameWidth(in: size) / aspectRatio

        #if os(iOS)
        if videoManager.isFullScreen && model.orientation == .landscape {
            return size.height
        } else {
            return portraitVideoFrameHeight
        }

        #else
        return portraitVideoFrameHeight
        #endif
    }

    private func videoFrameWidth(in size: CGSize) -> CGFloat {
        let portraitVideoFrameWidth = abs(size.width - horizontalPadding) // Padding

        #if os(iOS)
        if videoManager.isFullScreen {
            return size.width
        } else {
            return model.orientation == .landscape ?
            (size.width / aspectRatio) : portraitVideoFrameWidth
        }

        #else
        return portraitVideoFrameWidth
        #endif
    }

    private enum Corner {
        case leftTop, leftBottom, rightTop, rightBottom, center
    }

    /// When we set .position(), sets its center to given point
    private func rePositionVideoFrame(toCorner: Corner, in size: CGSize) {
        let inputViewOffset: CGFloat = videoManager.isFullScreen ? 0 : 60
        let hPadding = videoManager.isFullScreen ? 0 : horizontalPadding
        withAnimation(.easeIn) {
            switch toCorner {
            case .center:
                location = .init(
                    x: size.width / 2,
                    y: size.height / 2
                )
            case .leftTop:
                location = .init(
                    x: (videoFrameWidth(in: size) / 2) + (hPadding / 2),
                    y: videoFrameHeight(in: size) / 2
                )
            case .leftBottom:
                location = .init(
                    x: (videoFrameWidth(in: size) / 2) + (hPadding / 2),
                    y: size.height - videoFrameHeight(in: size) / 2 - inputViewOffset
                )
            case .rightTop:
                location = .init(
                    x: size.width - (videoFrameWidth(in: size) / 2) - (hPadding / 2),
                    y: videoFrameHeight(in: size) / 2
                )
            case .rightBottom:
                location = .init(
                    x: size.width - (videoFrameWidth(in: size) / 2) - (hPadding / 2),
                    y: size.height - videoFrameHeight(in: size) / 2 - inputViewOffset
                )
            }
        }
    }

    var body: some View {
        ZStack {

            if videoManager.isFullScreen {
                Color.primary.colorInvert()
                    .animation(.linear)
                    .edgesIgnoringSafeArea(.all)
            }

            GeometryReader { geometry in
                video
                    .frame(width: videoFrameWidth(in: geometry.size), height: videoFrameHeight(in: geometry.size))
                    .cornerRadius(videoManager.isFullScreen ? 0 : 8)
                    .shadow(color: videoManager.isFullScreen ? .clear : .secondary, radius: 6, x: 1, y: 2)
                    .position(location)
                    .gesture(simpleDrag(in: geometry.size))
                    .animation(.linear(duration: 0.1))
                    .onAppear { rePositionVideoFrame(toCorner: .rightTop, in: geometry.size) }
                    .onAppear {

                        videoManager.$isFullScreen
                            .removeDuplicates()
                            .sink { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.rePositionVideoFrame(toCorner: .center, in: geometry.size)
                                }
                            }
                            .store(in: &cancellables)

                        #if os(iOS)
                        model.$orientation
                            .removeDuplicates()
                            .sink(receiveValue: { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.rePositionVideoFrame(toCorner: .leftTop, in: geometry.size)
                                }
                            })
                            .store(in: &cancellables)
                        #endif
                    }
                    .onDisappear {
                        cancellables.forEach { $0.cancel() }
                        print("☠️ pip disappeared..")
                    }
            }
        }
    }

    @ViewBuilder private var video: some View {
        if let message = videoManager.message, let videoItem = videoManager.videoItem {
            #if os(iOS)
            IOSChatVideoPlayer(media: videoItem, message: message)
            #endif

            #if os(macOS)
            MacOSChatVideoPlayer(media: videoItem, message: message)
            #endif
        }
    }

    // MARK: - Drag Gesture
    private func simpleDrag(in size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }
            .updating($startLocation) { _, startLocation, _ in
                startLocation = startLocation ?? location
            }
            .onEnded { _ in
                if self.location.y > size.midY {
                    if self.location.x > size.midX {
                        rePositionVideoFrame(toCorner: .rightBottom, in: size)
                    } else {
                        rePositionVideoFrame(toCorner: .leftBottom, in: size)
                    }
                } else {
                    if self.location.x > size.midX {
                        rePositionVideoFrame(toCorner: .rightTop, in: size)
                    } else {
                        rePositionVideoFrame(toCorner: .leftTop, in: size)
                    }
                }
            }
    }
}
