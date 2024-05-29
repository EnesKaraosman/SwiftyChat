//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 6/19/23.
//

import SwiftUI
import AVFoundation
import Combine
struct AudioPlayerView: View {
    var audioURL: URL
    @State private var isPlaying = false
    @State private var currentTime: Double = 0.0
    @State private var totalTime: Double?
    @State private var isLoadingTotalTime = false

    @StateObject private var soundManager = SoundManager()

    var body: some View {
        HStack {
            Button(action: {
                isPlaying.toggle()
                if isPlaying {
                    soundManager.playSound(sound: audioURL.absoluteString)
                } else {
                    soundManager.stopSound()
                }
            }) {
                Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .foregroundColor(Color.clear)
                                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                    )
                    .padding(.trailing)
            }
            .frame(width: 38, height: 38)

            if let totalTime = totalTime {
                Slider(value: $currentTime, in: 0...totalTime, step: 1)
                    .disabled(true)
                Text(formatTimeString(time: totalTime))
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            } else {
                Spacer()
                if isLoadingTotalTime {
                    ProgressView()
                        .frame(width: 30, height: 30)
                } else {
                    Text("Fetching...")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 280, height: 60)
        .padding(.horizontal)
        .onAppear {
            fetchTotalTime()
        }
        .onReceive(soundManager.currentTimePublisher) { time in
            currentTime = time
        }
    }
    
    func formatTimeString(time: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(time)) ?? ""
    }
    
    func fetchTotalTime() {
        isLoadingTotalTime = true
        
        DispatchQueue.global().async {
            soundManager.getTotalDuration(audioURL: audioURL) {  duration in
                DispatchQueue.main.async {
                    self.totalTime = duration
                    self.isLoadingTotalTime = false
                }
            }
        }
    }
}


class SoundManager: ObservableObject {
    private var audioPlayer: AVPlayer?
    private var timeObserver: Any?

    let currentTimePublisher = PassthroughSubject<Double, Never>()

    func playSound(sound: String) {
        if let url = URL(string: sound) {
            downloadAndCacheAudio(from: url) { [weak self] cachedURL in
                guard let self = self, let cachedURL = cachedURL else { return }
                self.audioPlayer = AVPlayer(url: cachedURL)
                self.audioPlayer?.play()
                
                self.addTimeObserver()
            }
        }
    }

    func stopSound() {
        audioPlayer?.pause()
        audioPlayer = nil
        
        removeTimeObserver()
    }
    
    func getTotalDuration(audioURL: URL, completion: @escaping (Double) -> Void) {
        downloadAndCacheAudio(from: audioURL) { cachedURL in
            guard let cachedURL = cachedURL else {
                completion(0)
                return
            }
            let asset = AVURLAsset(url: cachedURL)
            let duration = asset.duration.seconds
            completion(duration)
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            self?.currentTimePublisher.send(time.seconds)
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            audioPlayer?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func downloadAndCacheAudio(from url: URL, completion: @escaping (URL?) -> Void) {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cachedFileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: cachedFileURL.path) {
            completion(cachedFileURL)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location, error == nil else {
                completion(nil)
                return
            }
            
            do {
                try FileManager.default.moveItem(at: location, to: cachedFileURL)
                completion(cachedFileURL)
            } catch {
                print("Error caching audio file: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
