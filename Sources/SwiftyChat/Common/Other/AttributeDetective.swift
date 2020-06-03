//
//  AttributeDetective.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

import Foundation

/// Pre checks if text contains given detector checking type.
internal struct AttributeDetective {
    
    var text: String
    
    var enabledDetectors: [DetectorType]
    
    func doesContain() -> Bool {
        
        let results: [Bool] = enabledDetectors.map { (detector) in
            let _detector = try! NSDataDetector(types: detector.textCheckingType.rawValue)
            return !_detector.matches(
                in: text,
                options: [],
                range: NSRange(location: 0, length: text.utf16.count)
            )
            .filter { Range($0.range, in: text) != nil }
            .isEmpty
        }
        
        return results.contains(true)
    }
    
}

