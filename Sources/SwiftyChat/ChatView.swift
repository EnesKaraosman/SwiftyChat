//
//  ChatView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import SwiftUIEKtensions

public struct ChatView<Message: ChatMessage, User: ChatUser>: View {
    
    @Binding private var messages: [Message]
    private var inputView: () -> AnyView

    private var onMessageCellTapped: (Message) -> Void = { msg in print(msg.messageKind) }
    private var onMessageCellLongPressed: (Message) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (Message) -> AnyView = { _ in EmptyView().embedInAnyView() }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, Message) -> [ContactCellButton] = { _, _ in [] }
    private var onAttributedTextTappedCallback: () -> AttributedTextTappedCallback = { return AttributedTextTappedCallback() }
    private var onCarouselItemAction: (CarouselItemButton, Message) -> Void = { (_, _) in }
    private var inset: EdgeInsets
    private var dateFormater: DateFormatter = DateFormatter()
    private var dateHeaderTimeInterval: TimeInterval
    private var shouldShowGroupChatHeaders: Bool
    private var reachedTop: ((_ lastDate : Date) -> Void)?
    private var tappedResendAction : (Message) -> Void

    private var inverted : Bool
    
    @Binding private var scrollTo: UUID?
    @Binding private var scrollToBottom: Bool
    @Binding private var hasMore: Bool
    @Binding private var isFetching: Bool
    @State private var isKeyboardActive = false
    
    @State private var contentSizeThatFits: CGSize = .zero
    @Binding private var additionalHeight : CGFloat

    private var messageEditorHeight: CGFloat {
        min(
            contentSizeThatFits.height,
            0.25 * UIScreen.main.bounds.height
        ) + additionalHeight
    }
    
    
    private func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
      
                chatView(in: geometry)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                inputView()
                         .onPreferenceChange(ContentSizeThatFitsKey.self) {
                             contentSizeThatFits = $0
                         }
                         .frame(height: messageEditorHeight)
                         .padding(.bottom, 12)
                     
                     PIPVideoCell<Message>()
                 }
                 .iOS { $0.keyboardAwarePadding() }
             }
             .environmentObject(DeviceOrientationInfo())
             .environmentObject(VideoManager<Message>())
             .edgesIgnoringSafeArea(.bottom)
           //  .iOS { $0.dismissKeyboardOnTappingOutside() }
    }
    
    @ViewBuilder private func chatView(in geometry: GeometryProxy) -> some View {

        if inverted {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack {
                        ForEach(messages) { message in
                            Group {
                                
                                switch message.messageKind {
                                case .systemMessage(let text):
                                    SystemMessageCell(text: text,message:message)
                                        .onAppear {
                                            let total = self.messages.count
                                            let lastItem : Message!
                                            if total >= 5 {
                                                lastItem = self.messages[total - 5]
                                            }else{
                                                lastItem = self.messages.last
                                            }
                                            if message.id == lastItem.id {
                                                if let lastMessage = self.messages.last{
                                                    self.reachedTop?(lastMessage.date)
                                                }
                                            }
                                        }
                                default:
                                    let showDateheader = shouldShowDateHeader(
                                        messages: messages,
                                        thisMessage: message
                                    )
                                    let shouldShowDisplayName = shouldShowDisplayName(
                                        messages: messages,
                                        thisMessage: message,
                                        dateHeaderShown: showDateheader
                                    )
                                    ChatNameAndTime(message: message, tappedResendAction: self.tappedResendAction)
                                    chatMessageCellContainer(in: geometry.size, with: message, with: shouldShowDisplayName)
                                        .id(message.id)
                                        .onAppear {
                                            let total = self.messages.count
                                            let lastItem : Message!
                                            if total >= 5 {
                                                lastItem = self.messages[total - 5]
                                            }else{
                                                lastItem = self.messages.last
                                            }
                                            if message.id == lastItem.id {
                                                if let lastMessage = self.messages.last{
                                                    self.reachedTop?(lastMessage.date)
                                                }
                                            }
                                        }
                                    
                                    if showDateheader {
                                        Text(dateFormater.string(from: message.date))
                                            .font(.subheadline)
                                    }
                                    
                                    if shouldShowDisplayName {
                                        Text(message.user.userName)
                                            .font(.caption)
                                            .multilineTextAlignment(.trailing)
                                            .frame(
                                                maxWidth: geometry.size.width * (UIDevice.isLandscape ? 0.6 : 0.75),
                                                minHeight: 1,
                                                alignment: message.isSender ? .trailing: .leading
                                            )
                                    }
                                }
                       
                                if (message.id == self.messages.last!.id) && isFetching {
                                    ProgressView()
                                        .padding()

                                }
                                
                            }
                            .rotationEffect(Angle(degrees: 180)).scaleEffect(x:  -1.0, y: 1.0, anchor: .center)
                            
                        }
                   
                        
                        Group {
                            if messages.count == 0 && isFetching {
                                Spacer(minLength: geometry.size.height / 2)
                                VStack(alignment: .center) {
                                    ProgressView()
                                        .padding()
                                    Text("Fetching Messages")
                                }
                            }
                        }
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x:  -1.0, y: 1.0, anchor: .center)
                    }
                    .padding(EdgeInsets(top: inset.top, leading: inset.leading, bottom: 0, trailing: inset.trailing))
                    .onChange(of: scrollToBottom) { value in
                        if value {
                            withAnimation { 
                                proxy.scrollTo("bottom")
                            }
                            scrollToBottom = false
                        }
                    }
                    .onChange(of: scrollTo) { value in
                        if let value = value {
                            proxy.scrollTo(value, anchor: .bottom)
                            scrollTo = nil
                            print("scrollTo to specific valud")
                        }
                    }
                    .iOS {
                        // Auto Scroll with Keyboard Notification
                        $0.onReceive(
                            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                                .debounce(for: .milliseconds(400), scheduler: RunLoop.main),
                            perform: { _ in
                                if !isKeyboardActive {
                                    isKeyboardActive = true
                                    scrollToBottom = true
                                }
                            }
                        )
                        .onReceive(
                            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                            perform: { _ in isKeyboardActive = false }
                        )
                    }
                }
            }
            .background(Color.clear)
            .padding(.top, messageEditorHeight + 30)
            .rotationEffect(Angle(degrees: 180)).scaleEffect(x:  -1.0, y: 1.0, anchor: .center)
        }else{
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack {
                        ForEach(messages) { message in
                            let showDateheader = shouldShowDateHeader(
                                messages: messages,
                                thisMessage: message
                            )
                            let shouldShowDisplayName = shouldShowDisplayName(
                                messages: messages,
                                thisMessage: message,
                                dateHeaderShown: showDateheader
                            )
                            
                            if showDateheader {
                                Text(dateFormater.string(from: message.date))
                                    .font(.subheadline)
                            }
                            
                            if shouldShowDisplayName {
                                Text(message.user.userName)
                                    .font(.caption)
                                    .multilineTextAlignment(.trailing)
                                    .frame(
                                        maxWidth: geometry.size.width * (UIDevice.isLandscape ? 0.6 : 0.75),
                                        minHeight: 1,
                                        alignment: message.isSender ? .trailing: .leading
                                    )
                            }
                            chatMessageCellContainer(in: geometry.size, with: message, with: shouldShowDisplayName)
                                .id(message.id)
                                .onAppear {
                                    let total = self.messages.count
                                    let lastItem : Message!
                                    if total >= 5 {
                                        lastItem = self.messages[total - 5]
                                    }else{
                                        lastItem = self.messages.last
                                    }
                                    if message.id == lastItem.id {
                                        if let lastMessage = self.messages.last{
                                            self.reachedTop?(lastMessage.date)

                                        }
                                    }
                                }
                        }
                        if messages.count == 0 && isFetching {
                            VStack(alignment: .center) {
                                ProgressView()
                                    .padding()
                                Text("Fetching Messages")
                            }
                            .padding()
                            
                        }else if hasMore {
                            ProgressView()
                                .padding()
                        }
                        Spacer()
                            .frame(height: inset.bottom)
                            .id("bottom")
                    }
                    .padding(EdgeInsets(top: inset.top, leading: inset.leading, bottom: 0, trailing: inset.trailing))
                    .onChange(of: scrollToBottom) { value in
                        if value {
                            withAnimation {
                                proxy.scrollTo("bottom")
                            }
                            scrollToBottom = false
                        }
                    }
                    .onChange(of: scrollTo) { value in
                        if let value = value {
                            proxy.scrollTo(value, anchor: .bottom)
                            scrollTo = nil
                            print("scrollTo to specific valud")
                        }
                    }
                    .iOS {
                        // Auto Scroll with Keyboard Notification
                        $0.onReceive(
                            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                                .debounce(for: .milliseconds(400), scheduler: RunLoop.main),
                            perform: { _ in
                                if !isKeyboardActive {
                                    isKeyboardActive = true
                                    scrollToBottom = true
                                }
                            }
                        )
                        .onReceive(
                            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                            perform: { _ in isKeyboardActive = false }
                        )
                    }
                }
            }
            .background(Color.clear)
            .padding(.bottom, messageEditorHeight + 30)
        }

    }
    
}

