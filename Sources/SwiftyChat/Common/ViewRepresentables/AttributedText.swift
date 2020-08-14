//
//  AttributedText.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

import SwiftUI

public struct AttributedText: UIViewRepresentable {

    public typealias UILabel = MessageLabel

    public var text: String
    public var width: CGFloat
    public var configuration = { (view: UILabel) in }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel { UILabel() }
    
    public func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {
        DispatchQueue.main.async {
            if let attributedText = self.text.htmlToAttributedString {
                uiView.attributedText = attributedText
            } else {
                uiView.text = self.text
            }
            self.configuration(uiView)
            uiView.preferredMaxLayoutWidth = self.width
            uiView.sizeToFit()
        }
    }
}
