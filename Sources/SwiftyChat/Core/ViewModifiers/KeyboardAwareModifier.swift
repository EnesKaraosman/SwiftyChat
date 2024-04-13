//
//  KeyboardAwareModifier.swift
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import SwiftUIEKtensions

extension View {
    /// iOS only modifier to add necessary padding according to keyboard height
    func keyboardAwarePadding() -> some View {
        #if os(iOS)
        modifier(KeyboardAwareModifier())
        #else
        self
        #endif
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = .zero

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onKeyboardAppear { height in
                keyboardHeight = height
            }
    }
}
