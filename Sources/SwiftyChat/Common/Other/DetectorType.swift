//
//  DetectorType.swift
//  
// https://github.com/MessageKit/MessageKit/blob/5e16637ffc1fb39f2c3f9bc3396bbee41118947d/Sources/Models/DetectorType.swift
//

import Foundation

internal enum DetectorType: Hashable {

    case address
    case date
    case phoneNumber
    case url
    case transitInformation
    case custom(NSRegularExpression)

    public static var hashtag = DetectorType.custom(try! NSRegularExpression(pattern: "#[a-zA-Z0-9]{4,}", options: []))
    public static var mention = DetectorType.custom(try! NSRegularExpression(pattern: "@[a-zA-Z0-9]{4,}", options: []))

    internal var textCheckingType: NSTextCheckingResult.CheckingType {
        switch self {
        case .address: return .address
        case .date: return .date
        case .phoneNumber: return .phoneNumber
        case .url: return .link
        case .transitInformation: return .transitInformation
        case .custom: return .regularExpression
        }
    }

    /// Simply check if the detector type is a .custom
    public var isCustom: Bool {
        switch self {
        case .custom: return true
        default: return false
        }
    }

    ///The hashValue of the `DetectorType` so we can conform to `Hashable` and be sorted.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(toInt())
    }

    /// Return an 'Int' value for each `DetectorType` type so `DetectorType` can conform to `Hashable`
    private func toInt() -> Int {
        switch self {
        case .address: return 0
        case .date: return 1
        case .phoneNumber: return 2
        case .url: return 3
        case .transitInformation: return 4
        case .custom(let regex): return regex.hashValue
        }
    }

}
