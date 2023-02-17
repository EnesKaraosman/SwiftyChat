//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/17/23.
//

import SwiftUI

internal struct SystemMessageCell: View {
    public let text: String

    var body: some View {
        Text(text)
            .font(Font.system(size: 12))
            .italic()
            .padding()
        }
}

