//
//  DefaultImageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

public struct ImageCell<Message: ChatMessage>: View {
    
    public let message: Message
    public let imageLoadingType: ImageLoadingKind
    public let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }
    
    @ViewBuilder private var imageView: some View {
        switch imageLoadingType {
        case .local(let image): self.localImage(uiImage: image)
        case .remote(let remoteUrl): self.remoteImage(url: remoteUrl)
        }
    }
    
    public var body: some View {
        imageView
    }
    
    // MARK: - case Local Image
    @ViewBuilder private func localImage(uiImage: UIImage) -> some View {
        let width = uiImage.size.width
        let height = uiImage.size.height
        let isLandscape = width > height
        
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(width / height, contentMode: isLandscape ? .fit : .fill)
            .frame(width: imageWidth, height: isLandscape ? nil : imageWidth)
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
    
    // MARK: - case Remote Image
    @ViewBuilder private func remoteImage(url: URL) -> some View {
        /**
         KFImage(url)
         .onSuccess(perform: { (result) in
             result.image.size
         })
         We can grab size & manage aspect ratio via a @State property
         but the list scroll behaviour becomes messy.
         
         So for now we use fixed width & scale height properly.
         */
        KFImage(url)
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth)
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
    
}

