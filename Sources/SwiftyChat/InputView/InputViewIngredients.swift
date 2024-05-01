//
//  File.swift
//  
//
//  Created by Enes Karaosman on 19.10.2020.
//

import SwiftUI
import UIKit

public struct ContentSizeThatFitsKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero

    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

internal struct TextAttributesKey: EnvironmentKey {
    static var defaultValue: TextAttributes = .init()
}

internal extension EnvironmentValues {
    var textAttributes: TextAttributes {
        get { self[TextAttributesKey.self] }
        set { self[TextAttributesKey.self] = newValue }
    }
}

internal struct TextAttributesModifier: ViewModifier {
    let textAttributes: TextAttributes

    func body(content: Content) -> some View {
        content.environment(\.textAttributes, self.textAttributes)
    }
}

internal extension View {
    func textAttributes(_ textAttributes: TextAttributes) -> some View {
        self.modifier(TextAttributesModifier(textAttributes: textAttributes))
    }
}

// MARK: - MultilineText
public struct MultilineTextField: View {
    @Binding private var attributedText: NSAttributedString
    @Binding private var isEditing: Bool

    @State private var contentSizeThatFits: CGSize = .zero

    private let placeholder: String
    private let textAttributes: TextAttributes

    private let onEditingChanged: ((Bool) -> Void)?
    private let onCommit: (() -> Void)?

    private var placeholderInset: EdgeInsets {
        .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
    }

