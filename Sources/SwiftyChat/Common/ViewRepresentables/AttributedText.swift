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
        uiView.text = text
        uiView.preferredMaxLayoutWidth = width
        uiView.sizeToFit()
        configuration(uiView)
    }
}
