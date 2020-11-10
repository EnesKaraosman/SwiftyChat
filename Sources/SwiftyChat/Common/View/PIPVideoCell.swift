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
    @State private var cancellable: Cancellable?
    
    @State private var location: CGPoint = CGPoint(x: 200, y: 100)
    @GestureState private var startLocation: CGPoint? = nil
    
    private let horizontalPadding: CGFloat = 16
    
    private func videoFrameHeight(in size: CGSize) -> CGFloat {
        videoFrameWidth(in: size) / 1.78
    }
    
    private func videoFrameWidth(in size: CGSize) -> CGFloat {
        model.orientation == .landscape ?
            (size.width / 1.8):
        abs(size.width - horizontalPadding) // Padding
    }
    
    enum Corner {
        case leftTop, leftBottom, rightTop, rightBottom
    }
    
    /// When we set .position(), sets its center to given point
    func rePositionVideoFrame(toCorner: Corner, in size: CGSize) {
        let inputViewOffset: CGFloat = 60
        let _horizontalPadding = horizontalPadding
        withAnimation(.easeIn) {
            switch toCorner {
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
        GeometryReader { geometry in
            video(in: geometry.size)
                .frame(width: videoFrameWidth(in: geometry.size), height: videoFrameHeight(in: geometry.size))
                .cornerRadius(8)
                .position(location)
                .gesture(simpleDrag(in: geometry.size))
                .animation(.linear(duration: 0.1))
                .onAppear { rePositionVideoFrame(toCorner: .rightTop, in: geometry.size) }
                .onAppear {
                    cancellable = model.$orientation
                        .removeDuplicates()
                        .sink(receiveValue: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.rePositionVideoFrame(toCorner: .leftTop, in: geometry.size)
                            }
                        })
                }
                .onDisappear { cancellable?.cancel() }
        }
    }
    
    @ViewBuilder private func video(in size: CGSize) -> some View {
        if let message = videoManager.message, let videoItem = videoManager.videoItem {
            VideoPlayerContainer<Message>(media: videoItem, message: message, size: size)
        }
    }
    
    // MARK: - Drag Gesture
    func simpleDrag(in size: CGSize) -> some Gesture {
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
