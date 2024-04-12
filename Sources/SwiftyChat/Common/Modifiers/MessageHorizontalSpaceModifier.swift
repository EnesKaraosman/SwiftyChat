//
//  MessageModifier.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct MessageHorizontalSpaceModifier: ViewModifier {

    var messageKind: ChatMessageKind
    var isSender: Bool

    private var isSpaceFreeMessageKind: Bool {
        if case ChatMessageKind.carousel = messageKind {
            return true
        }

        return false
    }

    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            if isSender {
                Spacer(minLength: 10)
            }
            content
            if !isSender && !isSpaceFreeMessageKind {
                Spacer(minLength: 10)
            }
        }
    }
}
