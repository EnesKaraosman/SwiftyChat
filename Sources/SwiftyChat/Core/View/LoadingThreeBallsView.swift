//
//  LoadingThreeBalls.swift
//  SwiftfulLoadingIndicators
//
//  Created by Nick Sarno on 1/12/21.
//

import Combine
import SwiftUI

struct LoadingThreeBalls: View {

    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let timing: Double

    let maxCounter = 3
    @State private var counter = 0

    let frame: CGSize
    let primaryColor: Color

    init(color: Color = .black, size: CGSize = .init(width: 50, height: 8), speed: Double = 0.5) {
        timing = speed
        timer = Timer.publish(every: timing, on: .main, in: .common).autoconnect()
        frame = size
        primaryColor = color
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<maxCounter, id: \.self) { index in
                Circle()
                    .fill(primaryColor)
                    .opacity(counter == index ? 1.0 : 0.5)
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onReceive(timer, perform: { _ in
            withAnimation(.linear(duration: timing)) {
                counter = counter == (maxCounter - 1) ? 0 : counter + 1
            }
        })
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    LoadingThreeBalls()
        .padding()
}
#endif
