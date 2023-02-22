//
//  File.swift
//  
//
//  Created by AL Reyes on 2/22/23.
//

import Foundation


public enum ReplyItemKind {
    case image
    case video
    case text
}


public protocol ReplyItem : Identifiable {
    var id: UUID { get }
    var fileType :  ReplyItemKind {get}
    /// sender displayed name
    var displayName: String { get }
    /// sender file url thumbnail
    var thumbnailURL : String?  { get }
    /// sender file url
    var fileURL : String?  { get }
    /// initials from contact first and last name
    var text: String? { get }
    /// message date
    var date: String { get }
}
