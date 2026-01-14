//
//  MessageTypesGalleryView.swift
//  Example
//
//  Created for SwiftyChat Demo
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock

struct MessageTypesGalleryView: View {
    
    @State private var messages: [MessageMocker.ChatMessageItem] = []
    @State private var scrollToBottom = false
    @State private var inputMessage = ""
    @State private var selectedMessageType: MessageType = .text
    
    enum MessageType: String, CaseIterable, Identifiable {
        case text = "Text"
        case emoji = "Emoji"
        case image = "Image"
        case imageText = "Image + Text"
        case location = "Location"
        case contact = "Contact"
        case quickReply = "Quick Reply"
        case carousel = "Carousel"
        case video = "Video"
        case loading = "Loading"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .text: return "text.bubble"
            case .emoji: return "face.smiling"
            case .image: return "photo"
            case .imageText: return "text.below.photo"
            case .location: return "location"
            case .contact: return "person.crop.circle"
            case .quickReply: return "ellipsis.bubble"
            case .carousel: return "rectangle.split.3x1"
            case .video: return "play.rectangle"
            case .loading: return "ellipsis"
            }
        }
        
        var description: String {
            switch self {
            case .text: return "Standard text messages with markdown support"
            case .emoji: return "Emoji-only messages with auto-scaling"
            case .image: return "Local or remote image messages"
            case .imageText: return "Image with text caption"
            case .location: return "Interactive map location pins"
            case .contact: return "Contact cards with action buttons"
            case .quickReply: return "Tappable quick reply options"
            case .carousel: return "Horizontal scrolling cards"
            case .video: return "Video messages with PiP support"
            case .loading: return "Animated loading indicator"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Message type selector
            messageTypeSelector
            
            // Chat view
            ChatView<MessageMocker.ChatMessageItem, MessageMocker.ChatUserItem>(
                messages: $messages,
                scrollToBottom: $scrollToBottom
            ) {
                inputView
                    .embedInAnyView()
            }
            .onQuickReplyItemSelected { quickReply in
                addResponse("You selected: \(quickReply.title)")
            }
            .onCarouselItemAction { button, _ in
                addResponse("Carousel action: \(button.title)")
            }
            .contactItemButtons { contact, _ in
                [
                    ContactCellButton(title: "📞 Call", action: {
                        addResponse("Calling \(contact.displayName)...")
                    }),
                    ContactCellButton(title: "💬 Text", action: {
                        addResponse("Opening chat with \(contact.displayName)...")
                    })
                ]
            }
            .environmentObject(ChatMessageCellStyle.galleryStyle)
        }
        .navigationTitle("Message Types")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear") {
                    messages.removeAll()
                }
            }
        }
    }
    
    // MARK: - Message Type Selector
    private var messageTypeSelector: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MessageType.allCases) { type in
                        MessageTypeButton(
                            type: type,
                            isSelected: selectedMessageType == type
                        ) {
                            selectedMessageType = type
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Description
            HStack {
                Image(systemName: selectedMessageType.icon)
                    .foregroundColor(.blue)
                Text(selectedMessageType.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Divider()
        }
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Input View
    private var inputView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Add sample message button
                Button {
                    addSampleMessage(type: selectedMessageType)
                } label: {
                    HStack {
                        Image(systemName: selectedMessageType.icon)
                        Text("Add \(selectedMessageType.rawValue)")
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // Toggle sender
                Button {
                    addSampleMessage(type: selectedMessageType, asSender: true)
                } label: {
                    Text("As Me")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding()
            .padding(.bottom, 20)
        }
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Add Sample Messages
    private func addSampleMessage(type: MessageType, asSender: Bool = false) {
        let user = asSender ? MessageMocker.sender : MessageMocker.chatbot
        
        let messageKind: ChatMessageKind
        
        switch type {
        case .text:
            let texts = [
                "Hello! This is a sample text message.",
                "SwiftyChat supports **bold**, *italic*, and `code` formatting!",
                "Check out https://github.com/EnesKaraosman/SwiftyChat for more info.",
                "Phone: +1 (555) 123-4567 • Email: hello@example.com"
            ]
            messageKind = .text(texts.randomElement()!)
            
        case .emoji:
            let emojis = ["👋", "🎉🎊", "❤️🧡💛💚", "👍", "😊😄😁"]
            messageKind = .text(emojis.randomElement()!)
            
        case .image:
            let id = Int.random(in: 1...100)
            let url = URL(string: "https://picsum.photos/id/\(id)/400/300")!
            messageKind = .image(.remote(url))
            
        case .imageText:
            let id = Int.random(in: 1...100)
            let url = URL(string: "https://picsum.photos/id/\(id)/400/300")!
            let captions = [
                "Beautiful view from today's hike! 🏔️",
                "Check out this amazing photo!",
                "Sharing this moment with you ✨"
            ]
            messageKind = .imageText(.remote(url), captions.randomElement()!)
            
        case .location:
            let locations: [(Double, Double, String)] = [
                (40.7128, -74.0060, "New York"),
                (51.5074, -0.1278, "London"),
                (35.6762, 139.6503, "Tokyo"),
                (48.8566, 2.3522, "Paris"),
                (41.0082, 28.9784, "Istanbul")
            ]
            let loc = locations.randomElement()!
            messageKind = .location(LocationRow(latitude: loc.0, longitude: loc.1))
            
        case .contact:
            let contacts = [
                ("John Appleseed", "JA"),
                ("Jane Smith", "JS"),
                ("SwiftyChat Support", "SC"),
                ("Alex Developer", "AD")
            ]
            let contact = contacts.randomElement()!
            messageKind = .contact(ContactRow(displayName: contact.0, initials: contact.1))
            
        case .quickReply:
            let options: [[QuickReplyRow]] = [
                [
                    QuickReplyRow(title: "Yes", payload: "yes"),
                    QuickReplyRow(title: "No", payload: "no"),
                    QuickReplyRow(title: "Maybe", payload: "maybe")
                ],
                [
                    QuickReplyRow(title: "🍕 Pizza", payload: "pizza"),
                    QuickReplyRow(title: "🍔 Burger", payload: "burger"),
                    QuickReplyRow(title: "🌮 Taco", payload: "taco"),
                    QuickReplyRow(title: "🍣 Sushi", payload: "sushi")
                ],
                [
                    QuickReplyRow(title: "Morning", payload: "morning"),
                    QuickReplyRow(title: "Afternoon", payload: "afternoon"),
                    QuickReplyRow(title: "Evening", payload: "evening")
                ]
            ]
            messageKind = .quickReply(options.randomElement()!)
            
        case .carousel:
            messageKind = .carousel([
                CarouselRow(
                    title: "SwiftyChat",
                    imageURL: URL(string: "https://picsum.photos/id/1/300/200"),
                    subtitle: "A SwiftUI Chat UI framework",
                    buttons: [
                        CarouselItemButton(title: "Learn More"),
                        CarouselItemButton(title: "GitHub")
                    ]
                ),
                CarouselRow(
                    title: "Easy Theming",
                    imageURL: URL(string: "https://picsum.photos/id/20/300/200"),
                    subtitle: "Customize every aspect",
                    buttons: [CarouselItemButton(title: "Try It")]
                ),
                CarouselRow(
                    title: "Rich Messages",
                    imageURL: URL(string: "https://picsum.photos/id/48/300/200"),
                    subtitle: "Images, videos, locations & more",
                    buttons: [CarouselItemButton(title: "Explore")]
                )
            ])
            
        case .video:
            messageKind = .video(VideoRow(
                url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                placeholderImage: .remote(URL(string: "https://picsum.photos/id/67/400/300")!),
                pictureInPicturePlayingMessage: "Video is playing in PiP mode"
            ))
            
        case .loading:
            messageKind = .loading
        }
        
        messages.append(.init(
            user: user,
            messageKind: messageKind,
            isSender: asSender
        ))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            scrollToBottom = true
        }
    }
    
    private func addResponse(_ text: String) {
        messages.append(.init(
            user: MessageMocker.sender,
            messageKind: .text(text),
            isSender: true
        ))
        scrollToBottom = true
    }
}

// MARK: - Message Type Button
struct MessageTypeButton: View {
    let type: MessageTypesGalleryView.MessageType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                Text(type.rawValue)
                    .font(.caption2)
            }
            .frame(width: 70, height: 50)
            .foregroundColor(isSelected ? .white : .primary)
            .background(isSelected ? Color.blue : Color(.tertiarySystemBackground))
            .cornerRadius(10)
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
    var initials: String = ""
    var phoneNumbers: [String] = ["+1 (555) 123-4567"]
    var emails: [String] = ["contact@example.com"]
}

private struct LocationRow: LocationItem {
    var latitude: Double
    var longitude: Double
}

private struct VideoRow: VideoItem {
    var url: URL
    var placeholderImage: ImageLoadingKind
    var pictureInPicturePlayingMessage: String
}

// MARK: - Gallery Style
extension ChatMessageCellStyle {
    static let galleryStyle = ChatMessageCellStyle(
        incomingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(textColor: .primary, font: .body),
            textPadding: 12,
            cellBackgroundColor: Color(.secondarySystemBackground),
            cellCornerRadius: 16,
            cellShadowRadius: 2,
            cellShadowColor: Color.black.opacity(0.1),
            cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
        ),
        outgoingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(textColor: .white, font: .body),
            textPadding: 12,
            cellBackgroundColor: .blue,
            cellCornerRadius: 16,
            cellShadowRadius: 2,
            cellShadowColor: Color.blue.opacity(0.3),
            cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
        ),
        quickReplyCellStyle: QuickReplyCellStyle(
            selectedItemColor: .blue,
            selectedItemBackgroundColor: Color.blue.opacity(0.15),
            unselectedItemColor: .blue,
            itemCornerRadius: 16
        ),
        carouselCellStyle: CarouselCellStyle(
            titleLabelStyle: CommonTextStyle(textColor: .primary, font: .headline, fontWeight: .bold),
            subtitleLabelStyle: CommonTextStyle(textColor: .secondary, font: .subheadline),
            buttonTitleColor: .white,
            buttonBackgroundColor: .blue,
            cellBackgroundColor: Color(.secondarySystemBackground),
            cellCornerRadius: 12
        ),
        incomingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(
                imageSize: CGSize(width: 32, height: 32),
                cornerRadius: 16
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
        MessageTypesGalleryView()
    }
}
