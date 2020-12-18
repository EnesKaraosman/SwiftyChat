//
//  View++.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal func conditionalStack<Content: View>(isVStack: Bool, content: () -> Content) -> AnyView {
    if isVStack {
        return VStack(alignment: .leading, spacing: 8) { content() }.embedInAnyView()
    }
    return HStack(spacing: 8) { content() }.embedInAnyView()
}

internal extension View {
    
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
    
}
