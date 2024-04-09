//
//  CustomControlsView.swift
//  custom-avplayer-swiftui
//
//  Created by Marco Falanga on 19/11/21.
//

import SwiftUI

struct CustomControlsView: View {
    @ObservedObject var playerVM: PlayerViewModel

    init(for playerViewModel: PlayerViewModel) {
        self.playerVM = playerViewModel
    }

    var body: some View {
        HStack {
            if playerVM.isPlaying == false {
                Button(action: {
                    playerVM.player.play()
                }, label: {
                    Image(systemName: "play.circle")
                })
            } else {
                Button(action: {
                    playerVM.player.pause()
                }, label: {
                    Image(systemName: "pause.circle")
                })
            }
            
            if let duration = playerVM.duration {
                Slider(
                    value: $playerVM.currentTime,
                    in: 0...duration,
                    onEditingChanged: { isEditing in
                        playerVM.isEditingCurrentTime = isEditing
                    }
                )
            } else {
                Spacer()
            }

            Button(action: {
                withAnimation {
                    playerVM.isInPipMode.toggle()
                }
            }, label: {
                if playerVM.isInPipMode {
                    Image(systemName: "pip.exit")
                } else {
                    Image(systemName: "pip.enter")
                }
            })
        }
        .imageScale(.large)
        .padding()
        .background(.thinMaterial)
    }
}
