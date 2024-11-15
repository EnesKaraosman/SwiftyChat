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
                    .filter({ $0.activationState == .foregroundActive })
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .filter(\.isKeyWindow).first
                keyWindow?.endEditing(true)
                #endif
            }
    }
}
