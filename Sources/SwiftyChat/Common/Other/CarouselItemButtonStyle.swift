//
//  CarouselItemButtonStyle.swift
//  
//
//  Created by Enes Karaosman on 23.07.2020.
//

import SwiftUI

internal struct CarouselItemButtonStyle: ButtonStyle {
    
    public let backgroundColor: Color
    public let height: CGFloat
    
    public init(backgroundColor: Color = .blue, height: CGFloat) {
        self.backgroundColor = backgroundColor
        self.height = height
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .foregroundColor(.white)
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: height)
        .background(backgroundColor)
        .opacity(configuration.isPressed ? 0.88 : 1)
        .scaleEffect(configuration.isPressed ? 1.1 : 1, anchor: .center)
        .shadow(radius: configuration.isPressed ? 3 : 2)
    }
}