internal extension ChatView {
    // MARK: - List Item
    private func chatMessageCellContainer(
        in size: CGSize,
        with message: Message,
        with avatarShow: Bool
    ) -> some View {
        ChatMessageCellContainer(
            message: message,
            size: size,
            onQuickReplyItemSelected: onQuickReplyItemSelected,
            contactFooterSection: contactCellFooterSection,
            onTextTappedCallback: onAttributedTextTappedCallback,
            onCarouselItemAction: onCarouselItemAction
        )
        .onTapGesture { onMessageCellTapped(message) }
        .onLongPressGesture(minimumDuration: 0.2) {
            onMessageCellLongPressed(message)
        }
        .modifier(
            AvatarModifier<Message, User>(
                message: message,
                showAvatarForMessage: shouldShowAvatarForMessage(
                    forThisMessage: avatarShow
                )
            )
        )
        .modifier(MessageHorizontalSpaceModifier(messageKind: message.messageKind, isSender: message.isSender))
        .modifier(CellEdgeInsetsModifier(isSender: message.isSender))
        .id(message.id)
    }
}

public extension ChatView {
    func shouldShowDateHeader(messages: [Message], thisMessage: Message) -> Bool {
        if let messageIndex = messages.firstIndex(where: { $0.id == thisMessage.id }) {
            if messageIndex == 0 { return true }
            let prevMessage = messages[messageIndex]
            let currMessage = messages[messageIndex - 1]
            let timeInterval = prevMessage.date - currMessage.date
            return timeInterval > dateHeaderTimeInterval
        }
        return false
    }
    
