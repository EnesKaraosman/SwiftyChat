//
//  View++.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public func conditionalStack<Content: View>(isVStack: Bool, content: () -> Content) -> AnyView {
    if isVStack {
        return VStack(alignment: .leading, spacing: 8) { content() }.embedInAnyView()
    }
    return HStack(spacing: 8) { content() }.embedInAnyView()
}

public extension View {
    
    func embedInAnyView() -> AnyView {
        return AnyView(self)
    }
    
    @ViewBuilder
    func keyboardAwarePadding() -> some View {
        if #available(iOS 14.0, *) {
            // no-op
            self
        } else {
            ModifiedContent(content: self, modifier: KeyboardAwareModifier())
        }
    }
    
    func conditionalModifier<M1: ViewModifier, M2: ViewModifier>
        (on condition: Bool, trueCase: M1, falseCase: M2) -> some View {
        Group {
            if condition {
                self.modifier(trueCase)
            } else {
                self.modifier(falseCase)
            }
        }
    }
    
    func conditionalModifier<M: ViewModifier>
        (on condition: Bool, trueCase: M) -> some View {
        Group {
            if condition {
                self.modifier(trueCase)
            }
        }
    }
    
}
