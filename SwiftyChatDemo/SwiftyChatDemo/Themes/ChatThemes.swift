//
//  ChatThemes.swift
//  Example
//
//  Created for SwiftyChat Demo
//

import SwiftUI
import SwiftyChat

// MARK: - Cross-platform Color Helpers
private extension Color {
    static var systemBackground: Color {
        #if os(iOS)
        Color(.systemBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    static var secondarySystemBackground: Color {
        #if os(iOS)
        Color(.secondarySystemBackground)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }
    
    static var systemGray6: Color {
        #if os(iOS)
        Color(.systemGray6)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }
    
    static var systemGray5: Color {
        #if os(iOS)
        Color(.systemGray5)
        #else
        Color(nsColor: .separatorColor)
        #endif
    }
    
    static var systemBlueColor: Color {
        #if os(iOS)
        Color(.systemBlue)
        #else
        Color(nsColor: .systemBlue)
        #endif
    }
}

// MARK: - Theme Definition
struct ChatTheme: Identifiable {
    let id: String
    let name: String
    let description: String
    let style: ChatMessageCellStyle
    let backgroundColor: Color
    let inputBackgroundColor: Color
    let accentColor: Color
    let icon: String
}

// MARK: - Pre-built Themes
extension ChatTheme {
    
    // MARK: - Modern Minimal Theme
    static let modern = ChatTheme(
        id: "modern",
        name: "Modern",
        description: "Clean and minimal design with soft shadows",
        style: ChatMessageCellStyle(
            incomingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .primary,
                    font: .system(size: 16, weight: .regular, design: .rounded)
                ),
                textPadding: 14,
                cellBackgroundColor: Color.systemGray6,
                cellCornerRadius: 20,
                cellBorderColor: .clear,
                cellBorderWidth: 0,
                cellShadowRadius: 4,
                cellShadowColor: Color.black.opacity(0.1),
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
                cellShadowColor: Color.blue.opacity(0.3),
                cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
            ),
            quickReplyCellStyle: QuickReplyCellStyle(
                selectedItemColor: .blue,
                selectedItemBackgroundColor: Color.blue.opacity(0.15),
                unselectedItemColor: .blue,
                itemCornerRadius: 20
            ),
            carouselCellStyle: CarouselCellStyle(
                buttonTitleColor: .white,
                buttonBackgroundColor: .blue,
                cellCornerRadius: 16
            ),
            incomingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: CGSize(width: 36, height: 36)),
                avatarPosition: .alignToMessageBottom(spacing: 8)
            ),
            outgoingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: .zero)
            )
        ),
        backgroundColor: Color.systemBackground,
        inputBackgroundColor: Color.systemBackground,
        accentColor: .blue,
        icon: "bubble.left.and.bubble.right.fill"
    )
    
    // MARK: - Dark Neon Theme
    static let darkNeon = ChatTheme(
        id: "darkNeon",
        name: "Dark Neon",
        description: "Cyberpunk-inspired with glowing accents",
        style: ChatMessageCellStyle(
            incomingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .white,
                    font: .system(size: 15, weight: .medium, design: .monospaced)
                ),
                textPadding: 12,
                cellBackgroundColor: Color(red: 0.15, green: 0.15, blue: 0.2),
                cellCornerRadius: 12,
                cellBorderColor: Color.cyan.opacity(0.5),
                cellBorderWidth: 1,
                cellShadowRadius: 8,
                cellShadowColor: Color.cyan.opacity(0.3),
                cellRoundedCorners: .allCorners
            ),
            outgoingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .black,
                    font: .system(size: 15, weight: .medium, design: .monospaced)
                ),
                textPadding: 12,
                cellBackgroundColor: Color.cyan,
                cellCornerRadius: 12,
                cellBorderColor: .clear,
                cellBorderWidth: 0,
                cellShadowRadius: 12,
                cellShadowColor: Color.cyan.opacity(0.5),
                cellRoundedCorners: .allCorners
            ),
            quickReplyCellStyle: QuickReplyCellStyle(
                selectedItemColor: .cyan,
                selectedItemBackgroundColor: Color.cyan.opacity(0.2),
                unselectedItemColor: .cyan,
                itemBorderWidth: 1,
                itemCornerRadius: 8
            ),
            carouselCellStyle: CarouselCellStyle(
                titleLabelStyle: CommonTextStyle(textColor: .white, font: .headline, fontWeight: .bold),
                subtitleLabelStyle: CommonTextStyle(textColor: Color.cyan.opacity(0.8), font: .subheadline),
                buttonTitleColor: .black,
                buttonBackgroundColor: .cyan,
                cellBackgroundColor: Color(red: 0.1, green: 0.1, blue: 0.15),
                cellCornerRadius: 12,
                cellBorderColor: Color.cyan.opacity(0.3),
                cellBorderWidth: 1
            ),
            incomingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(
                    imageSize: CGSize(width: 32, height: 32),
                    cornerRadius: 8,
                    borderColor: .cyan,
                    borderWidth: 1,
                    shadowRadius: 4,
                    shadowColor: .cyan
                ),
                avatarPosition: .alignToMessageTop(spacing: 8)
            ),
            outgoingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: .zero)
            )
        ),
        backgroundColor: Color(red: 0.08, green: 0.08, blue: 0.12),
        inputBackgroundColor: Color(red: 0.12, green: 0.12, blue: 0.16),
        accentColor: .cyan,
        icon: "sparkles"
    )
    
    // MARK: - Warm Sunset Theme
    static let warmSunset = ChatTheme(
        id: "warmSunset",
        name: "Warm Sunset",
        description: "Cozy orange and coral tones",
        style: ChatMessageCellStyle(
            incomingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .primary,
                    font: .system(size: 16, weight: .regular, design: .serif)
                ),
                textPadding: 14,
                cellBackgroundColor: Color.secondarySystemBackground,
                cellCornerRadius: 16,
                cellBorderColor: Color.orange.opacity(0.3),
                cellBorderWidth: 1,
                cellShadowRadius: 3,
                cellShadowColor: Color.orange.opacity(0.15),
                cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
            ),
            outgoingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .white,
                    font: .system(size: 16, weight: .regular, design: .serif)
                ),
                textPadding: 14,
                cellBackgroundColor: LinearGradient(
                    colors: [Color.orange, Color(red: 1, green: 0.4, blue: 0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).asColor,
                cellCornerRadius: 16,
                cellBorderColor: .clear,
                cellBorderWidth: 0,
                cellShadowRadius: 5,
                cellShadowColor: Color.orange.opacity(0.3),
                cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
            ),
            quickReplyCellStyle: QuickReplyCellStyle(
                selectedItemColor: .white,
                selectedItemBackgroundColor: .orange,
                unselectedItemColor: .orange,
                itemCornerRadius: 16
            ),
            carouselCellStyle: CarouselCellStyle(
                titleLabelStyle: CommonTextStyle(textColor: .primary, font: .title3, fontWeight: .bold),
                subtitleLabelStyle: CommonTextStyle(textColor: .secondary, font: .subheadline),
                buttonTitleColor: .white,
                buttonBackgroundColor: .orange,
                cellBackgroundColor: Color.secondarySystemBackground,
                cellCornerRadius: 16
            ),
            incomingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(
                    imageSize: CGSize(width: 40, height: 40),
                    cornerRadius: 20,
                    borderColor: .orange,
                    borderWidth: 2
                ),
                avatarPosition: .alignToMessageCenter(spacing: 10)
            ),
            outgoingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: .zero)
            )
        ),
        backgroundColor: Color.systemBackground,
        inputBackgroundColor: Color.secondarySystemBackground,
        accentColor: .orange,
        icon: "sun.max.fill"
    )
    
    // MARK: - Nature Green Theme
    static let nature = ChatTheme(
        id: "nature",
        name: "Nature",
        description: "Fresh green tones inspired by forests",
        style: ChatMessageCellStyle(
            incomingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .primary,
                    font: .system(size: 16, weight: .regular)
                ),
                textPadding: 12,
                cellBackgroundColor: Color.secondarySystemBackground,
                cellCornerRadius: 18,
                cellBorderColor: Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.3),
                cellBorderWidth: 1,
                cellShadowRadius: 2,
                cellShadowColor: Color.green.opacity(0.1),
                cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
            ),
            outgoingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .white,
                    font: .system(size: 16, weight: .regular)
                ),
                textPadding: 12,
                cellBackgroundColor: Color(red: 0.2, green: 0.6, blue: 0.4),
                cellCornerRadius: 18,
                cellBorderColor: .clear,
                cellBorderWidth: 0,
                cellShadowRadius: 3,
                cellShadowColor: Color.green.opacity(0.2),
                cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
            ),
            quickReplyCellStyle: QuickReplyCellStyle(
                selectedItemColor: .white,
                selectedItemBackgroundColor: Color(red: 0.2, green: 0.6, blue: 0.4),
                unselectedItemColor: Color(red: 0.2, green: 0.6, blue: 0.4),
                itemCornerRadius: 18
            ),
            carouselCellStyle: CarouselCellStyle(
                titleLabelStyle: CommonTextStyle(textColor: .primary, font: .headline, fontWeight: .bold),
                subtitleLabelStyle: CommonTextStyle(textColor: .secondary, font: .subheadline),
                buttonTitleColor: .white,
                buttonBackgroundColor: Color(red: 0.2, green: 0.6, blue: 0.4),
                cellBackgroundColor: Color.secondarySystemBackground,
                cellCornerRadius: 14
            ),
            incomingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(
                    imageSize: CGSize(width: 38, height: 38),
                    cornerRadius: 19,
                    borderColor: Color(red: 0.2, green: 0.6, blue: 0.4),
                    borderWidth: 2
                ),
                avatarPosition: .alignToMessageBottom(spacing: 8)
            ),
            outgoingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: .zero)
            )
        ),
        backgroundColor: Color.systemBackground,
        inputBackgroundColor: Color.secondarySystemBackground,
        accentColor: Color(red: 0.2, green: 0.6, blue: 0.4),
        icon: "leaf.fill"
    )
    
    // MARK: - Classic iMessage Theme
    static let classic = ChatTheme(
        id: "classic",
        name: "Classic",
        description: "Traditional messaging app style",
        style: ChatMessageCellStyle(
            incomingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .primary,
                    font: .system(size: 17)
                ),
                textPadding: 12,
                cellBackgroundColor: Color.systemGray5,
                cellCornerRadius: 18,
                cellBorderColor: .clear,
                cellBorderWidth: 0,
                cellShadowRadius: 0,
                cellShadowColor: .clear,
                cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
            ),
            outgoingTextStyle: TextCellStyle(
                textStyle: CommonTextStyle(
                    textColor: .white,
                    font: .system(size: 17)
                ),
                textPadding: 12,
                cellBackgroundColor: Color.systemBlueColor,
                cellCornerRadius: 18,
                cellBorderColor: .clear,
                cellBorderWidth: 0,
                cellShadowRadius: 0,
                cellShadowColor: .clear,
                cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
            ),
            quickReplyCellStyle: QuickReplyCellStyle(
                selectedItemColor: .blue,
                selectedItemBackgroundColor: Color.blue.opacity(0.1),
                unselectedItemColor: .blue,
                itemCornerRadius: 16
            ),
            incomingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: .zero)
            ),
            outgoingAvatarStyle: AvatarStyle(
                imageStyle: CommonImageStyle(imageSize: .zero)
            )
        ),
        backgroundColor: Color.systemBackground,
        inputBackgroundColor: Color.systemBackground,
        accentColor: .blue,
        icon: "message.fill"
    )
    
    // MARK: - All Available Themes
    static let allThemes: [ChatTheme] = [
        .modern,
        .classic,
        .darkNeon,
        .warmSunset,
        .nature
    ]
}

// MARK: - Helper to convert gradient to color
private extension LinearGradient {
    var asColor: Color {
        // This is a workaround - in practice, the gradient start color
        Color.orange
    }
}
