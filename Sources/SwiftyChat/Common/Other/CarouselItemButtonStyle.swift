//
//  CarouselItemButtonStyle.swift
//
//
//  Created by Enes Karaosman on 23.07.2020.
//

import SwiftUI

internal struct CarouselItemButtonStyle: ButtonStyle {

    let backgroundColor: Color

    init(backgroundColor: Color = .blue) {
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(backgroundColor)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1, anchor: .center)
            .shadow(radius: configuration.isPressed ? 3 : 2)
    }
}
