//
//  PIPVideoCell.swift
//  
//
//  Created by Enes Karaosman on 9.11.2020.
//

import SwiftUI

internal struct PIPVideoCell<Message: ChatMessage>: View {
    
    public let parentSize: CGSize
    @EnvironmentObject var videoManager: VideoManager<Message>
    
    @State private var location: CGPoint = CGPoint(x: 200, y: 100)
    @GestureState private var startLocation: CGPoint? = nil
    
    private let horizontalPadding: CGFloat = 16
    private var videoFrameHeight: CGFloat {
        videoFrameWidth / 1.78
    }
    
    private var videoFrameWidth: CGFloat {
        UIDevice.isLandscape ?
            (parentSize.width / 1.8):
        abs(parentSize.width - horizontalPadding) // Padding
    }
    
    private var midX: CGFloat { parentSize.width / 2 }
    private var midY: CGFloat { parentSize.height / 2 }
    
    enum Corner {
        case leftTop, leftBottom, rightTop, rightBottom
    }
    
    /// When we set .position(), sets its center to given point
    func rePositionVideoFrame(corner: Corner) {
        let inputViewOffset: CGFloat = 60
        let _horizontalPadding = horizontalPadding
        switch corner {
        case .leftTop: location = .init(
            x: (videoFrameWidth / 2) + (_horizontalPadding / 2),
            y: videoFrameHeight / 2
        )
        case .leftBottom: location = .init(
            x: (videoFrameWidth / 2) + (_hosrizontalPadding / 2),
            y: parentSize.height - videoFrameHeight / 2 - inputViewOffset
        )
        case .rightTop: location = .init(
            x: parentSize.width - (videoFrameWidth / 2) - (_horizontalPadding / 2),
            y: videoFrameHeight / 2
        )
        case .rightBottom: location = .init(
            x: parentSize.width - (videoFrameWidth / 2) - (_horizontalPadding / 2),
            y: parentSize.height - videoFrameHeight / 2 - inputViewOffset
        )
        }
    }
    
    public var body: some View {
        video
            .frame(width: videoFrameWidth, height: videoFrameHeight)
            .cornerRadius(8)
            .position(location)
            .gesture(simpleDrag)
            .animation(.linear(duration: 0.1))
            .onAppear { rePositionVideoFrame(corner: .leftTop) }
    }
    
    @ViewBuilder private var video: some View {
        if let message = videoManager.message, let videoItem = videoManager.videoItem {
            VideoPlayerContainer<Message>(media: videoItem, message: message, size: parentSize)
        }
    }
    
    // MARK: - Drag Gesture
    var simpleDrag: some Gesture {
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
                if self.location.y > midY {
                    if self.location.x > midX {
                        rePositionVideoFrame(corner: .rightBottom)
                    } else {
                        rePositionVideoFrame(corner: .leftBottom)
                    }
                } else {
                    if self.location.x > midX {
                        rePositionVideoFrame(corner: .rightTop)
                    } else {
                        rePositionVideoFrame(corner: .leftTop)
                    }
                }
            }
    }
    
}
