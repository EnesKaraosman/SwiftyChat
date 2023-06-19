//
//  MessageKind.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI


public enum SendStatus :String, Codable {
    case sent = "sent"
    case sending = "sending"
    case failed = "failed"
}

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
    
    case reply(any ReplyItem,[any ReplyItem])
    
    case pdf(ImageLoadingKind,String,[String]?,URL)
    
    case audio(URL)
    
    
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
        case . reply(let reply, let replies):
            return "MessageKind.reply reply \(reply) and replies \(replies)"
        
        case . pdf(let image, let text, let attentions,let pdfUrl):
            switch image {
            case .local(let localImage):
                return "MessageKind.pdf(local: \(localImage), text:\(text), attentions: \(attentions), pdfURL :\(pdfUrl)"
            case .remote(let remoteImageUrl):
                return "MessageKind.pdf(local: \(remoteImageUrl), text:\(text), attentions: \(attentions), pdfURL :\(pdfUrl)"
            }
        case .audio(let url):
            return "MessageKind.audio URL: \(url)"

        }
    }
    
}
