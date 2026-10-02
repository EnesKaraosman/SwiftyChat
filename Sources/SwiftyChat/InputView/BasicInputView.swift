//
//  BasicInputView.swift
//
//
//  Created by Enes Karaosman on 19.10.2020.
//

import SwiftUI

/// A ready-to-use text input bar with a multiline text field and send button.
///
/// `BasicInputView` provides a standard chat input experience: a rounded text field
/// that expands up to 5 lines, and a send button that activates when text is entered.
/// The send button delivers the text as ``ChatMessageKind/text(_:)`` via the `onCommit` closure.
///
/// For a fully custom input view, pass your own view to ``ChatView``'s `inputView` closure instead.
public struct BasicInputView: View {

    @Binding private var message: String
    private let placeholder: String
    private let onAttachment: (() -> Void)?

    private var onCommit: ((ChatMessageKind) -> Void)?

    /// Creates a basic input view.
    /// - Parameters:
    ///   - message: Binding to the current text input.
    ///   - placeholder: Placeholder text shown when the field is empty.
    ///   - onAttachment: Shows an attachment button when provided; present your app's picker from this closure.
    ///   - onCommit: Called with a ``ChatMessageKind/text(_:)`` value when the user taps send.
    public init(
        message: Binding<String>,
        placeholder: String = "",
        onAttachment: (() -> Void)? = nil,
        onCommit: @escaping (ChatMessageKind) -> Void
    ) {
        self._message = message
        self.placeholder = placeholder
        self.onAttachment = onAttachment
        self.onCommit = onCommit
    }

    private var messageEditorView: some View {
        TextField(placeholder, text: $message, axis: .vertical)
            .lineLimit(1...5)
            .textFieldStyle(.plain)
            .padding(.leading, onAttachment == nil ? 12 : 0)
            .padding(.vertical, 11)
            .frame(minHeight: 44)
    }

    private var sendButton: some View {
        Button(action: {
            guard canSend else { return }
            onCommit?(.text(message))
            message.removeAll()
        }, label: {
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, canSend ? Color.accentColor : Color.gray.opacity(0.5))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        })
        .buttonStyle(.plain)
        .disabled(!canSend)
        .accessibilityLabel("Send message")
        .animation(.easeInOut(duration: 0.15), value: canSend)
    }

    private var canSend: Bool {
        !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if let onAttachment {
                Button(action: onAttachment) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add attachment")
            }
            messageEditorView
            sendButton
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: 26)
                #if os(iOS)
                .fill(Color(.secondarySystemBackground))
                #else
                .fill(Color(.controlBackgroundColor))
                #endif
        }
        .overlay {
            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(.primary.opacity(0.08), lineWidth: 1)
                .allowsHitTesting(false)
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
