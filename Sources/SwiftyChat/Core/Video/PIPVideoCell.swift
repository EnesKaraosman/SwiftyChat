//
//  PIPVideoCell.swift
//
//
//  Created by Enes Karaosman on 9.11.2020.
//

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

    @State private var pendingTask: Task<Void, Never>? = nil
    @State private var location: CGPoint = .zero
    private let viewModel = PIPVideoCellViewModel()
    @GestureState private var startLocation: CGPoint?

    var body: some View {
        ZStack {

            if videoManager.isFullScreen {
                Color.primary.colorInvert()
                    .animation(.linear, value: videoManager.isFullScreen)
                    .ignoresSafeArea()
            }

            GeometryReader { geometry in
                video
                    .frame(
                        width: viewModel.videoFrameWidth(
                            in: geometry.size,
                            isFullScreen: videoManager.isFullScreen,
                            orientationIsLandscape: modelOrientation()
                        ),
                        height: viewModel.videoFrameHeight(
                            in: geometry.size,
                            isFullScreen: videoManager.isFullScreen,
                            orientationIsLandscape: modelOrientation()
                        )
                    )
                    .cornerRadius(videoManager.isFullScreen ? 0 : 8)
                    .shadow(color: videoManager.isFullScreen ? .clear : .secondary, radius: 6, x: 1, y: 2)
                    .position(location)
                    .gesture(simpleDrag(in: geometry.size))
                    .animation(.linear(duration: 0.1), value: location)
                    .onAppear {
                        // initial placement
                        let initial = viewModel.computeLocation(for: .rightTop, in: geometry.size, isFullScreen: videoManager.isFullScreen, orientationIsLandscape: modelOrientation())
                        withAnimation(.easeIn) { self.location = initial }
                    }
                    .onChange(of: videoManager.isFullScreen) { _ in
                        pendingTask?.cancel()
                        pendingTask = viewModel.scheduleReposition(to: .center, in: geometry.size, isFullScreen: videoManager.isFullScreen, orientationIsLandscape: modelOrientation()) { newLocation in
                            withAnimation(.easeIn) { self.location = newLocation }
                        }
                    }

                    #if os(iOS)
                    .onChange(of: model.orientation) { _ in
                        pendingTask?.cancel()
                        pendingTask = viewModel.scheduleReposition(to: .leftTop, in: geometry.size, isFullScreen: videoManager.isFullScreen, orientationIsLandscape: modelOrientation()) { newLocation in
                            withAnimation(.easeIn) { self.location = newLocation }
                        }
                    }
                    #endif
                    .onDisappear {
                        pendingTask?.cancel()
                        pendingTask = nil
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

    private func modelOrientation() -> Bool? {
        #if os(iOS)
        return model.orientation == .landscape
        #else
        return nil
        #endif
    }

    // MARK: - Drag Gesture
    private func simpleDrag(in size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                location = newLocation
            }
            .updating($startLocation) { _, startLocation, _ in
                startLocation = startLocation ?? location
            }
            .onEnded { _ in
                let corner: PIPVideoCellViewModel.Corner
                if location.y > size.midY {
                    corner = location.x > size.midX ? .rightBottom : .leftBottom
                } else {
                    corner = location.x > size.midX ? .rightTop : .leftTop
                }
                let newLocation = viewModel.computeLocation(for: corner, in: size, isFullScreen: videoManager.isFullScreen, orientationIsLandscape: modelOrientation())
                withAnimation(.easeIn) { location = newLocation }
            }
    }
}
