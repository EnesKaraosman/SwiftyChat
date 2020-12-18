//
//  PIPVideoCell.swift
//  
//
//  Created by Enes Karaosman on 9.11.2020.
//

import SwiftUI
import SwiftUIEKtensions
import Combine

internal extension CGSize {
    var midX: CGFloat { width / 2 }
    var midY: CGFloat { height / 2 }
}

internal struct PIPVideoCell<Message: ChatMessage>: View {
    
    @EnvironmentObject var videoManager: VideoManager<Message>
    @EnvironmentObject var model: DeviceOrientationInfo

    @State private var cancellables: Set<AnyCancellable> = .init()
    @State private var location: CGPoint = .zero
    @GestureState private var startLocation: CGPoint? = nil
    
    private let horizontalPadding: CGFloat = 16
    private let aspectRatio: CGFloat = 1.78
    
    private func videoFrameHeight(in size: CGSize) -> CGFloat {
        if videoManager.isFullScreen && model.orientation == .landscape {
            return size.height
        } else {
            return videoFrameWidth(in: size) / aspectRatio
        }
    }
    
    private func videoFrameWidth(in size: CGSize) -> CGFloat {
        if videoManager.isFullScreen {
            return size.width
        } else {
            return model.orientation == .landscape ?
            (size.width / aspectRatio) : abs(size.width - horizontalPadding) // Padding
        }
    }
    
    private enum Corner {
        case leftTop, leftBottom, rightTop, rightBottom, center
    }
    
    /// When we set .position(), sets its center to given point
    private func rePositionVideoFrame(toCorner: Corner, in size: CGSize) {
        let inputViewOffset: CGFloat = videoManager.isFullScreen ? 0 : 60
        let _horizontalPadding = videoManager.isFullScreen ? 0 : horizontalPadding
        withAnimation(.easeIn) {
            switch toCorner {
            case .center:
                location = .init(
                    x: size.width / 2,
                    y: size.height / 2
                )
            case .leftTop:
                location = .init(
                    x: (videoFrameWidth(in: size) / 2) + (_horizontalPadding / 2),
                    y: videoFrameHeight(in: size) / 2
                )
            case .leftBottom:
                location = .init(
                    x: (videoFrameWidth(in: size) / 2) + (_horizontalPadding / 2),
                    y: size.height - videoFrameHeight(in: size) / 2 - inputViewOffset
                )
            case .rightTop:
                location = .init(
                    x: size.width - (videoFrameWidth(in: size) / 2) - (_horizontalPadding / 2),
                    y: videoFrameHeight(in: size) / 2
                )
            case .rightBottom:
                location = .init(
                    x: size.width - (videoFrameWidth(in: size) / 2) - (_horizontalPadding / 2),
                    y: size.height - videoFrameHeight(in: size) / 2 - inputViewOffset
                )
            }
        }
    }
    
    public var body: some View {
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
                            .sink { fullScreen in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.rePositionVideoFrame(toCorner: .center, in: geometry.size)
                                }
                            }
                            .store(in: &cancellables)
                        
                        model.$orientation
                            .removeDuplicates()
                            .sink(receiveValue: { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.rePositionVideoFrame(toCorner: .leftTop, in: geometry.size)
                                }
                            })
                            .store(in: &cancellables)
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
            VideoPlayerContainer<Message>(media: videoItem, message: message)
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
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
            .onEnded { (value) in
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
