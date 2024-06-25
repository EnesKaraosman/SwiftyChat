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
            Image(systemName: priorityLevel.logo)
                .foregroundColor(priorityLevel.foregroundColor)
                .rotationEffect(.degrees(self.degree()))
                .font(.system(size: fontSize))

            Text(priorityLevel.body)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(priorityLevel.foregroundColor)
                .font(.system(size: fontSize))
        }
        .padding(12)
        .background(Color(hex: "f8f9fc"))
        .clipShape(Capsule())
        
    }
    
    
    private func degree() -> Double {
        
        if priorityLevel == .high {
            return -90
        }
        
        if priorityLevel == .routine && priorityLevel == .attention {
            return 90
        }
        
        return 0
    }
}

#Preview {
    PriorityMessageViewStyle(priorityLevel: .routine)
    
}
