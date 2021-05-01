//
//  Double++.swift
//  
//
//  Created by Enes Karaosman on 11.11.2020.
//

import Foundation

internal extension Double {
    
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()

    func formatSecondsToHMS() -> String {
        guard !self.isNaN,
          let text = Double.timeHMSFormatter.string(from: self) else {
                return "00:00"
        }
         
        return text
    }

}
