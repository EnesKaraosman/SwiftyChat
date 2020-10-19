//
//  BasicInputView.swift
//  
//
//  Created by Enes Karaosman on 19.10.2020.
//

import SwiftUI

public struct BasicInputView: View {

    @Binding private var text: String
    @Binding private var isEditing: Bool

    @State private var contentSizeThatFits: CGSize

    private let placeholder: String
    private let textAttributes: TextAttributes

    private let onEditingChanged: ((Bool) -> Void)?
    private let onSend: (() -> Void)

    internal var internalAttributedMessage: Binding<NSAttributedString> {
        Binding<NSAttributedString>(
            get: {
                NSAttributedString(
                    string: self.text,
                    attributes: [
                        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                        NSAttributedString.Key.foregroundColor: UIColor.label,
                    ]
                )
            },
            set: { self.text = $0.string }
        )
    }

    private var placeholderInset: EdgeInsets {
        .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
    }

    private var textContainerInset: UIEdgeInsets {
        .init(top: 8, left: 0.0, bottom: 8, right: 0.0)
    }

    private var lineFragmentPadding: CGFloat {
        8.0
    }

    public init(
        text: Binding<String>,
        placeholder: String = "",
        isEditing: Binding<Bool>,
        textAttributes: TextAttributes = .init(),
        onEditingChanged: ((Bool) -> Void)? = nil,
        onSend: @escaping (() -> Void)
    ) {
        self._text = text
        self.placeholder = placeholder
        self._isEditing = isEditing
        self._contentSizeThatFits = State(initialValue: .zero)
        self.textAttributes = textAttributes
        self.onEditingChanged = onEditingChanged
        self.onSend = onSend
    }

    public var body: some View {
        HStack {
            inputBar
            sendButton
        }
    }

    @ViewBuilder var inputBar: some View {
        AttributedText(
            attributedText: internalAttributedMessage,
            isEditing: $isEditing,
            textAttributes: textAttributes,
            onEditingChanged: onEditingChanged,
            onCommit: nil
        )
        .onPreferenceChange(ContentSizeThatFitsKey.self) {
            self.contentSizeThatFits = $0
        }
        .frame(
            idealHeight: self.contentSizeThatFits.height
        )
        .background(placeholderView, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke()
        )
    }

    @ViewBuilder var placeholderView: some View {
        if text.isEmpty {
            Text(placeholder).foregroundColor(Color(UIColor.lightGray))
                .padding(placeholderInset)
        }
    }

    @ViewBuilder var sendButton: some View {
        Button(action: {
            if !text.isEmpty {
                onSend()
            }
            text.removeAll()
        }, label: {
            Image(systemName: "paperplane.fill")
                .imageScale(.large)
                .foregroundColor(.blue)
                .frame(width: 36, height: 36)
                .offset(x: -1, y: 1)
                .background(Circle().fill(Color.white))
        })
    }

}
