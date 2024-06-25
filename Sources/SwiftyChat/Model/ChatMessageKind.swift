//
//  MessageKind.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI


public enum ActionItemStatus : String , Codable {
    case pending = "pending"
    case done = "done"
    
    public var body : String {
        switch self {
        case .pending:
            return "Task Pending".uppercased()
        case .done:
            return "TASK DONE".uppercased()
        }
    }
    
    public  var foregroundColor : Color {
        switch self {
        case .pending:
            return Color.yellow
        case .done:
            return Color.blue
        }
    }
    
    public  var logo : String {
        switch  self {
        case .pending:
            return "checkmark.circle"
        case .done:
            return "checkmark.circle"
        }
    }
    
}

public enum SendStatus :String, Codable {
    case sent = "sent"
    case sending = "sending"
    case failed = "failed"
}
public enum MessagePriorityLevel : Int, Codable{
    case critical = 3
    case high = 2
    case medium = 1
    case routine = 0
    case attention = -1
    
    public var body : String {
        switch self {
        case .critical:
            return "Critical Priority"
        case .high:
            return "High Priority"
        case .medium:
            return "Medium Priority"
        case .routine:
            return "Routine"
        case .attention:
            return "Attention Priority"
        }
    }
    
    public  var foregroundColor : Color {
        switch self {
        case . critical:
            return Color.red
        case .high:
            return Color.red
        case .medium:
            return Color.yellow
        default:
            return Color(hex: "3a3b45")

        }
    }
    
    public  var logo : String {
        switch  self {
        case .critical:
            return "waveform.path.ecg.rectangle"
        case .high:
            return "chevron.right.2"
        case .medium:
            return "equal"
        default:
            return "chevron.right.2"

        }
    }
}

public enum ImageLoadingKind {
    case local(UIImage)
    case remote(URL)
}

public enum ChatMessageKind: CustomStringConvertible {
    
    /// A text message,
    /// supports emoji 👍🏻 (auto scales if text is all about emojis)
    case text(String,[String]?,MessagePriorityLevel,ActionItemStatus?)
    
    /// An image message, from local(UIImage) or remote(URL).
    case image(ImageLoadingKind,MessagePriorityLevel,ActionItemStatus?)
    
    /// An image message, from local(UIImage) or remote(URL).
    case imageText(ImageLoadingKind, String,[String]?,MessagePriorityLevel,ActionItemStatus?)
    
    /// A location message, pins given location & presents on MapKit.
    case location(LocationItem)
    
    /// A contact message, generally for sharing purpose.
    case contact(ContactItem)
    
    /// Multiple options, disable itself after selection.
    case quickReply([QuickReplyItem])
    
    /// `CarouselItem` contains title, subtitle, image & button in a scrollable view
    case carousel([CarouselItem])
    
    /// A video message, opens the given URL.
    case video(VideoItem,MessagePriorityLevel,ActionItemStatus?)
    
    case videoText(VideoItem,String,[String]?,MessagePriorityLevel,ActionItemStatus?)

    /// Loading indicator contained in chat bubble
    case loading
    
    case systemMessage(String)
    
    case reply(any ReplyItem,[any ReplyItem],MessagePriorityLevel,ActionItemStatus?)
    
    case pdf(ImageLoadingKind,String,[String]?,URL,MessagePriorityLevel,ActionItemStatus?)
    
    case audio(URL,MessagePriorityLevel,ActionItemStatus?)
    
    
    public var description: String {
        switch self {
        case .image(let imageLoadingType, _, _):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.image(local: \(localImage))"
            case .remote(let remoteImageUrl):
                return "MessageKind.image(remote: \(remoteImageUrl))"
            }
        case .imageText(let imageLoadingType, let text, _, _, _):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.imageText(local: \(localImage), text:\(text)"
            case .remote(let remoteImageUrl):
                return "MessageKind.imageText(remote: \(remoteImageUrl), text:\(text))"
            }
        case .text(let text,let attentions, _, _):
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
        case .video(let videoItem, _, _):
            return "MessageKind.video(url: \(videoItem.url))"
        case .loading:
            return "MessageKind.loading"
        case .systemMessage(let message):
            return "MessageKind.systemMessage \(message)"
        case .videoText(let videoItem,let text,let attentions, _, _):
            return "MessageKind.video(url: \(videoItem.url) text \(text) tag \(attentions)"
        case . reply(let reply, let replies, _, _):
            return "MessageKind.reply reply \(reply) and replies \(replies)"
        
        case . pdf(let image, let text, let attentions,let pdfUrl, _, _):
            switch image {
            case .local(let localImage):
                return "MessageKind.pdf(local: \(localImage), text:\(text), attentions: \(attentions), pdfURL :\(pdfUrl)"
            case .remote(let remoteImageUrl):
                return "MessageKind.pdf(local: \(remoteImageUrl), text:\(text), attentions: \(attentions), pdfURL :\(pdfUrl)"
            }
        case .audio(let url, _ , _):
            return "MessageKind.audio URL: \(url)"

        }
    }
    
}
