//
//  Extensions.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI
import SwiftyChat

// MARK: - Cross-platform Color Helpers
extension Color {
    static var adaptiveBackground: Color {
        #if os(iOS)
        Color(.systemBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    static var adaptiveSecondaryBackground: Color {
        #if os(iOS)
        Color(.secondarySystemBackground)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }
    
    static var adaptiveTertiaryBackground: Color {
        #if os(iOS)
        Color(.tertiarySystemBackground)
        #else
        Color(nsColor: .textBackgroundColor)
        #endif
    }
    
    static var adaptiveGray: Color {
        #if os(iOS)
        Color(.systemGray3)
        #else
        Color(nsColor: .systemGray)
        #endif
    }
}

// MARK: - App Colors
extension Color {
    static let chatBlue = Color(#colorLiteral(red: 0.1405690908, green: 0.1412397623, blue: 0.25395751, alpha: 1))
    static let chatGray = Color(#colorLiteral(red: 0.7861273885, green: 0.7897668481, blue: 0.7986581922, alpha: 1))
    static let chatGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let chatPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
}

// MARK: - Fonts
let futuraFont = Font.custom("Futura", size: 17)
let roundedFont = Font.system(size: 16, weight: .regular, design: .rounded)
let modernFont = Font.system(size: 16, weight: .medium)

// MARK: - Pre-built Styles
extension ChatMessageCellStyle {

    /// Basic style with minimal customization
    static let basicStyle = ChatMessageCellStyle(
        incomingTextStyle: .init(
            textStyle: .init(textColor: .primary, font: futuraFont),
            textPadding: 16,
            cellBackgroundColor: Color.secondary.opacity(0.15),
            cellBorderWidth: 0,
            cellShadowRadius: 0,
            cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
        ),
        outgoingTextStyle: .init(
            textStyle: .init(textColor: .white, font: futuraFont),
            textPadding: 16,
            cellBackgroundColor: Color.chatBlue,
            cellBorderWidth: 0,
            cellShadowRadius: 0,
            cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
        ),
        incomingAvatarStyle: .init(imageStyle: .init(imageSize: .zero))
    )
    
    /// Modern rounded style with shadows
    static let modernStyle = ChatMessageCellStyle(
        incomingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .primary,
                font: roundedFont
            ),
            textPadding: 14,
            cellBackgroundColor: Color.secondary.opacity(0.15),
            cellCornerRadius: 20,
            cellShadowRadius: 4,
            cellShadowColor: Color.black.opacity(0.1),
            cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
        ),
        outgoingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: roundedFont
            ),
            textPadding: 14,
            cellBackgroundColor: .blue,
            cellCornerRadius: 20,
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
        incomingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(
                imageSize: CGSize(width: 36, height: 36),
                cornerRadius: 18
            ),
            avatarPosition: .alignToMessageBottom(spacing: 8)
        ),
        outgoingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(imageSize: .zero)
        )
    )
    
    /// Dark theme style
    static let darkStyle = ChatMessageCellStyle(
        incomingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: modernFont
            ),
            textPadding: 12,
            cellBackgroundColor: Color(white: 0.2),
            cellCornerRadius: 16,
            cellBorderColor: Color.white.opacity(0.1),
            cellBorderWidth: 1,
            cellShadowRadius: 0,
            cellRoundedCorners: [.topRight, .bottomRight, .bottomLeft]
        ),
        outgoingTextStyle: TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .black,
                font: modernFont
            ),
            textPadding: 12,
            cellBackgroundColor: .green,
            cellCornerRadius: 16,
            cellShadowRadius: 4,
            cellShadowColor: Color.green.opacity(0.3),
            cellRoundedCorners: [.topLeft, .bottomRight, .bottomLeft]
        ),
        quickReplyCellStyle: QuickReplyCellStyle(
            selectedItemColor: .green,
            selectedItemBackgroundColor: Color.green.opacity(0.2),
            unselectedItemColor: .green,
            itemCornerRadius: 16
        ),
        incomingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(
                imageSize: CGSize(width: 32, height: 32),
                cornerRadius: 8,
                borderColor: .green,
                borderWidth: 1
            ),
            avatarPosition: .alignToMessageTop(spacing: 8)
        ),
        outgoingAvatarStyle: AvatarStyle(
            imageStyle: CommonImageStyle(imageSize: .zero)
        )
    )
}

// MARK: - View Extensions
extension View {
    func embedInAnyView() -> AnyView {
        AnyView(self)
    }
}
