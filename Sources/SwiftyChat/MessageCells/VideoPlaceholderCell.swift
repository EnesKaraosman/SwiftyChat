//
//  SwiftUIView.swift
//  
//
//  Created by Enes Karaosman on 5.11.2020.
//

import SwiftUI
import VideoPlayer
import AVFoundation
import SwiftUIEKtensions


class VideoManager: ObservableObject {
    @Published var selectedVideoItem: VideoItem?
}

public struct PIPVideoCell: View {
    
    @EnvironmentObject var videoManager: VideoManager
    
    var message = MockMessages.generateMessage(kind: .Video)

    public init() { }
    
    @ViewBuilder private var video: some View {
        if let videoItem = videoManager.selectedVideoItem {
            VideoPlayerContainer(media: videoItem, size: .zero)
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            video
            .frame(height: geometry.size.height / 3)
            .cornerRadius(20)
            .padding()
            .position(location)
            .gesture(simpleDrag(in: geometry))
        }
        .animation(.linear(duration: 0.3))
    }
    
    @State private var location: CGPoint = CGPoint(x: 200, y: 100)
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    func simpleDrag(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
            .onEnded { (value) in
                let videoFrameHeight: CGFloat = 200
                if self.location.y > (geometry.size.height - videoFrameHeight) / 2 {
                    self.location = CGPoint(x: geometry.size.width / 2, y: geometry.size.height - videoFrameHeight)
                } else {
                    self.location = CGPoint(x: geometry.size.width / 2, y: videoFrameHeight / 2)
                }
            }
    }
    
}

internal struct VideoPlayerContainer: View {
    
    public let media: VideoItem
    public let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle
    @EnvironmentObject var videoManager: VideoManager
    
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
            .aspectRatio(1.78, contentMode: .fit)
            .cornerRadius(16)
            .shadow(color: .secondary, radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Overlay
    private var videoOverlay: some View {
        VStack(spacing: 0) {
//            HStack {
//                RoundedRectangle(cornerRadius: 16)
//                    .frame(width: 60, height: 50)
//                    .foregroundColor(.secondary)
//                    .overlay(
//                        Image(systemName: "xmark")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 30)
//                            .foregroundColor(.white)
//                    )
//                    .onTapGesture {
//                        self.play = false
//                    }
//                Spacer()
//            }
            Spacer()
            VStack(spacing: 1) {
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
                
                HStack {
                    Text(getTimeString()).fontWeight(.semibold)
                    Spacer()
                    Text(getRemainingDurationString()).fontWeight(.semibold)
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
                    .cornerRadius(16)
            )
            
        }
        .hidden(!showOverlay)
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


/// When play button is tapped, it lets videoManager know about VideoItem
/// So manager knows when to display actual videoPlayer above `ChatView`
public struct VideoPlaceholderCell<Message: ChatMessage>: View {
    
    public let media: VideoItem
    public let message: Message
    public let size: CGSize
    
    @EnvironmentObject var style: ChatMessageCellStyle
    @EnvironmentObject var videoManager: VideoManager
    
    @State private var showPlayButton: Bool = true
    
    public var body: some View {
        thumbnailView
    }
    
    // MARK: - Thumbnail
    private var thumbnailView: some View {
        Image(uiImage: media.placeholderImage)
            .resizable()
            .aspectRatio(1.78, contentMode: .fit)
            .cornerRadius(16)
            .blur(radius: 3)
            .overlay(thumbnailOverlay)
    }
    
    private var playButton: some View {
        Image(systemName: "play.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40)
            .foregroundColor(.secondary)
            .onTapGesture {
                withAnimation {
                    showPlayButton = false
                    videoManager.selectedVideoItem = media
                }
            }
    }
    
    private var pipMessageView: some View {
        VStack {
            Image(systemName: "rectangle.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
            Text("Bu video resim içinde resim olarak oynuyor.")
                .padding(.horizontal, 100)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
    }
    
    @ViewBuilder private var thumbnailOverlay: some View {
        if showPlayButton {
            playButton
        } else {
            pipMessageView
        }
    }
    
}
