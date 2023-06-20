//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/15/23.
//

import SwiftUI

public struct ChatNameAndTime<Message: ChatMessage>: View {
    public let message: Message
    public var tappedResendAction : (Message) -> Void

    public var body: some View {
        Group {
            HStack(alignment: .center){
                if !message.isSender {
                    Text(message.date.dateFormat(format: "MMM d yyyy 'At' h:mm a"))
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    Text("• \(message.user.userName)")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                }else{
                    
                    switch message.status {
                    case .failed:
                        Group {
                            Text("Re-Send")
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                                .italic()
                            Image(systemName: "arrow.counterclockwise.circle")
                                .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                                .foregroundColor(.red)
                        }
                        .onTapGesture {
                            self.tappedResendAction(message)
                        }

                    case .sending:
                        Text("Sending... ")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .italic()
                        Image(systemName: "paperplane")
                            .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                            .foregroundColor(.gray)
                    case .sent:
                        Text(message.date.dateFormat(format: "MMM d yyyy 'At' h:mm a"))
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        Image(systemName: "paperplane.fill")
                            .frame(maxWidth: 8, maxHeight: 8,alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
            }.frame(maxWidth: .infinity, alignment: message.isSender ?  .trailing : .leading)
        }
        .padding(message.isSender ? .trailing : .leading ,message.isSender ? 10 : 45)
        .padding(.bottom,20)
    }
}
