//
// Copyright 2022 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Combine
import Foundation

class MediaTimelineController: MediaTimelineControllerProtocol {
    var mediaItems: [MediaTimelineItem] = []

    let callbacks = PassthroughSubject<MediaTimelineControllerCallback, Never>()

    private let roomTimelineController: RoomTimelineControllerProtocol
    private let mediaProvider: MediaProviderProtocol
    private var cancellables = Set<AnyCancellable>()

    init(roomTimelineController: RoomTimelineControllerProtocol,
         mediaProvider: MediaProviderProtocol) {
        self.roomTimelineController = roomTimelineController
        self.mediaProvider = mediaProvider
        processTimelineItems(roomTimelineController.timelineItems)

        roomTimelineController.callbacks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] callback in
                switch callback {
                case .updatedTimelineItems:
                    self?.processTimelineItems(roomTimelineController.timelineItems)
                case .updatedTimelineItem(let itemId):
                    if self?.mediaItems.filter({ $0.id == itemId }).first != nil {
                        self?.callbacks.send(.updatedTimelineItem(itemId))
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func processTimelineItems(_ items: [RoomTimelineItemProtocol]) {
        var mediaItems: [MediaTimelineItem] = []
        for item in items {
            if let item = item as? ImageRoomTimelineItem {
                mediaItems.append(.image(item))
            } else if let item = item as? VideoRoomTimelineItem {
                mediaItems.append(.video(item))
            }
        }
        self.mediaItems = mediaItems
        callbacks.send(.updatedTimelineItems)
    }

    func processItemAppearance(_ itemId: String) async {
        guard let mediaItem = mediaItems.first(where: { $0.id == itemId }) else {
            return
        }

        switch mediaItem {
        case .image:
            break
        case .video(let item):
            await loadVideoForTimelineItem(item)
        }
    }

    func processItemDisappearance(_ itemId: String) async { }

    func paginateBackwards(_ count: UInt) async -> Result<Void, MediaTimelineControllerError> {
        .failure(.generic)
    }

    private func loadVideoForTimelineItem(_ item: VideoRoomTimelineItem) async {
        if item.cachedVideoURL != nil {
            // already cached
            return
        }

        guard let source = item.source else {
            return
        }

        // This is not great. We could better estimate file extension from the mimetype.
        let fileExtension = String(item.text.split(separator: ".").last ?? "mp4")
        switch await mediaProvider.loadFileFromSource(source, fileExtension: fileExtension) {
        case .success(let fileURL):
            guard let index = mediaItems.firstIndex(where: { $0.id == item.id }) else {
                return
            }

            let mediaItem = mediaItems[index]
            switch mediaItem {
            case .video(var videoItem):
                videoItem.cachedVideoURL = fileURL
                mediaItems[index] = .video(videoItem)
                callbacks.send(.updatedTimelineItem(mediaItem.id))
            default:
                break
            }
        case .failure:
            break
        }
    }
}
