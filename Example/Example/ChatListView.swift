//
//  ChatListView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Basic Example", destination: BasicExampleView())
                NavigationLink("Advanced Example", destination: AdvancedExampleView())
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
