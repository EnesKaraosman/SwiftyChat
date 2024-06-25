//
//  DefaultImageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import Kingfisher

internal struct ImageLoadingKindCell: View {
    
    private let imageLoadingType: ImageLoadingKind
    private let width: CGFloat?
    private let height: CGFloat?

    
    init(_ kind: ImageLoadingKind, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.imageLoadingType = kind
        self.width = width
        
        if case .remote(let url) = kind, let width = width, height == nil {
            let path = ImageCache.default.cachePath(forKey: url.cacheKey)
            if let image = UIImage.init(contentsOfFile: path) {
                self.height = image.size.height * (width / image.size.width)
                return
            }
        }
        
        self.height = height
    }
    
    var body: some View {
        imageView
    }
    
    @ViewBuilder private var imageView: some View {
        switch imageLoadingType {
        case .local(let image): localImage(uiImage: image)
        case .remote(let remoteUrl): remoteImage(url: remoteUrl)
        }
    }
    
    @ViewBuilder private func localImage(uiImage: UIImage) -> some View {
        let _width = uiImage.size.width
        let _height = uiImage.size.height
        let isLandscape = _width > _height
        
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(_width / _height, contentMode: isLandscape ? .fit : .fill)
            .frame(width: width, height: height)
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
            .frame(width: width, height: height)
    }
    
}

internal struct ImageCell<Message: ChatMessage>: View {
    
    public let message: Message
    public let imageLoadingType: ImageLoadingKind
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let didTappedViewTask : (Message) -> Void
    
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }
    
    @ViewBuilder private var imageView: some View {
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
    
    @ViewBuilder public var body: some View {
        VStack(alignment: .leading) {
            imageView
            HStack(){
                    PriorityMessageViewStyle(priorityLevel: priority)
                        .padding(.bottom,10)
                        .padding(.leading,10)
                        .padding(.trailing,10)
                    
                        .frame(alignment: .leading)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )

                
                if let status = actionStatus {
                    Spacer()
                    TaskMessageViewSytle(status: status)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .trailing)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                        .onTapGesture(perform: {
                            self.didTappedViewTask(self.message)
                        })
                }
            }
        }
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

