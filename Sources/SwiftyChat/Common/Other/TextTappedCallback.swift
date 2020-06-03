//
//  TextTappedCallback.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

import Foundation

public struct TextTappedCallback {
    public var didSelectAddress: (_ addressComponents: [String: String]) -> Void = { _ in }
    public var didSelectDate: (_ date: Date) -> Void = { _ in }
    public var didSelectPhoneNumber: (_ phoneNumber: String) -> Void = { _ in }
    public var didSelectURL: (_ url: URL) -> Void = { _ in }
    public var didSelectTransitInformation: (_ transitInformation: [String: String]) -> Void = { _ in }
    public var didSelectMention: (_ mention: String) -> Void = { _ in }
    public var didSelectHashtag: (_ hashtag: String) -> Void = { _ in }
}
