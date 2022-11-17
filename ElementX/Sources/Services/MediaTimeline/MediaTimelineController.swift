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
    var mediaItems: [EventBasedTimelineItemProtocol] = []

    private let roomTimelineController: RoomTimelineControllerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(roomTimelineController: RoomTimelineControllerProtocol) {
        self.roomTimelineController = roomTimelineController
        processTimelineItems(roomTimelineController.timelineItems)

//        roomTimelineController.callbacks
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] callback in
//                switch callback {
//                case .updatedTimelineItems:
//                    self?.processTimelineItems(roomTimelineController.timelineItems)
//                default:
//                    break
//                }
//            }
//            .store(in: &cancellables)
    }

    private func processTimelineItems(_ items: [RoomTimelineItemProtocol]) {
        var mediaItems: [EventBasedTimelineItemProtocol] = []
        for item in items {
            if let item = item as? ImageRoomTimelineItem {
                mediaItems.append(item)
            } else if let item = item as? VideoRoomTimelineItem {
                mediaItems.append(item)
            }
        }
        self.mediaItems = mediaItems
    }
}
