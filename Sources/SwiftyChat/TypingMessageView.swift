//
//  TypingMessageView.swift
//  
//
//  Created by Jovan Milenković on 04/10/2020.
//

import SwiftUI

struct TypingMessageView: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    let isSender: Bool
    let user: ChatUser
    
    private var padding: CGFloat { isSender ? style.outgoingTextStyle.textPadding : style.incomingTextStyle.textPadding }
    private var backgroundColor: Color { isSender ? style.outgoingTextStyle.cellBackgroundColor : style.incomingTextStyle.cellBackgroundColor }
    
    var body: some View {
        HStack {
            if isSender {
                Spacer(minLength: 10)
            }
            TypingIndicatorView()
                .padding(padding)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: padding))
                .modifier(AvatarModifier(message: .init(user: user, messageKind: .text(""))))
            if !isSender {
                Spacer(minLength: 10)
            }
        }
    }
}

struct TypingIndicatorView: View {
    @State private var tick: Int = 0
    
    var body: some View {
        let bigSize: CGFloat = 10
        let smallSize: CGFloat = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation { tick = (tick + 1) % 3 }
        }
        return HStack {
            ForEach(0..<3) { index in
                let size = index == tick ? bigSize : smallSize
                Circle()
                    .frame(width: size, height: size)
                    .foregroundColor(Color.black)
            }
        }.fixedSize()
    }
}
