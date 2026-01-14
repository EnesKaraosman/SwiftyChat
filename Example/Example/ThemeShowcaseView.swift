//
//  ThemeShowcaseView.swift
//  Example
//
//  Created for SwiftyChat Demo
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock

struct ThemeShowcaseView: View {
    
    @State private var selectedTheme: ChatTheme = .modern
    @State private var messages: [MessageMocker.ChatMessageItem] = []
    @State private var scrollToBottom = false
    @State private var inputMessage = ""
    @State private var showThemePicker = false
    
    var body: some View {
        ZStack {
            selectedTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Theme selector header
                themeHeader
                
                // Chat View
                ChatView<MessageMocker.ChatMessageItem, MessageMocker.ChatUserItem>(
                    messages: $messages,
                    scrollToBottom: $scrollToBottom
                ) {
                    themedInputView
                        .embedInAnyView()
                }
                .onQuickReplyItemSelected { quickReply in
                    messages.append(
                        .init(
                            user: MessageMocker.sender,
                            messageKind: .text(quickReply.title),
                            isSender: true
                        )
                    )
                }
                .onCarouselItemAction { button, _ in
                    messages.append(
                        .init(
                            user: MessageMocker.sender,
                            messageKind: .text("Selected: \(button.title)"),
                            isSender: true
                        )
                    )
                }
                .contactItemButtons { contact, _ in
                    [
                        ContactCellButton(title: "Call", action: {
                            print("Calling \(contact.displayName)")
                        }),
                        ContactCellButton(title: "Message", action: {
                            print("Messaging \(contact.displayName)")
                        })
                    ]
                }
                .environmentObject(selectedTheme.style)
            }
        }
        .navigationTitle("Theme: \(selectedTheme.name)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showThemePicker = true
                } label: {
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(selectedTheme.accentColor)
                }
            }
        }
        .sheet(isPresented: $showThemePicker) {
            ThemePickerSheet(selectedTheme: $selectedTheme)
        }
        .task {
            loadSampleMessages()
        }
    }
    
    // MARK: - Theme Header
    private var themeHeader: some View {
        HStack {
            Image(systemName: selectedTheme.icon)
                .font(.title2)
                .foregroundColor(selectedTheme.accentColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(selectedTheme.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(selectedTheme.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Quick theme switcher
            Menu {
                ForEach(ChatTheme.allThemes) { theme in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTheme = theme
                        }
                    } label: {
                        Label(theme.name, systemImage: theme.icon)
                    }
                }
            } label: {
                Image(systemName: "chevron.down.circle.fill")
                    .font(.title2)
                    .foregroundColor(selectedTheme.accentColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Themed Input View
    private var themedInputView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Attachment button
                Button {
                    // Add attachment
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(selectedTheme.accentColor)
                }
                
                // Text field
                TextField("Message...", text: $inputMessage)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.send)
                    .onSubmit(sendMessage)
                
                // Send button
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(inputMessage.isEmpty ? .gray : selectedTheme.accentColor)
                }
                .disabled(inputMessage.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .padding(.bottom, 20)
        }
        .background(Color(.secondarySystemBackground))
    }
    
    // MARK: - Actions
    private func sendMessage() {
        guard !inputMessage.isEmpty else { return }
        
        messages.append(
            .init(
                user: MessageMocker.sender,
                messageKind: .text(inputMessage),
                isSender: true
            )
        )
        inputMessage = ""
        scrollToBottom = true
    }
    
    private func loadSampleMessages() {
        messages = [
            // Welcome message
            .init(
                user: MessageMocker.chatbot,
                messageKind: .text("Welcome to SwiftyChat! 👋\n\nThis demo showcases different themes and message types."),
                isSender: false
            ),
            // Text with emoji
            .init(
                user: MessageMocker.sender,
                messageKind: .text("This looks amazing! 🎨"),
                isSender: true
            ),
            // Quick replies
            .init(
                user: MessageMocker.chatbot,
                messageKind: .quickReply([
                    QuickReplyRow(title: "Tell me more", payload: "more"),
                    QuickReplyRow(title: "Show features", payload: "features"),
                    QuickReplyRow(title: "Change theme", payload: "theme")
                ]),
                isSender: false
            ),
            // Image
            .init(
                user: MessageMocker.chatbot,
                messageKind: .image(.remote(URL(string: "https://picsum.photos/id/42/400/300")!)),
                isSender: false
            ),
            // More text
            .init(
                user: MessageMocker.sender,
                messageKind: .text("The theming system is really flexible!"),
                isSender: true
            ),
            // Emoji only
            .init(
                user: MessageMocker.chatbot,
                messageKind: .text("🎉🎊🥳"),
                isSender: false
            ),
            // Carousel
            .init(
                user: MessageMocker.chatbot,
                messageKind: .carousel([
                    CarouselRow(
                        title: "Modern Theme",
                        imageURL: URL(string: "https://picsum.photos/id/1/300/200"),
                        subtitle: "Clean and minimal",
                        buttons: [CarouselItemButton(title: "Apply")]
                    ),
                    CarouselRow(
                        title: "Dark Neon",
                        imageURL: URL(string: "https://picsum.photos/id/96/300/200"),
                        subtitle: "Cyberpunk vibes",
                        buttons: [CarouselItemButton(title: "Apply")]
                    ),
                    CarouselRow(
                        title: "Nature",
                        imageURL: URL(string: "https://picsum.photos/id/15/300/200"),
                        subtitle: "Fresh and green",
                        buttons: [CarouselItemButton(title: "Apply")]
                    )
                ]),
                isSender: false
            ),
            // Contact
            .init(
                user: MessageMocker.chatbot,
                messageKind: .contact(ContactRow(displayName: "SwiftyChat Support")),
                isSender: false
            ),
            // Location
            .init(
                user: MessageMocker.sender,
                messageKind: .location(LocationRow(latitude: 41.0082, longitude: 28.9784)),
                isSender: true
            )
        ]
    }
}

// MARK: - Theme Picker Sheet
struct ThemePickerSheet: View {
    @Binding var selectedTheme: ChatTheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(ChatTheme.allThemes) { theme in
                ThemeRow(theme: theme, isSelected: theme.id == selectedTheme.id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            selectedTheme = theme
                        }
                        dismiss()
                    }
            }
            .navigationTitle("Choose Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ThemeRow: View {
    let theme: ChatTheme
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Theme icon
            ZStack {
                Circle()
                    .fill(theme.accentColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: theme.icon)
                    .font(.title2)
                    .foregroundColor(theme.accentColor)
            }
            
            // Theme info
            VStack(alignment: .leading, spacing: 4) {
                Text(theme.name)
                    .font(.headline)
                Text(theme.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Color preview
            HStack(spacing: 4) {
                Circle()
                    .fill(theme.backgroundColor)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                
                Circle()
                    .fill(theme.accentColor)
                    .frame(width: 20, height: 20)
            }
            
            // Selection indicator
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(theme.accentColor)
                    .font(.title2)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Helper Types (matching MessageMocker's internal types)
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
    var initials: String = "SC"
    var phoneNumbers: [String] = ["+1 (555) 123-4567"]
    var emails: [String] = ["support@swiftychat.dev"]
}

private struct LocationRow: LocationItem {
    var latitude: Double
    var longitude: Double
}

#Preview {
    NavigationView {
        ThemeShowcaseView()
    }
}
