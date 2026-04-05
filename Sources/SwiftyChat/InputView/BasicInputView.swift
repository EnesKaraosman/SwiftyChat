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
            .lineLimit(1...5)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    #if os(iOS)
                    .fill(Color(.secondarySystemBackground))
                    #else
                    .fill(Color(.controlBackgroundColor))
                    #endif
            )
    }

    private var sendButton: some View {
        Button(action: {
            onCommit?(.text(message))
            message.removeAll()
        }, label: {
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, message.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
        })
        .disabled(message.isEmpty)
        .animation(.easeInOut(duration: 0.15), value: message.isEmpty)
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            messageEditorView
            sendButton
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        #if os(iOS)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
        #else
        .background(
            Color(.windowBackgroundColor)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -2)
        )
        #endif
    }
}
