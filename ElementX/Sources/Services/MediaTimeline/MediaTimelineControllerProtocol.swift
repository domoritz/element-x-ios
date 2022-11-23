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

enum MediaTimelineItem: Identifiable {
    case image(ImageRoomTimelineItem)
    case video(VideoRoomTimelineItem)

    var id: String {
        switch self {
        case .image(let item):
            return item.id
        case .video(let item):
            return item.id
        }
    }
}

enum MediaTimelineControllerCallback {
    case updatedTimelineItems
    case updatedTimelineItem(_ itemId: String)
    case startedBackPaginating
    case finishedBackPaginating
}

enum MediaTimelineControllerError: Error {
    case generic
}

@MainActor
protocol MediaTimelineControllerProtocol {
    var mediaItems: [MediaTimelineItem] { get }

    var callbacks: PassthroughSubject<MediaTimelineControllerCallback, Never> { get }

    func processItemAppearance(_ itemId: String) async

    func processItemDisappearance(_ itemId: String) async

    func paginateBackwards(_ count: UInt) async -> Result<Void, MediaTimelineControllerError>
}
