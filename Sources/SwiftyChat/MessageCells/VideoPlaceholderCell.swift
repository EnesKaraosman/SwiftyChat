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
    
    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    public var body: some View {
        thumbnailView
            .overlay(thumbnailOverlay)
            .onTapGesture {
                withAnimation {
                    videoManager.flushState()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        videoManager.message = message
                    }
                }
            }
    }
    
    @ViewBuilder private var thumbnailView: some View {
        ImageLoadingKindCell(
            media.placeholderImage,
            width: imageWidth,
            height: imageWidth / 1.78
        )
        .clipped()
        .blur(radius: 1)
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
            Text("Bu video resim içinde resim olarak oynuyor.")
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.horizontal, 60)
                .padding(.top, 4)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
    }
    
    @ViewBuilder private var thumbnailOverlay: some View {
        if videoManager.videoItem != nil && videoManager.message?.id == message.id {
            pipMessageView
        } else {
            playButton
        }
    }
    
}
