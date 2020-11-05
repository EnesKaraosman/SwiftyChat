//
//  SwiftUIView.swift
//  
//
//  Created by Enes Karaosman on 5.11.2020.
//

import SwiftUI
import VideoPlayer
import AVFoundation
import Combine

public struct VideoCell<Message: ChatMessage>: View {
    
    public let media: VideoItem
    public let message: Message
    public let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle
    
    @State private var play: Bool = false
    @State private var time: CMTime = .zero
    @State private var autoReplay: Bool = false
    @State private var mute: Bool = false
    @State private var totalDuration: Double = 0
    
    @State private var currentSecond: Double = 0
    
    public var body: some View {
        videoPlayer
        .padding()
        .overlay(
            VStack {
                Spacer()
                videoOverlay
            }
            .padding()
        )
        .onDisappear { self.play = false }
    }
    
    private var videoPlayer: some View {
        VideoPlayer(url: media.url, play: $play, time: $time)
            .autoReplay(autoReplay)
            .mute(mute)
            .onBufferChanged { progress in print("onBufferChanged \(progress)") }
            .onPlayToEndTime { print("onPlayToEndTime") }
            .onReplay { print("onReplay") }
            .onStateChanged { state in
                switch state {
                case .loading:
                    print("Loading...")
                case .playing(let totalDuration):
                    print("Playing!")
                    self.totalDuration = totalDuration
                case .paused(let playProgress, let bufferProgress):
                    print("Paused: play \(Int(playProgress * 100))% buffer \(Int(bufferProgress * 100))%")
                case .error(let error):
                    print("Error: \(error)")
                }
            }
            .aspectRatio(1.78, contentMode: .fit)
            .cornerRadius(16)
            .shadow(color: .secondary, radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Overlay
    private var videoOverlay: some View {
        VStack(spacing: 0) {
        
            Slider(
                value: $currentSecond.didSet(execute: currentSecondSliderValueChanged),
                in: 0...totalDuration
            )
            .padding(.horizontal)
            
            HStack {
                Text(getTimeString()).fontWeight(.semibold)
                Spacer()
                Text(getRemainingDurationString()).fontWeight(.semibold)
            }
            .padding(.horizontal)
            .font(.footnote)
            
            HStack {
                Button(action: {
                    self.time = CMTimeMakeWithSeconds(max(0, self.time.seconds - 10), preferredTimescale: self.time.timescale)
                }, label: {
                    Image(systemName: "gobackward.10")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                })
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Button(action: {
                    self.play.toggle()
                }, label: {
                    Image(systemName: self.play ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                })
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Button(action: {
                    self.time = CMTimeMakeWithSeconds(min(self.totalDuration, self.time.seconds + 10), preferredTimescale: self.time.timescale)
                }, label: {
                    Image(systemName: "goforward.10")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                })
                .frame(minWidth: 0, maxWidth: .infinity)
                
            }
            .padding(.vertical, 4)
            
        }
        .background(
            Color.secondary
                .blur(radius: 2)
                .cornerRadius(16)
        )
        .onReceive(Just(time), perform: { _time in
            self.currentSecond = _time.seconds
        })
    }
    
    private func currentSecondSliderValueChanged(value: Double) {
        self.time = CMTimeMakeWithSeconds(
            value,
            preferredTimescale: self.time.timescale
        )
    }
    
    private func getTimeString() -> String {
        let m = Int(time.seconds / 60)
        let s = Int(time.seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", arguments: [m, s])
    }
    
    private func getRemainingDurationString() -> String {
        let totalSecondsRemaining = totalDuration - time.seconds
        let m = Int(totalSecondsRemaining / 60)
        let s = Int(totalSecondsRemaining.truncatingRemainder(dividingBy: 60))
        return String(format: "-%d:%02d", arguments: [m, s])
    }
    
}
