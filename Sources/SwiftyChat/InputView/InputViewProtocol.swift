//
//  InputViewProtocol.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import Foundation

public protocol InputViewProtocol {
    var sendAction: (ChatMessageKind) -> Void { get }
}
