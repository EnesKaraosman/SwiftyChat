//
//  InteractiveChatView.swift
//  Example
//
//  Created for SwiftyChat Demo
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock

struct InteractiveChatView: View {
    
    @State private var messages: [MessageMocker.ChatMessageItem] = []
    @State private var scrollToBottom = false
    @State private var inputMessage = ""
    @State private var isTyping = false
    @State private var conversationState: ConversationState = .greeting
    
    enum ConversationState {
        case greeting
        case askingName
        case askingFavoriteFood
        case showingCarousel
        case askingLocation
        case farewell
        case freeChat
    }
    
    var body: some View {
        ChatView<MessageMocker.ChatMessageItem, MessageMocker.ChatUserItem>(
            messages: $messages,
            scrollToBottom: $scrollToBottom
        ) {
            inputView
                .embedInAnyView()
        }
        .onQuickReplyItemSelected { quickReply in
            handleQuickReply(quickReply)
        }
        .onCarouselItemAction { button, _ in
            handleCarouselAction(button)
        }
        .contactItemButtons { _, _ in
            [
                ContactCellButton(title: "👋 Say Hi", action: {
                    sendUserMessage("Hi there!")
                })
            ]
        }
        .environmentObject(ChatMessageCellStyle.interactiveStyle)
        .navigationTitle("Chat Demo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Restart") {
                    restartConversation()
                }
            }
        }
        .task {
            startConversation()
        }
    }
    
    // MARK: - Input View
    private var inputView: some View {
        VStack(spacing: 0) {
            // Typing indicator
            if isTyping {
                HStack {
                    Text("SwiftyBot is typing...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color(.secondarySystemBackground))
            }
            
            Divider()
            
            HStack(spacing: 12) {
                TextField("Type a message...", text: $inputMessage)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.send)
                    .onSubmit(sendCurrentMessage)
                
                Button(action: sendCurrentMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(inputMessage.isEmpty ? Color(.systemGray3) : .blue)
                }
                .disabled(inputMessage.isEmpty)
            }
            .padding()
            .padding(.bottom, 20)
        }
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Conversation Logic
    private func startConversation() {
        conversationState = .greeting
        
        // Initial greeting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showTypingThenSend("Hey there! 👋 Welcome to the SwiftyChat demo!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showTypingThenSend("I'm SwiftyBot, and I'll show you what this library can do.")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    conversationState = .askingName
                    addBotMessage(.quickReply([
                        QuickReplyRow(title: "Show me features!", payload: "features"),
                        QuickReplyRow(title: "Tell me more", payload: "more"),
                        QuickReplyRow(title: "Free chat mode", payload: "free")
                    ]))
                }
            }
        }
    }
    
    private func handleQuickReply(_ reply: QuickReplyItem) {
        sendUserMessage(reply.title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switch reply.payload {
            case "features":
                showFeatureDemo()
            case "more":
                showMoreInfo()
            case "free":
                enterFreeChatMode()
            case "food_pizza":
                showTypingThenSend("🍕 Great choice! I love pizza too!")
                showLocationDemo()
            case "food_sushi":
                showTypingThenSend("🍣 Excellent taste! Sushi is amazing!")
                showLocationDemo()
            case "food_tacos":
                showTypingThenSend("🌮 Tacos are the best! Great pick!")
                showLocationDemo()
            case "food_burger":
                showTypingThenSend("🍔 Classic! Can't go wrong with a burger!")
                showLocationDemo()
            case "share_location":
                showLocationOnMap()
            case "skip_location":
                showFarewell()
            case "restart":
                restartConversation()
            case "continue":
                enterFreeChatMode()
            default:
                showTypingThenSend("Interesting choice! 🤔")
            }
        }
    }
    
    private func handleCarouselAction(_ button: CarouselItemButton) {
        sendUserMessage("Selected: \(button.title)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showTypingThenSend("Great! You're interested in \(button.title). Here's what you can do with it! ✨")
            showFoodQuestion()
        }
    }
    
    private func showFeatureDemo() {
        conversationState = .showingCarousel
        
        showTypingThenSend("Let me show you the different message types! 🎨")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            addBotMessage(.carousel([
                CarouselRow(
                    title: "Text Messages",
                    imageURL: URL(string: "https://picsum.photos/id/1/300/200"),
                    subtitle: "Rich text with markdown, links & emojis",
                    buttons: [CarouselItemButton(title: "Try It")]
                ),
                CarouselRow(
                    title: "Media",
                    imageURL: URL(string: "https://picsum.photos/id/42/300/200"),
                    subtitle: "Images, videos with PiP support",
                    buttons: [CarouselItemButton(title: "Explore")]
                ),
                CarouselRow(
                    title: "Interactive",
                    imageURL: URL(string: "https://picsum.photos/id/96/300/200"),
                    subtitle: "Quick replies, carousels, contacts",
                    buttons: [CarouselItemButton(title: "See More")]
                )
            ]))
        }
    }
    
    private func showMoreInfo() {
        showTypingThenSend("SwiftyChat is a powerful, customizable chat UI framework for SwiftUI! 💪")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showTypingThenSend("It supports:\n• Multiple message types\n• Custom theming\n• Avatar customization\n• Markdown in text\n• And much more!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                addBotMessage(.quickReply([
                    QuickReplyRow(title: "Show features", payload: "features"),
                    QuickReplyRow(title: "Free chat", payload: "free")
                ]))
            }
        }
    }
    
    private func showFoodQuestion() {
        conversationState = .askingFavoriteFood
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showTypingThenSend("Now, let me ask you something fun! 😋")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showTypingThenSend("What's your favorite food?")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    addBotMessage(.quickReply([
                        QuickReplyRow(title: "🍕 Pizza", payload: "food_pizza"),
                        QuickReplyRow(title: "🍣 Sushi", payload: "food_sushi"),
                        QuickReplyRow(title: "🌮 Tacos", payload: "food_tacos"),
                        QuickReplyRow(title: "🍔 Burger", payload: "food_burger")
                    ]))
                }
            }
        }
    }
    
    private func showLocationDemo() {
        conversationState = .askingLocation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showTypingThenSend("SwiftyChat can also show locations on a map! 🗺️")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                addBotMessage(.quickReply([
                    QuickReplyRow(title: "📍 Show me!", payload: "share_location"),
                    QuickReplyRow(title: "Skip", payload: "skip_location")
                ]))
            }
        }
    }
    
    private func showLocationOnMap() {
        showTypingThenSend("Here's a sample location - Istanbul, Turkey! 🇹🇷")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            addBotMessage(.location(LocationRow(latitude: 41.0082, longitude: 28.9784)))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showFarewell()
            }
        }
    }
    
    private func showFarewell() {
        conversationState = .farewell
        
        showTypingThenSend("That's a wrap on the demo! 🎉")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showTypingThenSend("Feel free to explore the code and customize everything to your needs!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                addBotMessage(.contact(ContactRow(displayName: "SwiftyChat on GitHub")))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    addBotMessage(.quickReply([
                        QuickReplyRow(title: "🔄 Restart", payload: "restart"),
                        QuickReplyRow(title: "💬 Free chat", payload: "continue")
                    ]))
                }
            }
        }
    }
    
    private func enterFreeChatMode() {
        conversationState = .freeChat
        showTypingThenSend("You're now in free chat mode! Type anything and I'll respond. 💬")
    }
    
    private func restartConversation() {
        messages.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            startConversation()
        }
    }
    
    // MARK: - Message Helpers
    private func sendCurrentMessage() {
        guard !inputMessage.isEmpty else { return }
        sendUserMessage(inputMessage)
        let message = inputMessage
        inputMessage = ""
        
        // Auto-respond in free chat mode
        if conversationState == .freeChat {
            respondToFreeChat(message)
        }
    }
    
    private func sendUserMessage(_ text: String) {
        messages.append(.init(
            user: MessageMocker.sender,
            messageKind: .text(text),
            isSender: true
        ))
        scrollToBottom = true
    }
    
    private func addBotMessage(_ kind: ChatMessageKind) {
        messages.append(.init(
            user: MessageMocker.chatbot,
            messageKind: kind,
            isSender: false
        ))
        scrollToBottom = true
    }
    
    private func showTypingThenSend(_ text: String, delay: Double = 1.0) {
        isTyping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            isTyping = false
            addBotMessage(.text(text))
        }
    }
    
    private func respondToFreeChat(_ message: String) {
        let lowercased = message.lowercased()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isTyping = true
            
            let response: String
            
            if lowercased.contains("hello") || lowercased.contains("hi") || lowercased.contains("hey") {
                response = ["Hello! 👋", "Hey there!", "Hi! How can I help?"].randomElement()!
            } else if lowercased.contains("how are you") {
                response = "I'm doing great, thanks for asking! 😊 How about you?"
            } else if lowercased.contains("thank") {
                response = "You're welcome! 🙏"
            } else if lowercased.contains("bye") || lowercased.contains("goodbye") {
                response = "Goodbye! Have a great day! 👋✨"
            } else if lowercased.contains("emoji") {
                response = "Here are some emojis for you! 🎉🎊🥳🌟⭐️💫"
            } else if lowercased.contains("help") {
                response = "I'm here to help! You can:\n• Type any message\n• Tap 'Restart' to replay the demo\n• Explore the code to learn more!"
            } else if lowercased.contains("swiftui") || lowercased.contains("swift") {
                response = "SwiftUI is amazing! 💙 And SwiftyChat makes building chat UIs super easy!"
            } else {
                let responses = [
                    "That's interesting! Tell me more. 🤔",
                    "I see! What else is on your mind?",
                    "Thanks for sharing! 😊",
                    "Got it! Anything else you'd like to explore?",
                    "Cool! Feel free to keep chatting! 💬"
                ]
                response = responses.randomElement()!
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isTyping = false
                addBotMessage(.text(response))
            }
        }
    }
}

