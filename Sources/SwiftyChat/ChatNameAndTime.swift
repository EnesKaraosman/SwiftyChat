//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/15/23.
//

import SwiftUI

public struct ChatNameAndTime<Message: ChatMessage>: View {
    public let message: Message

    public var body: some View {
        Group {
            HStack(alignment: .center){
                Text(message.date.dateFormat(format: "MMM d 'At' h:mm a"))
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                if !message.isSender {
                    Text("• \(message.user.userName)")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                }
            }.frame(maxWidth: .infinity, alignment: message.isSender ?  .trailing : .leading)
        }
        .padding(message.isSender ? .trailing : .leading ,message.isSender ? 10 : 45)
        .padding(.bottom,20)
    }
}
