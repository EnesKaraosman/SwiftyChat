//
//  AttributedTextCell.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

import SwiftUI

internal struct AttributedTextCell: UIViewRepresentable {

    public typealias UILabel = MessageLabel

    public var text: String
    public var width: CGFloat
    public var configuration = { (view: UILabel) in }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel { UILabel() }
    
    public func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {
        DispatchQueue.main.async {
            if let attributedText = text.htmlToAttributedString {
                uiView.attributedText = attributedText
            } else {
                uiView.text = text
            }
            configuration(uiView)
            uiView.preferredMaxLayoutWidth = width
            uiView.sizeToFit()
        }
    }
}
