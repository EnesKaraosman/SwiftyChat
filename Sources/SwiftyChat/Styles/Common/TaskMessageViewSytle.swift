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
        
        if status == .pending {
            Text("VIEW TASK")
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .font(.system(size: fontSize))
                .padding()
                .background(Color(hex: "f8f9fc"))
                .clipShape(Capsule())

        }else{
            Text("Done")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.system(size: fontSize))
                .padding()
                .background(Color.green)
                .clipShape(Capsule())
        }
    }
    
    
    
}

#Preview {
    TaskMessageViewSytle(status: .pending)
}
