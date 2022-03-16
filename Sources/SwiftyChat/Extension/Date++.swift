//
//  Date++.swift
//  
//
//  Created by Enes Karaosman on 16.03.2022.
//

import Foundation

internal extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
