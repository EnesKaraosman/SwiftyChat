//
//  InputView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct InputView: View, InputViewProtocol {
    
    public let proxy: GeometryProxy
    public var sendAction: (ChatMessageKind) -> Void
    
    private let mainContainerHeight: CGFloat = 56
    
    @State private var textfield: String = ""
    @State private var isKeyboardActive: Bool = false
    
    @State private var presentCameraSheet: Bool = false
    @State private var moreActionSheet: Bool = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    public var body: some View {
        VStack {
            HStack(spacing: 8) {
                
                Button(action: {
                    print("plus tapped")
                    self.moreActionSheet = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(height: 20)
                    
                }.padding(.leading, 8)
                
                HStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 8)
                    TextField("Type..", text: $textfield)
                        .foregroundColor(.white)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 8)
                }
                .background(Color(#colorLiteral(red: 0.2663825154, green: 0.2648050189, blue: 0.2675990462, alpha: 1)))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), lineWidth: 1)
                )
                .frame(height: mainContainerHeight * 0.7)
                
                Button(action: {
                    print("camera tapped")
                    self.presentCameraSheet = true
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                }.padding(.trailing, 8)
                
                if isKeyboardActive {
                    Button(action: {
                        print("send tapped")
                        self.sendAction(.text(self.textfield))
                        self.textfield.removeAll()
                    }) {
                        
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .frame(height: 20)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                        
                    }
                    .animation(.default)
                    .padding(.leading, 0)
                    .padding(.trailing, 8)
                }
                
            }
            .frame(height: mainContainerHeight)
            
        }
        .frame(height: proxy.safeAreaInsets.bottom + mainContainerHeight)
        .background(
            Color(#colorLiteral(red: 0.2179558277, green: 0.202344358, blue: 0.2716280818, alpha: 1)).sheet(isPresented: $presentCameraSheet) {
                ImagePicker(sourceType: self.sourceType) { (image) in
                    self.sendAction(.image(.local(image)))
                }
            }
        )
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { (_) in
            withAnimation {
                self.isKeyboardActive = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { (_) in
            withAnimation(.easeOut(duration: 0.1)) {
                self.isKeyboardActive = false
            }
        }
        .actionSheet(isPresented: $moreActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("More"), message: nil, buttons: [
                .default(Text("Gallery"), action: {
                    self.sourceType = .photoLibrary
                    self.presentCameraSheet = true
                }),
                .cancel()
            ])
        }
        
    }
    
}
