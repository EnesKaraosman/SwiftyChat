//
//  Binding+Extension.swift
//  
//
//  Created by Enes Karaosman on 24.05.2020.
//

import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { wrappedValue },
            set: {
                wrappedValue = $0
                execute($0)
            }
        )
    }
}
