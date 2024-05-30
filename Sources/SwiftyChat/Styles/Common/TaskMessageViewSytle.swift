//
//  SwiftUIView.swift
//
//
//  Created by 1gz on 5/8/24.
//

import SwiftUI

public struct TaskMessageViewSytle: View {
    private let fontSize = 12.0
    public var status : ActionItemStatus
    
    public init(status : ActionItemStatus) {
        self.status = status
    }
    public var body: some View {
        
        Text("VIEW TASK")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(Color.blue)
            .font(.system(size: fontSize))
            .padding(12)
            .background(Color(hex: "f8f9fc"))
            .clipShape(Capsule())
    }
    
    
    
}

#Preview {
    TaskMessageViewSytle(status: .pending)
}
