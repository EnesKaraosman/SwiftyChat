//
//  ContactCellStyle.swift
//  
//
//  Created by Enes Karaosman on 7.08.2020.
//

import SwiftUI

public struct ContactCellStyle {
    
    public let cellWidth: (CGSize) -> CGFloat
    public let imageStyle: CommonImageStyle
    public let fullNameLabelStyle: CommonLabelStyle
    
    public init(
        cellWidth: @escaping (CGSize) -> CGFloat = { $0.width * (UIDevice.isLandscape ? 0.45 : 0.75) },
        imageStyle: CommonImageStyle = CommonImageStyle(
            imageSize: CGSize(width: 50, height: 50),
            cornerRadius: 25,
            borderColor: Color.blue.opacity(0.2)
        ),
        fullNameLabelStyle: CommonLabelStyle = CommonLabelStyle(
            font: .body,
            textColor: .primary,
            fontWeight: .semibold
        )
    ) {
        self.cellWidth = cellWidth
        self.imageStyle = imageStyle
        self.fullNameLabelStyle = fullNameLabelStyle
    }
    
    
}
