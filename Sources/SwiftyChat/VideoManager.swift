//
//  VideoManager.swift
//
//
//  Created by Enes Karaosman on 9.11.2020.
//

import Foundation
import Observation

/// Behaves like a bridge between `VideoPlaceHolderCell` & `PIPVideoCell`
/// when placeHolder cell tapped, `message` parameter is set
/// also this change is being observed in `PIPVideoCell`so activates video frame.
@MainActor
@Observable
final class VideoManager<Message: ChatMessage> {

    var message: Message?
    var isFullScreen = false
    private var pendingPlaybackTask: Task<Void, Never>?

    var videoItem: VideoItem? {
        if let message = message,
            case let ChatMessageKind.video(videoItem) = message.messageKind {
            return videoItem
        }

        return nil
    }

    func flushState() {
        pendingPlaybackTask?.cancel()
        pendingPlaybackTask = nil
        message = nil
        isFullScreen = false
    }

    func play(_ message: Message) {
        flushState()
        pendingPlaybackTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(100))
            guard !Task.isCancelled else { return }
            self?.message = message
            self?.pendingPlaybackTask = nil
        }
    }
}
