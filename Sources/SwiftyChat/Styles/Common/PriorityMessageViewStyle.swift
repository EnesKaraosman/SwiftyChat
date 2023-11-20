//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 11/15/23.
//

import SwiftUI

public struct PriorityMessageViewStyle: View {
    var priorityLevel : MessagePriorityLevel
    private let fontSize = 8.5
    public var body: some View {
        HStack {
            if priorityLevel == .high {
                Image(systemName: priorityLevel.logo)
                    .foregroundColor(priorityLevel.foregroundColor)
                    .rotationEffect(.degrees(-90))
                    .font(.system(size: fontSize))


            }else{
                Image(systemName: priorityLevel.logo)
                    .font(.system(size: fontSize))

            }
            Text(priorityLevel.body)
                 .fontWeight(.semibold)
                 .foregroundColor(priorityLevel.foregroundColor)
                 .font(.system(size: fontSize))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(hex: "f8f9fc"))
        .clipShape(Capsule())

    }
}

#Preview {
    PriorityMessageViewStyle(priorityLevel: .high)
    
}
