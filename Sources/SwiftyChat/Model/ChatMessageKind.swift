//
//  MessageKind.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public enum ImageLoadingKind {
    case local(UIImage)
    case remote(URL)
}

public enum ChatMessageKind: CustomStringConvertible {
    
    /// A text message,
    /// supports emoji 👍🏻 (auto scales if text is all about emojis)
    case text(String,[String]?)
    
    /// An image message, from local(UIImage) or remote(URL).
    case image(ImageLoadingKind)
    
    /// An image message, from local(UIImage) or remote(URL).
    case imageText(ImageLoadingKind, String,[String]?)
    
    /// A location message, pins given location & presents on MapKit.
    case location(LocationItem)
    
    /// A contact message, generally for sharing purpose.
    case contact(ContactItem)
    
    /// Multiple options, disable itself after selection.
    case quickReply([QuickReplyItem])
    
    /// `CarouselItem` contains title, subtitle, image & button in a scrollable view
    case carousel([CarouselItem])
    
    /// A video message, opens the given URL.
    case video(VideoItem)
    
    case videoText(VideoItem,String,[String]?)

    /// Loading indicator contained in chat bubble
    case loading
    
    case systemMessage(String)
    
    
    public var description: String {
        switch self {
        case .image(let imageLoadingType):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.image(local: \(localImage))"
            case .remote(let remoteImageUrl):
                return "MessageKind.image(remote: \(remoteImageUrl))"
            }
        case .imageText(let imageLoadingType, let text, _):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.imageText(local: \(localImage), text:\(text)"
            case .remote(let remoteImageUrl):
                return "MessageKind.imageText(remote: \(remoteImageUrl), text:\(text))"
            }
        case .text(let text,let attentions):
            return "MessageKind.text(\(text) attentions\(attentions)"
        case .location(let location):
            return "MessageKind.location(lat: \(location.latitude), lon: \(location.longitude))"
        case .contact(let contact):
            return "MessageKind.contact(\(contact.displayName))"
        case .quickReply(let quickReplies):
            let options = quickReplies.map { $0.title }.joined(separator: ", ")
            return "MessageKind.quickReplies(options: \(options))"
        case .carousel(let carouselItems):
            return "MessageKind.carousel(itemCount: \(carouselItems.count))"
        case .video(let videoItem):
            return "MessageKind.video(url: \(videoItem.url))"
        case .loading:
            return "MessageKind.loading"
        case .systemMessage(let message):
            return "MessageKind.systemMessage \(message)"
        case .videoText(let videoItem,let text,let attentions):
            return "MessageKind.video(url: \(videoItem.url) text \(text) tag \(attentions)"
        }
    }
    
}