// MARK: - Helper Types
private struct QuickReplyRow: QuickReplyItem {
    var title: String
    var payload: String
}

private struct CarouselRow: CarouselItem {
    var title: String
    var imageURL: URL?
    var subtitle: String
    var buttons: [CarouselItemButton]
}

private struct ContactRow: ContactItem {
    var displayName: String
    var image: PlatformImage? = nil
    var initials: String = "GH"
    var phoneNumbers: [String] = []
    var emails: [String] = ["github.com/EnesKaraosman/SwiftyChat"]
}

private struct LocationRow: LocationItem {
    var latitude: Double
    var longitude: Double
}

// MARK: - Interactive Style
extension ChatMessageCellStyle {
    static let interactiveStyle = ChatMessageCellStyle(
        incomingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .primary,
                font: .system(size: 16, weight: .regular, design: .rounded)
            ),
            textPadding: 14,
            cellBackgroundColor: Color(.secondarySystemBackground),
            cellCornerRadius: 20,
            cellBorderColor: .clear,
            cellBorderWidth: 0,
            cellShadowRadius: 3,
            cellShadowColor: Color.black.opacity(0.08),
            cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
        ),
        outgoingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: .system(size: 16, weight: .regular, design: .rounded)
            ),
            textPadding: 14,
            cellBackgroundColor: Color.blue,
            cellCornerRadius: 20,
            cellBorderColor: .clear,
            cellBorderWidth: 0,
            cellShadowRadius: 4,
            cellShadowColor: Color.blue.opacity(0.25),
            cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
        ),
        quickReplyCellStyle: QuickReplyCellStyle(
            selectedItemColor: .white,
            selectedItemBackgroundColor: .blue,
            unselectedItemColor: .blue,
            unselectedItemBackgroundColor: Color.blue.opacity(0.1),
            itemBorderWidth: 1.5,
            itemCornerRadius: 18
        ),
        carouselCellStyle: CarouselCellStyle(
            titleLabelStyle: CommonTextStyle(textColor: .primary, font: .headline, fontWeight: .semibold),
            subtitleLabelStyle: CommonTextStyle(textColor: .secondary, font: .subheadline),
            buttonTitleColor: .white,
            buttonBackgroundColor: .blue,
            cellBackgroundColor: Color(.secondarySystemBackground),
            cellCornerRadius: 16,
            cellBorderColor: Color(.separator),
            cellBorderWidth: 1
        ),
        incomingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(
                imageSize: CGSize(width: 36, height: 36),
                cornerRadius: 18,
                borderColor: Color.blue.opacity(0.3),
                borderWidth: 2
            ),
            avatarPosition: .alignToMessageBottom(spacing: 8)
        ),
        outgoingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(imageSize: .zero)
        )
    )
}

#Preview {
    NavigationView {
        InteractiveChatView()
    }
}
