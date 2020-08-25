//
//  DefaultImageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

public struct ImageCell: View {
    
    public let message: ChatMessage
    public let imageLoadingType: ImageLoadingKind
    public let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }
    
    private var imageView: AnyView {
        switch imageLoadingType {
        case .local(let image):
            return self.localImage(uiImage: image)
        case .remote(let remoteUrl):
            return self.remoteImage(url: remoteUrl)
        }
    }
    
    public var body: some View {
        imageView
    }
    
    // MARK: - case Local Image
    private func localImage(uiImage: UIImage) -> AnyView {
        let width = uiImage.size.width
        let height = uiImage.size.height
        let isLandscape = width > height
        return Image(uiImage: uiImage)
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
            .embedInAnyView()
    }
    
    // MARK: - case Remote Image
    private func remoteImage(url: URL) -> AnyView {
        /**
         KFImage(url)
         .onSuccess(perform: { (result) in
             result.image.size
         })
         We can grab size & manage aspect ratio via a @State property
         but the list scroll behaviour becomes messy.
         
         So for now we use fixed width & scale height properly.
         */
        return WebImage(url: url)
            .resizable()
            .scaledToFit()
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
            .embedInAnyView()
        
    }
    
}
