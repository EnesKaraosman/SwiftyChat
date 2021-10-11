//
//  RoundedCornerShape.swift
//  
//
//  Created by Karl Söderberg on 2021-10-11.
//

import SwiftUI

struct RoundedCornerShape: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
