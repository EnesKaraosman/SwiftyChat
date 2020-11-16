//
//  SwiftUIView.swift
//  
//
//  Created by Enes Karaosman on 5.11.2020.
//

import SwiftUI

/// When play button is tapped, it lets videoManager know about VideoItem
/// So manager knows when to display actual videoPlayer above `ChatView`
internal struct VideoPlaceholderCell<Message: ChatMessage>: View {
    
    public let media: VideoItem
    public let message: Message
    public let size: CGSize
    
    @EnvironmentObject var style: ChatMessageCellStyle
    @EnvironmentObject var videoManager: VideoManager<Message>
    
    private var isThisVideoPlaying: Bool {
        videoManager.videoItem != nil && videoManager.message?.id == message.id
    }
    
    private var cellStyle: VideoPlaceholderCellStyle {
        style.videoPlaceholderCellStyle
    }
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    public var body: some View {
        thumbnailView
            .overlay(thumbnailOverlay)
            .onTapGesture {
                if isThisVideoPlaying { return }
                withAnimation {
                    videoManager.flushState()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        videoManager.message = message
                    }
                }
            }
    }
    
    @ViewBuilder private var thumbnailView: some View {
        ImageLoadingKindCell(
            media.placeholderImage,
            width: imageWidth,
            height: imageWidth / cellStyle.cellAspectRatio
        )
        .clipped()
        .blur(radius: cellStyle.cellBlurRadius)
        .background(cellStyle.cellBackgroundColor)
        .cornerRadius(cellStyle.cellCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
                .stroke(
                    cellStyle.cellBorderColor,
                    lineWidth: cellStyle.cellBorderWidth
                )
        )
        .shadow(
            color: cellStyle.cellShadowColor,
            radius: cellStyle.cellShadowRadius
        )
    }
    
    private var playButton: some View {
        Image(systemName: "play.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40)
            .foregroundColor(.secondary)
    }
    
    private var pipMessageView: some View {
        VStack {
            Image(systemName: "rectangle.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
            Text(media.pictureInPicturePlayingMessage)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.horizontal, 60)
                .padding(.top, 4)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
    }
    
    @ViewBuilder private var thumbnailOverlay: some View {
        if isThisVideoPlaying {
            pipMessageView
        } else {
            playButton
        }
    }
    
}
