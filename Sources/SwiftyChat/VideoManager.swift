//
//  VideoManager.swift
//  
//
//  Created by Enes Karaosman on 9.11.2020.
//

import Foundation

/// Behaves like a bridge between `VideoPlaceHolderCell` & `PIPVideoCell`
/// when placeHolder cell tapped, `message` parameter is set
/// also this change is being observed in `PIPVideoCell`so activates video frame.
internal final class VideoManager<Message: ChatMessage>: ObservableObject {
    
    @Published var message: Message?
    @Published var isFullScreen = false
    var videoItem: VideoItem? {
        if let message = message {
            if case let ChatMessageKind.video(videoItem,_ ,_) = message.messageKind {
                return videoItem
            }
        }
        return nil
    }
    
    func flushState() {
        message = nil
        isFullScreen = false
    }
    
}
