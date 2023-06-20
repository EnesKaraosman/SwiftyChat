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
    func dateFormat(format: String) -> String {
        let dateFormatter = DateFormatter()

        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "'Today' 'At' h:mm a"

        } else if Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year) {
            dateFormatter.dateFormat = "MMM d 'At' h:mm a"

        } else {
            dateFormatter.dateFormat = format
        }
        
        return dateFormatter.string(from: self)
    }

    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
}


