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

class MockMediaTimelineController: MediaTimelineControllerProtocol {
    var mediaItems: [MediaTimelineItem] = [
        .image(ImageRoomTimelineItem(id: UUID().uuidString,
                                     text: "Blurhashed image",
                                     timestamp: "Now",
                                     inGroupState: .single,
                                     isOutgoing: false,
                                     isEditable: false,
                                     senderId: "Bob",
                                     source: nil,
                                     image: Asset.Images.appLogo.image,
                                     aspectRatio: 0.7,
                                     blurhash: "L%KUc%kqS$RP?Ks,WEf8OlrqaekW")),
        .image(ImageRoomTimelineItem(id: UUID().uuidString,
                                     text: "Blurhashed image",
                                     timestamp: "Now",
                                     inGroupState: .single,
                                     isOutgoing: false,
                                     isEditable: false,
                                     senderId: "Bob",
                                     source: nil,
                                     image: Asset.Images.appLogo.image,
                                     aspectRatio: 0.7,
                                     blurhash: "L%KUc%kqS$RP?Ks,WEf8OlrqaekW"))
    ]

    let callbacks = PassthroughSubject<MediaTimelineControllerCallback, Never>()

    func processItemAppearance(_ itemId: String) async { }

    func processItemDisappearance(_ itemId: String) async { }

    func paginateBackwards(_ count: UInt) async -> Result<Void, MediaTimelineControllerError> {
        .failure(.generic)
    }
}
