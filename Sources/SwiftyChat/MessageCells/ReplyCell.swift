//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/22/23.
//

import SwiftUI

internal struct ReplyCell<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    public let message: Message
    public let replies : [any ReplyItem]
    public let reply : any ReplyItem
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let didTappedMedia: ((String) -> Void)
    public let didTappedViewTask : (Message) -> Void

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    var body: some View {
        
        
    LazyVStack(alignment: message.isSender ? .trailing : .leading,spacing: 0) {
        ZStack {
            Group {
                VStack(alignment: message.isSender ? .trailing : .leading,spacing: 0) {
                    ForEach(replies, id: \.id) { item in
                        
                        ReplyItemCell(reply: item, message: message, size: size, priority: priority, didTappedMedia: didTappedMedia)
                            .padding(.bottom)
                            .overlay (
                                VStack {
                                    Spacer()
                                    Divider()
                                        .background(cellStyle.textStyle.textColor)
                                }
                            )
                    }
                    
                    switch reply.fileType {
                    case .video:
                        ImageCell(
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size,
                            priority: .attention,
                            actionStatus:nil,
                            didTappedViewTask: {_ in
                                
                            }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded {
                                    if let url = reply.fileURL {
                                        self.didTappedMedia(url)
                                    }
                                }
                        )
                    case .image:
                        ImageCell(
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size,
                            priority: .attention,
                            actionStatus:nil,
                            didTappedViewTask: {_ in
                                
                            }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded {
                                    if let url = reply.fileURL {
                                        self.didTappedMedia(url)
                                    }
                                }
                        )
                        .padding(.top,10)
                    case .pdf:
                        ImageCell(
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size, 
                            priority: .attention,
                            actionStatus:nil,
                            didTappedViewTask: {_ in
                            }
                        )
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded {
                                    if let url = reply.fileURL {
                                        self.didTappedMedia(url)
                                    }
                                }
                        )
                        .padding(.top,10)
                    case.text :
                        EmptyView()
                    }
                    if let text = reply.text, text.count > 0{
                        Text(text)
                            .fontWeight(cellStyle.textStyle.fontWeight)
                            .modifier(EmojiModifier(text: reply.text!, defaultFont: cellStyle.textStyle.font))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(cellStyle.textStyle.textColor)
                            .padding(.top,10)

                    }
                    HStack(){
                        if priority != .attention {
                            PriorityMessageViewStyle(priorityLevel: priority)
                                .padding(.bottom,10)
                                .padding(.trailing,10)
                                .padding(.leading,10)
                                .frame(alignment: .leading)
                                .shadow (
                                    color: cellStyle.cellShadowColor,
                                    radius: cellStyle.cellShadowRadius
                                )
                        }
                        
                        
                        if let status = actionStatus {
                            Spacer()
                            TaskMessageViewSytle(status: status)
                                .padding(.bottom,10)
                                .padding(.trailing,10)
                                .padding(.leading,10)
                                .frame(alignment: .trailing)
                                .shadow (
                                    color: cellStyle.cellShadowColor,
                                    radius: cellStyle.cellShadowRadius
                                )
                                .onTapGesture(perform: {
                                    self.didTappedViewTask(self.message)
                                })
                        }
                    }
                }

            }
        }
           
            .padding(cellStyle.textPadding)
            .background(cellStyle.cellBackgroundColor)

            .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
            .overlay(

                RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
                .stroke(
                    cellStyle.cellBorderColor,
                    lineWidth: cellStyle.cellBorderWidth
                )
                .shadow(
                    color: cellStyle.cellShadowColor,
                    radius: cellStyle.cellShadowRadius
                )
            )

         
        }
    }
}

