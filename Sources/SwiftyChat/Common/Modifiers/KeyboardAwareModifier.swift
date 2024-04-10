//
//  KeyboardAwareModifier.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

#if os(iOS)
import Combine
import SwiftUI

internal extension View {
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
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
#endif
