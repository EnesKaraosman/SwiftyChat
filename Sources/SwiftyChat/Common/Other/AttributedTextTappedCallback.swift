//
//  TextTappedCallback.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

import Foundation

public struct AttributedTextTappedCallback {
    
    public var didSelectAddress: (_ addressComponents: [String: String]) -> Void
    public var didSelectDate: (_ date: Date) -> Void
    public var didSelectPhoneNumber: (_ phoneNumber: String) -> Void
    public var didSelectURL: (_ url: URL) -> Void
    public var didSelectTransitInformation: (_ transitInformation: [String: String]) -> Void
//    public var didSelectMention: (_ mention: String) -> Void
//    public var didSelectHashtag: (_ hashtag: String) -> Void
    
    public init(
        didSelectAddress: @escaping (_ addressComponents: [String: String]) -> Void = { _ in },
        didSelectDate: @escaping (_ date: Date) -> Void = { _ in },
        didSelectPhoneNumber: @escaping (_ phoneNumber: String) -> Void = { _ in },
        didSelectURL: @escaping (_ url: URL) -> Void = { _ in },
        didSelectTransitInformation: @escaping (_ transitInformation: [String: String]) -> Void = { _ in }
//        didSelectMention: @escaping (_ mention: String) -> Void = { _ in },
//        didSelectHashtag: @escaping (_ hashtag: String) -> Void = { _ in }
    ) {
        self.didSelectAddress = didSelectAddress
        self.didSelectDate = didSelectDate
        self.didSelectPhoneNumber = didSelectPhoneNumber
        self.didSelectURL = didSelectURL
        self.didSelectTransitInformation = didSelectTransitInformation
//        self.didSelectMention = didSelectMention
//        self.didSelectHashtag = didSelectHashtag
    }
    
}
