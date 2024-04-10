//
//  BasicInputView.swift
//  
//
//  Created by Enes Karaosman on 19.10.2020.
//

import SwiftUI

public struct BasicInputView: View {
    
    @Binding private var message: String
    private let placeholder: String
    
    private var onCommit: ((ChatMessageKind) -> Void)?
    
    public init(
        message: Binding<String>,
        placeholder: String = "",
        onCommit: @escaping (ChatMessageKind) -> Void
    ) {
        self._message = message
        self.placeholder = placeholder
        self.onCommit = onCommit
    }
    
    @ViewBuilder
    private var messageEditorView: some View {
        if #available(iOS 16.0, *) {
            TextField(placeholder, text: $message, axis: .vertical)
                .lineLimit(5)
        } else {
            TextEditor(text: $message)
                .frame(maxHeight: 64)
        }
    }
    
    private var sendButton: some View {
        Button(action: {
            self.onCommit?(.text(message))
            self.message.removeAll()
        }, label: {
            Circle().fill(Color(.systemBlue))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .offset(x: -1, y: 1)
                        .padding(8)
                )
        })
        .disabled(message.isEmpty)
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            Divider().padding(.bottom, 8)
            HStack {
                self.messageEditorView
                self.sendButton
            }
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 36)
    }
}
