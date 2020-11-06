//
//  VideoItem.swift
//  
//
//  Created by Enes Karaosman on 5.11.2020.
//

import Foundation
import UIKit

/// A protocol used to represent the data for a media message.
public protocol VideoItem {

    /// The url where the media is located.
    var url: URL { get }

    /// The image.
    var image: UIImage? { get }

    /// A placeholder image for when the image is obtained asynchronously.
    var placeholderImage: UIImage { get }

    /// The size of the media item.
    var size: CGSize { get }

}
