//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 11/15/23.
//

import SwiftUI

public struct PriorityMessageViewStyle: View {
    public var priorityLevel : MessagePriorityLevel
    private let fontSize = 12.0
    // Public initializer
    public init(priorityLevel: MessagePriorityLevel) {
        self.priorityLevel = priorityLevel
    }
    
    public var body: some View {
        HStack {
            if priorityLevel == .high {
                Image(systemName: priorityLevel.logo)
                    .foregroundColor(priorityLevel.foregroundColor)
                    .rotationEffect(.degrees(-90))
                    .font(.system(size: fontSize))


            }else{
                Image(systemName: priorityLevel.logo)
                    .foregroundColor(priorityLevel.foregroundColor)
                    .font(.system(size: fontSize))

            }
            Text(priorityLevel.body)
                 .fontWeight(.semibold)
                 .foregroundColor(priorityLevel.foregroundColor)
                 .font(.system(size: fontSize))
        }
        .padding()
        .background(Color(hex: "f8f9fc"))
        .clipShape(Capsule())

    }
}

#Preview {
    PriorityMessageViewStyle(priorityLevel: .high)
    
}
