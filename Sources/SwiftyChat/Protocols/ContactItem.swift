//
//  ContactItem.swift
//  
//
//  Created by Enes Karaosman on 25.05.2020.
//

import Foundation
import class UIKit.UIImage

/// Represents the data for a contact.
public protocol ContactItem {
    
    /// contact displayed name
    var displayName: String { get }
    
    /// contact profile image
    var image: UIImage? { get }
    
    /// initials from contact first and last name
    var initials: String { get }
    
    /// contact phone numbers
    var phoneNumbers: [String] { get }
    
    /// contact emails
    var emails: [String] { get }
}
