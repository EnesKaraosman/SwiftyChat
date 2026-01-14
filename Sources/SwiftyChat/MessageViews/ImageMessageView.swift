//
//  ImageMessageView.swift
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

import Kingfisher
import SwiftUI

struct ImageLoadingKindCell: View {

    private let imageLoadingType: ImageLoadingKind
    private let width: CGFloat?
    private let height: CGFloat?
    
    // Default aspect ratio for placeholder (4:3 landscape)
    private let defaultAspectRatio: CGFloat = 4.0 / 3.0

    init(_ kind: ImageLoadingKind, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.imageLoadingType = kind
        self.width = width
        self.height = height
    }
    
    /// Calculate a stable placeholder height when actual height is unknown
    private var placeholderHeight: CGFloat? {
        guard let width = width else { return nil }
        // Use a consistent aspect ratio for placeholder to prevent layout jumps
        return width / defaultAspectRatio
    }

    var body: some View {
        imageView
    }

    @ViewBuilder
    private var imageView: some View {
        switch imageLoadingType {
        case .local(let image): localImage(image)
        case .remote(let remoteUrl): remoteImage(url: remoteUrl)
        }
    }

    @ViewBuilder
    private func localImage(_ image: PlatformImage) -> some View {
        let imgWidth = image.size.width
        let imgHeight = image.size.height
        let isLandscape = imgWidth > imgHeight
        let aspectRatio = imgWidth / imgHeight
        
        // Calculate display dimensions
        let displayWidth = width ?? imgWidth
        let displayHeight = height ?? (displayWidth / aspectRatio)

        Image(image: image)
            .resizable()
            .aspectRatio(aspectRatio, contentMode: isLandscape ? .fit : .fill)
            .frame(width: displayWidth, height: displayHeight)
    }

    private func remoteImage(url: URL) -> some View {
        // Use provided height, or calculate stable placeholder height
        let displayHeight = height ?? placeholderHeight
        
        return KFImage.url(url)
            .cacheOriginalImage()
            .fade(duration: 0.2)
            .placeholder { _ in
                // Stable placeholder with same dimensions
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: width, height: displayHeight)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
            }
            .onSuccess { result in
                // Image loaded - Kingfisher handles the display
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: displayHeight)
            .clipped()
    }
}

struct ImageMessageView<Message: ChatMessage>: View {

    let message: Message
    let imageLoadingType: ImageLoadingKind
    let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle
    
    // Default aspect ratio for remote images (4:3)
    private let defaultAspectRatio: CGFloat = 4.0 / 3.0

    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    /// Calculate a consistent placeholder height for remote images
    private var defaultHeight: CGFloat {
        imageWidth / defaultAspectRatio
    }

    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }

    @ViewBuilder
    private var imageView: some View {
        switch imageLoadingType {
        case .local(let uiImage):
            let imgWidth = uiImage.size.width
            let imgHeight = uiImage.size.height
            let aspectRatio = imgWidth / imgHeight
            let isLandscape = imgWidth > imgHeight
            
            // For local images, calculate exact dimensions
            let displayHeight = isLandscape ? (imageWidth / aspectRatio) : imageWidth
            
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth,
                height: displayHeight
            )
            
        case .remote:
            // For remote images, use consistent placeholder height
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth,
                height: defaultHeight
            )
        }
    }

    var body: some View {
        imageView
            .background(cellStyle.cellBackgroundColor)
            .cornerRadius(cellStyle.cellCornerRadius)
            .clipped()
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

extension Image {
    init(image: PlatformImage) {
#if os(iOS)
        self.init(uiImage: image)
#endif

#if os(macOS)
        self.init(nsImage: image)
#endif
    }
}
