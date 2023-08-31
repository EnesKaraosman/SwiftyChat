//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/22/23.
//

import SwiftUI

struct ReplyItemCell<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    public let reply : any ReplyItem
    public let message: Message
    public let size: CGSize
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }

    var body: some View {
       switch reply.fileType {
        case.text:
            textView
        case.image:
            imageText
        case.video:
            imageText
        }
        
    }
//
    var textView : some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "arrowshape.turn.up.left.fill")
                .resizable()
                .frame(width: 15, height: 15,alignment: .center)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(-180))
                .padding(8)
            VStack(alignment: .leading, spacing: 0) {
                Text(reply.displayName)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(cellStyle.textStyle.textColor)
                    .padding(.top,10)

                Text(reply.text ?? "")
                    .font(.system(size: 14, weight: .light))
                    .italic()
                    .foregroundColor(cellStyle.textStyle.textColor)

                    .padding(.top,5)

                Text(reply.date)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(cellStyle.textStyle.textColor)
                    .padding(.top,5)

            }
        }
    }
    
    var imageText : some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "arrowshape.turn.up.left.fill")
                .resizable()
                .frame(width: 15, height: 15,alignment: .center)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(-180))
                .padding(8)
            VStack(alignment: .leading, spacing: 0) {
                Text(reply.displayName)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Text(reply.text ?? "")
                    .font(.system(size: 12, weight: .light))
                    .italic()
                    .padding(.top,5)
                if let thumbnailURL = reply.thumbnailURL, !thumbnailURL.isEmpty {
                                  ImageCell(
                                      message: message,
                                      imageLoadingType: ImageLoadingKind.remote(URL(string: thumbnailURL)!),
                                      size: size
                                  )
                              }else if let photo = UIImage(systemName: "photo"){
                                  ImageCell(
                                      message: message,
                                      imageLoadingType: ImageLoadingKind.local(photo),
                                      size: size
                                  )
                              }
                Text(reply.date)
                    .font(.system(size: 11, weight: .regular))
                    .padding(.top,5)

            }
        }
    }
}

//struct ReplyItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        let reply = Reply(fileType: .text, displayName: "Amigo", thumbnailURL: nil, fileURL: nil, text: "sample text", date: "Feb 15, 2023, 6:05 PM")
////        let replies = [Reply(fileType: .text, displayName: "Amigo", thumbnailURL: nil, fileURL: nil, text: "sample text", date: date),
////                       Reply(fileType: .text, displayName: "Amigo", thumbnailURL: nil, fileURL: nil, text: "sample text", date: date),]
//        ReplyItemCell(reply: reply,message: M)
//    }
//}


