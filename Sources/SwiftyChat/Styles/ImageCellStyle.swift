//
//  ImageCellStyle.swift
//  
//
//  Created by Enes Karaosman on 29.07.2020.
//

import SwiftUI

public struct ImageCellStyle: CellContainerStyle {
    
    public var cellWidth: (GeometryProxy) -> CGFloat
    
    // MARK: - CellContainerStyles
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    
    /// UIKit Constructor
    public init(
        cellWidth: @escaping (GeometryProxy) -> CGFloat = { $0.size.width * (UIDevice.isLandscape ? 0.4 : 0.8) },
        cellBackgroundColor: UIColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: UIColor = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 2,
        cellShadowColor: UIColor = .secondaryLabel
    ) {
        self.cellWidth = cellWidth
        self.cellBackgroundColor = Color(cellBackgroundColor)
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = Color(cellBorderColor)
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = Color(cellShadowColor)
    }
    
    /// SwiftUI Constructor
    public init(
        cellWidth: @escaping (GeometryProxy) -> CGFloat = { $0.size.width * (UIDevice.isLandscape ? 0.4 : 0.8) },
        cellBackgroundColor: Color = Color(#colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 0,
        cellShadowColor: Color = .clear
    ) {
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }
    
}
