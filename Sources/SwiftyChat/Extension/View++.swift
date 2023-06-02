//
//  View++.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal extension View {
    
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