    func shouldShowDisplayName(
        messages: [Message],
        thisMessage: Message,
        dateHeaderShown: Bool
    ) -> Bool {
        if !shouldShowGroupChatHeaders {
            return false
        } else if dateHeaderShown {
            return true
        }
        
        if let messageIndex = messages.firstIndex(where: { $0.id == thisMessage.id }) {
            if messageIndex == 0 { return true }
            let prevMessageUserID = messages[messageIndex].user.id
            let currMessageUserID = messages[messageIndex - 1].user.id
            return !(prevMessageUserID == currMessageUserID)
        }
        
        return false
    }
    
    func shouldShowAvatarForMessage(forThisMessage: Bool) -> Bool {
        (forThisMessage || !shouldShowGroupChatHeaders)
    }
}

// MARK: - Initializers
public extension ChatView {
    /// ChatView constructor
    /// - Parameters:
    ///   - messages: Messages to display
    ///   - scrollToBottom: set to `true` to scrollToBottom
    ///   - dateHeaderTimeInterval: Amount of time between messages in
    ///                             seconds required before dateheader added
    ///                             (Default 1 hour)
    ///   - shouldShowGroupChatHeaders: Shows the display name of the sending
    ///                                 user only if it is the first message in a chain.
    ///                                 Also only shows avatar for first message in chain.
    ///                                 (disabled by default)
    ///   - inputView: inputView view to provide message
    ///   
    init(additionalHeight : Binding<CGFloat> = .constant(0.0),
        isFetching : Binding<Bool> = .constant(false),
        inverted : Bool = false,
        messages: Binding<[Message]>,
        scrollToBottom: Binding<Bool> = .constant(false),
        hasMore : Binding<Bool> = .constant(false),
        scrollTo: Binding<UUID?> = .constant(nil),
        dateHeaderTimeInterval: TimeInterval = 3600,
        shouldShowGroupChatHeaders: Bool = false,
        inputView: @escaping () -> AnyView,
        inset: EdgeInsets = .init(),
        reachedTop: ((_ lastDate : Date) -> Void)? = nil,
        tappedResendAction : @escaping (Message) -> Void
    ) {
        self._additionalHeight = additionalHeight
        _messages = messages
        self.inputView = inputView
        _scrollToBottom = scrollToBottom
        self.inset = inset
        self.dateFormater.dateStyle = .medium
        self.dateFormater.timeStyle = .short
        self.dateFormater.timeZone = NSTimeZone.local
        self.dateFormater.doesRelativeDateFormatting = true
        self.dateHeaderTimeInterval = dateHeaderTimeInterval
        self.shouldShowGroupChatHeaders = shouldShowGroupChatHeaders
        self.reachedTop = reachedTop
        self.tappedResendAction = tappedResendAction
        _scrollTo = scrollTo
        _hasMore = hasMore
        self.inverted = inverted
        _isFetching = isFetching
    }
}

public extension ChatView {
    /// Triggered when a ChatMessage is tapped.
    func onMessageCellTapped(_ action: @escaping (Message) -> Void) -> Self {
        then({ $0.onMessageCellTapped = action })
    }
    func onMessageCellLongpressed(_ action: @escaping (Message) -> Void) -> Self {
        then({ $0.onMessageCellLongPressed = action })
    }
    
    /// Present ContextMenu when a message cell is long pressed.
    func messageCellContextMenu(_ action: @escaping (Message) -> AnyView) -> Self {
        then({ $0.messageCellContextMenu = action })
    }
    
    /// Triggered when a quickReplyItem is selected (ChatMessageKind.quickReply)
    func onQuickReplyItemSelected(_ action: @escaping (QuickReplyItem) -> Void) -> Self {
        then({ $0.onQuickReplyItemSelected = action })
    }
    
    /// Present contactItem's footer buttons. (ChatMessageKind.contactItem)
    func contactItemButtons(_ section: @escaping (ContactItem, Message) -> [ContactCellButton]) -> Self {
        then({ $0.contactCellFooterSection = section })
    }
    
    /// To listen text tapped events like phone, url, date, address
    func onAttributedTextTappedCallback(action: @escaping () -> AttributedTextTappedCallback) -> Self {
        then({ $0.onAttributedTextTappedCallback = action })
    }
    
    /// Triggered when the carousel button tapped.
    func onCarouselItemAction(action: @escaping (CarouselItemButton, Message) -> Void) -> Self {
        then({ $0.onCarouselItemAction = action })
    }
}
