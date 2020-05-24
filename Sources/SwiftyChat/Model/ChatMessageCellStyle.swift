//
//  MessageCellStyle.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public class ChatMessageCellStyle: ObservableObject {

    var incomingBorderColor: Color = Color(#colorLiteral(red: 0.4539314508, green: 0.6435066462, blue: 0.3390129805, alpha: 1))
    var outgoingBorderColor: Color = Color(#colorLiteral(red: 0.2179558277, green: 0.202344358, blue: 0.2716280818, alpha: 1))
    
    var incomingTextColor: Color = .white
    var outgoingTextColor: Color = .white
    
    var incomingBackgroundColor: Color? = Color(#colorLiteral(red: 0.4539314508, green: 0.6435066462, blue: 0.3390129805, alpha: 1))
    var outgoingBackgroundColor: Color? = Color(#colorLiteral(red: 0.2179558277, green: 0.202344358, blue: 0.2716280818, alpha: 1))
    
    var incomingCornerRadius: CGFloat = 8
    var outgoingCornerRadius: CGFloat = 8
    
    var incomingBorderWidth: CGFloat = 2
    var outgoingBorderWidth: CGFloat = 2
    
    var incomingShadowColor: Color = .secondary
    var outgoingShadowColor: Color = .secondary
    
    var incomingShadowRadius: CGFloat = 3
    var outgoingShadowRadius: CGFloat = 3
    
    var incomingTextPadding: CGFloat = 8
    var outgoingTextPadding: CGFloat = 8
    
    var quickReplyUnselectedItemColor: Color = .secondary
    var quickReplySelectedItemColor: Color = Color(#colorLiteral(red: 0.4539314508, green: 0.6435066462, blue: 0.3390129805, alpha: 1))
    
}
