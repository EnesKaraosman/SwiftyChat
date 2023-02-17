//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/17/23.
//

import SwiftUI

internal struct SystemMessageCell<Message: ChatMessage>: View {
    public let text: String
    public let message: Message

    var body: some View {
        Text(text)
            .font(Font.system(size: 12))
            .italic()
            .padding()
        }
}

