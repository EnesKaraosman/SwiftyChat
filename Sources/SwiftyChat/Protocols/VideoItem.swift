//
//  VideoItem.swift
//  
//
//  Created by Enes Karaosman on 5.11.2020.
//

import Foundation

/// A protocol used to represent the data for a media message.
public protocol VideoItem {

    /// The url where the media is located.
    var url: URL { get }

    /// A placeholder image for when the image is obtained asynchronously.
    var placeholderImage: ImageLoadingKind { get }
    
    /// The message is shown in thumbnailView when the video is playing.
    var pictureInPicturePlayingMessage: String { get }
}
