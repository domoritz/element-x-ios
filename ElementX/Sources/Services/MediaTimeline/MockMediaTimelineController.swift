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

import Foundation

class MockMediaTimelineController: MediaTimelineControllerProtocol {
    var mediaItems: [EventBasedTimelineItemProtocol] = [
        TextRoomTimelineItem(id: UUID().uuidString,
                             text: "Let’s get lunch soon! New salad place opened up 🥗. When are y’all free? 🤗",
                             timestamp: "10:11 AM",
                             inGroupState: .beginning,
                             isOutgoing: false,
                             isEditable: false,
                             senderId: "",
                             senderDisplayName: "Helena",
                             properties: RoomTimelineItemProperties(reactions: [
                                 AggregatedReaction(key: "🙌", count: 1, isHighlighted: true)
                             ]))
    ]
}
