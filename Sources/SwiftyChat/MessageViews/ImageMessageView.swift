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

    init(_ kind: ImageLoadingKind, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.imageLoadingType = kind
        self.width = width

        if case .remote(let url) = kind, let width, height == nil {
            let path = ImageCache.default.cachePath(forKey: url.cacheKey)
            if let image = PlatformImage(contentsOfFile: path) {
                self.height = image.size.height * (width / image.size.width)
                return
            }
        }

        self.height = height
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
        let width = image.size.width
        let height = image.size.height
        let isLandscape = width > height

        Image(image: image)
            .resizable()
            .aspectRatio(width / height, contentMode: isLandscape ? .fit : .fill)
            .frame(width: width, height: height)
    }

    private func remoteImage(url: URL) -> some View {
        KFAnimatedImage(url)
            .cacheOriginalImage()
            .fade(duration: 0.2)
            .forceTransition()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
    }
}

struct ImageMessageView<Message: ChatMessage>: View {

    let message: Message
    let imageLoadingType: ImageLoadingKind
    let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle

    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }

    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }

    @ViewBuilder
    private var imageView: some View {
        if case let ImageLoadingKind.local(uiImage) = imageLoadingType {
            let width = uiImage.size.width
            let height = uiImage.size.height
            let isLandscape = width > height
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth,
                height: isLandscape ? nil : imageWidth
            )
        } else {
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth
            )
        }
    }

    var body: some View {
        imageView
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
