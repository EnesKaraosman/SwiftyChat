//
//  VideoPlayerContainer.swift
//  
//
//  Created by Enes Karaosman on 9.11.2020.
//

import SwiftUI
import AVFoundation
import VideoPlayer
import SwiftUIEKtensions

internal struct VideoPlayerContainer<Message: ChatMessage>: View {
    
    public let media: VideoItem
    public let message: Message
    
    @EnvironmentObject var videoManager: VideoManager<Message>
    
    @State private var time: CMTime = .zero
    @State private var play: Bool = true
    @State private var autoReplay: Bool = false
    @State private var mute: Bool = false
    @State private var totalDuration: Double = 0
    @State private var waitingOverlayToHide: Bool = false
    
    @State private var showOverlay: Bool = false {
        didSet {
            if showOverlay && !waitingOverlayToHide {
                waitingOverlayToHide = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        showOverlay = false
                        waitingOverlayToHide = false
                    }
                }
            }
        }
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            videoPlayer
            .onTapGesture {
                withAnimation {
                    showOverlay.toggle()
                }
            }
            .onDisappear { self.play = false }
            
            videoOverlay
        }
    }
    
    // MARK: - VideoPlayer
    private var videoPlayer: some View {
        VideoPlayer.init(url: media.url, play: $play, time: $time)
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
            .cornerRadius(8)
    }
    
    // MARK: - Overlay
    private var videoOverlay: some View {
        VStack(spacing: 0) {
            HStack {
                closeButton
                Spacer()
                fullScreenButton
            }
            Spacer()
            VStack(spacing: 1) {
                durationSliderView
                
                HStack {
                    Text(self.time.seconds.formatSecondsToHMS())
                        .fontWeight(.semibold)
                    Spacer()
                    Text(self.totalDuration.formatSecondsToHMS())
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .font(.footnote)
                
                HStack {
                    
                    Image(systemName: "gobackward.10")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            self.time = CMTimeMakeWithSeconds(max(0, self.time.seconds - 10), preferredTimescale: self.time.timescale)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    
                    Image(systemName: self.play ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture { self.play.toggle() }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    
                    Image(systemName: "goforward.10")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            self.time = CMTimeMakeWithSeconds(min(self.totalDuration, self.time.seconds + 10), preferredTimescale: self.time.timescale)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                .padding(.vertical, 4)
            }
            .background(
                Color.secondary.colorInvert()
                    .blur(radius: 2)
                    .cornerRadius(8)
            )
            
        }
        .hidden(!showOverlay)
    }
    
    // MARK: - VideoOverlayComponents
    private var closeButton: some View {
        Color.secondary.colorInvert()
            .cornerRadius(10)
            .frame(width: 50, height: 40)
            .overlay(
                Image(systemName: "xmark")
                    .font(Font.body.weight(.semibold))
                    .padding()
                    .foregroundColor(Color.white)
            )
            .onTapGesture {
                self.videoManager.flushState()
            }
    }
    
    private var fullScreenButton: some View {
        Color.secondary.colorInvert()
            .cornerRadius(10)
            .frame(width: 50, height: 40)
            .overlay(
                Image(
                    systemName: videoManager.isFullScreen ?
                        "arrow.down.right.and.arrow.up.left" :
                        "arrow.up.left.and.arrow.down.right"
                )
                .font(Font.body.weight(.semibold))
                .padding()
                .foregroundColor(Color.white)
            )
            .onTapGesture {
                withAnimation {
                    videoManager.isFullScreen.toggle()
                }
            }
    }
    
    private var durationSliderView: some View {
        Slider(
            value: Binding(
                get: { time.seconds },
                set: {
                    self.time = CMTimeMakeWithSeconds(
                        $0, preferredTimescale: self.time.timescale
                    )
                }
            ),
            in: 0...totalDuration
        )
        .padding(.horizontal)
        .accentColor(.red)
        .gesture(DragGesture()) // << To avoid outer dragGesture, slider & position both was changing
    }
    
}
