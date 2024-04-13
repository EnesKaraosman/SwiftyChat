//
//  DismissKeyboardModifier.swift
//  
//
//  Created by Enes Karaosman on 28.08.2020.
//

import SwiftUI

extension View {
    func dismissKeyboardOnTappingOutside() -> some View {
        modifier(DismissKeyboardOnTappingOutside())
    }
}

struct DismissKeyboardOnTappingOutside: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                #if os(iOS)
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
                #endif
            }
    }
}
