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

    private var messageEditorView: some View {
        TextField(placeholder, text: $message, axis: .vertical)
            .lineLimit(5)
    }

    private var sendButton: some View {
        Button(action: {
            onCommit?(.text(message))
            message.removeAll()
        }, label: {
            Circle().fill(Color(.systemBlue))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .foregroundStyle(.white)
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
                messageEditorView
                sendButton
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(.background)
        #endif
    }
}