    private var textContainerInset: UIEdgeInsets {
        .init(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
    }

    private var lineFragmentPadding: CGFloat {
        8.0
    }

    public init (
        attributedText: Binding<NSAttributedString>,
        placeholder: String = "",
        isEditing: Binding<Bool>,
        textAttributes: TextAttributes = .init(),
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._attributedText = attributedText
        self.placeholder = placeholder

        self._isEditing = isEditing

        self._contentSizeThatFits = State(initialValue: .zero)

        self.textAttributes = textAttributes

        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    public var body: some View {
        AttributedText(
            attributedText: $attributedText,
            isEditing: $isEditing,
            textAttributes: textAttributes,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
        .onPreferenceChange(ContentSizeThatFitsKey.self) {
            self.contentSizeThatFits = $0
        }
        .frame(idealHeight: self.contentSizeThatFits.height)
        .background(placeholderView, alignment: .topLeading)
    }

    @ViewBuilder private var placeholderView: some View {
        if attributedText.length == 0 {
            Text(placeholder).foregroundColor(.gray)
                .padding(placeholderInset)
        }
    }
}

// MARK: - AttributedText
internal struct AttributedText: View {
    @Environment(\.textAttributes)
    var envTextAttributes: TextAttributes

    @Binding var attributedText: NSAttributedString
    @Binding var isEditing: Bool

    @State private var sizeThatFits: CGSize = .zero

    private let textAttributes: TextAttributes

    private let onLinkInteraction: (((URL, UITextItemInteraction) -> Bool))?
    private let onEditingChanged: ((Bool) -> Void)?
    private let onCommit: (() -> Void)?

    var body: some View {
        let textAttributes = self.textAttributes
            .overriding(self.envTextAttributes)
            .overriding(TextAttributes.default)

        return GeometryReader { geometry in
            return UITextViewWrapper(
                attributedText: self.$attributedText,
                isEditing: self.$isEditing,
                sizeThatFits: self.$sizeThatFits,
                maxSize: geometry.size,
                textAttributes: textAttributes,
                onLinkInteraction: self.onLinkInteraction,
                onEditingChanged: self.onEditingChanged,
                onCommit: self.onCommit
            )
            .preference(
                key: ContentSizeThatFitsKey.self,
                value: self.sizeThatFits
            )
        }
    }

    init(
        attributedText: Binding<NSAttributedString>,
        isEditing: Binding<Bool>,
        textAttributes: TextAttributes = .init(),
        onLinkInteraction: ((URL, UITextItemInteraction) -> Bool)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._attributedText = attributedText
        self._isEditing = isEditing

        self.textAttributes = textAttributes

        self.onLinkInteraction = onLinkInteraction
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
}

public struct TextAttributes {
    
    var textContainerInset: UIEdgeInsets?
    var lineFragmentPadding: CGFloat?
    var returnKeyType: UIReturnKeyType?
    var textAlignment: NSTextAlignment?
    var linkTextAttributes: [NSAttributedString.Key: Any]?
    var clearsOnInsertion: Bool?
    var contentType: UITextContentType?
    var autocorrectionType: UITextAutocorrectionType?
    var autocapitalizationType: UITextAutocapitalizationType?
    var lineLimit: Int?
    var lineBreakMode: NSLineBreakMode?
    var isSecure: Bool?
    var isEditable: Bool?
    var isSelectable: Bool?
    var isScrollingEnabled: Bool?
    
    public static var `default`: Self {
        .init(
            textContainerInset: .init(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0),
            lineFragmentPadding: 8.0,
            returnKeyType: .default,
            textAlignment: nil,
            linkTextAttributes: nil,
            clearsOnInsertion: false,
            contentType: nil,
            autocorrectionType: .default,
            autocapitalizationType: .some(.none),
            lineLimit: nil,
            lineBreakMode: .byWordWrapping,
            isSecure: false,
            isEditable: true,
            isSelectable: true,
            isScrollingEnabled: true
        )
    }
    
    public init(
        textContainerInset: UIEdgeInsets? = nil,
        lineFragmentPadding: CGFloat? = nil,
        returnKeyType: UIReturnKeyType? = nil,
        textAlignment: NSTextAlignment? = nil,
        linkTextAttributes: [NSAttributedString.Key: Any]? = nil,
        clearsOnInsertion: Bool? = nil,
        contentType: UITextContentType? = nil,
        autocorrectionType: UITextAutocorrectionType? = nil,
        autocapitalizationType: UITextAutocapitalizationType? = nil,
        lineLimit: Int? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        isSecure: Bool? = nil,
        isEditable: Bool? = nil,
        isSelectable: Bool? = nil,
        isScrollingEnabled: Bool? = nil
    ) {
        self.textContainerInset = textContainerInset
        self.lineFragmentPadding = lineFragmentPadding
        self.returnKeyType = returnKeyType
        self.textAlignment = textAlignment
        self.linkTextAttributes = linkTextAttributes
        self.clearsOnInsertion = clearsOnInsertion
        self.contentType = contentType
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.lineLimit = lineLimit
        self.lineBreakMode = lineBreakMode
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
    }

    func overriding(_ fallback: Self) -> Self {
        let textContainerInset: UIEdgeInsets? = self.textContainerInset ?? fallback.textContainerInset
        let lineFragmentPadding: CGFloat? = self.lineFragmentPadding ?? fallback.lineFragmentPadding
        let returnKeyType: UIReturnKeyType? = self.returnKeyType ?? fallback.returnKeyType
        let textAlignment: NSTextAlignment? = self.textAlignment ?? fallback.textAlignment
        let linkTextAttributes: [NSAttributedString.Key: Any]? = self.linkTextAttributes ?? fallback.linkTextAttributes
        let clearsOnInsertion: Bool? = self.clearsOnInsertion ?? fallback.clearsOnInsertion
        let contentType: UITextContentType? = self.contentType ?? fallback.contentType
        let autocorrectionType: UITextAutocorrectionType? = self.autocorrectionType ?? fallback.autocorrectionType
        let autocapitalizationType: UITextAutocapitalizationType? = self.autocapitalizationType ?? fallback.autocapitalizationType
        let lineLimit: Int? = self.lineLimit ?? fallback.lineLimit
        let lineBreakMode: NSLineBreakMode? = self.lineBreakMode ?? fallback.lineBreakMode
        let isSecure: Bool? = self.isSecure ?? fallback.isSecure
        let isEditable: Bool? = self.isEditable ?? fallback.isEditable
        let isSelectable: Bool? = self.isSelectable ?? fallback.isSelectable
        let isScrollingEnabled: Bool? = self.isScrollingEnabled ?? fallback.isScrollingEnabled

        return .init(
            textContainerInset: textContainerInset,
            lineFragmentPadding: lineFragmentPadding,
            returnKeyType: returnKeyType,
            textAlignment: textAlignment,
            linkTextAttributes: linkTextAttributes,
            clearsOnInsertion: clearsOnInsertion,
            contentType: contentType,
            autocorrectionType: autocorrectionType,
            autocapitalizationType: autocapitalizationType,
            lineLimit: lineLimit,
            lineBreakMode: lineBreakMode,
            isSecure: isSecure,
            isEditable: isEditable,
            isSelectable: isSelectable,
            isScrollingEnabled: isScrollingEnabled
        )
    }
}

internal struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Environment(\.textAttributes)
    var envTextAttributes: TextAttributes

    @Binding var attributedText: NSAttributedString
    @Binding var isEditing: Bool
    @Binding var sizeThatFits: CGSize

    private let maxSize: CGSize

    private let textAttributes: TextAttributes

    private let onLinkInteraction: (((URL, UITextItemInteraction) -> Bool))?
    private let onEditingChanged: ((Bool) -> Void)?
    private let onCommit: (() -> Void)?

    init(
        attributedText: Binding<NSAttributedString>,
        isEditing: Binding<Bool>,
        sizeThatFits: Binding<CGSize>,
        maxSize: CGSize,
        textAttributes: TextAttributes = .init(),
        onLinkInteraction: ((URL, UITextItemInteraction) -> Bool)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._attributedText = attributedText
        self._isEditing = isEditing
        self._sizeThatFits = sizeThatFits

        self.maxSize = maxSize

        self.textAttributes = textAttributes

        self.onLinkInteraction = onLinkInteraction
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()

        view.delegate = context.coordinator

        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = UIColor.label
        view.backgroundColor = .clear

        let attrs = self.textAttributes

        if let textContainerInset = attrs.textContainerInset {
            view.textContainerInset = textContainerInset
        }
        if let lineFragmentPadding = attrs.lineFragmentPadding {
            view.textContainer.lineFragmentPadding = lineFragmentPadding
        }
        if let returnKeyType = attrs.returnKeyType {
            view.returnKeyType = returnKeyType
        }
        if let textAlignment = attrs.textAlignment {
            view.textAlignment = textAlignment
        }
        if let linkTextAttributes = attrs.linkTextAttributes {
            view.linkTextAttributes = linkTextAttributes
        }
        if let linkTextAttributes = attrs.linkTextAttributes {
            view.linkTextAttributes = linkTextAttributes
        }
        if let clearsOnInsertion = attrs.clearsOnInsertion {
            view.clearsOnInsertion = clearsOnInsertion
        }
        if let contentType = attrs.contentType {
            view.textContentType = contentType
        }
        if let autocorrectionType = attrs.autocorrectionType {
            view.autocorrectionType = autocorrectionType
        }
        if let autocapitalizationType = attrs.autocapitalizationType {
            view.autocapitalizationType = autocapitalizationType
        }
        if let isSecure = attrs.isSecure {
            view.isSecureTextEntry = isSecure
        }
        if let isEditable = attrs.isEditable {
            view.isEditable = isEditable
        }
        if let isSelectable = attrs.isSelectable {
            view.isSelectable = isSelectable
        }
        if let isScrollingEnabled = attrs.isScrollingEnabled {
            view.isScrollEnabled = isScrollingEnabled
        }
        if let lineLimit = attrs.lineLimit {
            view.textContainer.maximumNumberOfLines = lineLimit
        }
        if let lineBreakMode = attrs.lineBreakMode {
            view.textContainer.lineBreakMode = lineBreakMode
        }

        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
//        if isEditing {
//            print("updateUIView uiView.becomeFirstResponder")
//            uiView.becomeFirstResponder()
//        } else {
//            print("updateUIView uiView.resignFirstResponder")
//            uiView.resignFirstResponder()
//        }
        UITextViewWrapper.recalculateHeight(
            view: uiView,
            maxContentSize: self.maxSize,
            result: $sizeThatFits
        )
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            attributedText: $attributedText,
            isEditing: $isEditing,
            sizeThatFits: $sizeThatFits,
            maxContentSize: { self.maxSize },
            onLinkInteraction: onLinkInteraction,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    fileprivate static func recalculateHeight(
        view: UIView,
        maxContentSize: CGSize,
        result: Binding<CGSize>
    ) {
        let sizeThatFits = view.sizeThatFits(maxContentSize)
        if result.wrappedValue != sizeThatFits {
            DispatchQueue.main.async {
                // Must be called asynchronously:
                result.wrappedValue = sizeThatFits
            }
        }
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var attributedText: NSAttributedString
        @Binding var isEditing: Bool
        @Binding var sizeThatFits: CGSize

        private let maxContentSize: () -> CGSize

        private var onLinkInteraction: (((URL, UITextItemInteraction) -> Bool))?
        private var onEditingChanged: ((Bool) -> Void)?
        private var onCommit: (() -> Void)?

        init(
            attributedText: Binding<NSAttributedString>,
            isEditing: Binding<Bool>,
            sizeThatFits: Binding<CGSize>,
            maxContentSize: @escaping () -> CGSize,
            onLinkInteraction: ((URL, UITextItemInteraction) -> Bool)?,
            onEditingChanged: ((Bool) -> Void)?,
            onCommit: (() -> Void)?
        ) {
            self._attributedText = attributedText
            self._isEditing = isEditing
            self._sizeThatFits = sizeThatFits

            self.maxContentSize = maxContentSize

            self.onLinkInteraction = onLinkInteraction
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textViewDidChange(_ uiView: UITextView) {
            attributedText = uiView.attributedText
            onEditingChanged?(true)
            UITextViewWrapper.recalculateHeight(
                view: uiView,
                maxContentSize: maxContentSize(),
                result: $sizeThatFits
            )
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                guard !self.isEditing else {
                    return
                }
                self.isEditing = true
            }

            onEditingChanged?(false)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                guard self.isEditing else {
                    return
                }
                self.isEditing = false
            }

            onCommit?()
        }

        func textView(
            _ textView: UITextView,
            shouldInteractWith url: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {
            return onLinkInteraction?(url, interaction) ?? true
        }

        func textView(
            _ textView: UITextView,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {
            guard let onCommit = self.onCommit, text == "\n" else {
                return true
            }

            textView.resignFirstResponder()
            onCommit()

            return false
        }
    }
}
