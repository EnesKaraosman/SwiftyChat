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
    case text(String)
    
    /// An image message, from local or remote
    case image(ImageLoadingKind)
    
    /// A location message, pins given location & presents on MapKit
    case location(LocationItem)
    
    /// Multiple options, disable itself after selection.
    case quickReply([QuickReplyItem])

    
    public var description: String {
        switch self {
        case .image(let imageLoadingType):
            switch imageLoadingType {
            case .local(let localImageName):
                return "MessageKind.image(local: \(localImageName))"
            case .remote(let remoteImageUrl):
                return "MessageKind.image(remote: \(remoteImageUrl))"
            }
        case .text(let text):
            return "MessageKind.text(\(text))"
        case .location(let location):
            return "MessageKind.location(lat: \(location.latitude), lon: \(location.longitude))"
        case .quickReply(let quickReplies):
            let options = quickReplies.map { $0.title }.joined(separator: ", ")
            return "MessageKind.quickReplies(options: \(options))"
        }
    }
    
}
