//
//  LinkPreviewCellStyle.swift
//
//  Created on 2026-04-06.
//

import SwiftUI

public struct LinkPreviewCellStyle: CommonViewStyle {

    public let titleStyle: CommonTextStyle
    public let descriptionStyle: CommonTextStyle
    public let hostStyle: CommonTextStyle
    public let imageHeight: CGFloat
    public let textPadding: CGFloat
    public let cellWidth: (CGSize) -> CGFloat

    // MARK: - CommonViewStyle
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    public let cellRoundedCorners: RectCorner

    public init(
        titleStyle: CommonTextStyle = CommonTextStyle(
            textColor: .primary,
            font: .body,
            fontWeight: .semibold
        ),
        descriptionStyle: CommonTextStyle = CommonTextStyle(
            textColor: .secondary,
            font: .subheadline,
            fontWeight: .regular
        ),
        hostStyle: CommonTextStyle = CommonTextStyle(
            textColor: .secondary,
            font: .caption,
            fontWeight: .regular
        ),
        imageHeight: CGFloat = 160,
        textPadding: CGFloat = 10,
        cellWidth: @escaping (CGSize) -> CGFloat = { size in
            if !Device.isLandscape {
                return size.width * 0.75
            }
            return size.height * 0.8
        },
        cellBackgroundColor: Color = Color.secondary.opacity(0.1),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 3,
        cellShadowColor: Color = .secondary,
        cellRoundedCorners: RectCorner = .allCorners
    ) {
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.hostStyle = hostStyle
        self.imageHeight = imageHeight
        self.textPadding = textPadding
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
        self.cellRoundedCorners = cellRoundedCorners
    }
}
