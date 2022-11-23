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

// MARK: - Coordinator

// MARK: View model

enum MediaViewerViewModelAction {
    case cancel
}

// MARK: View

struct MediaViewerViewState: BindableState {
    var items: [MediaTimelineItem] = []
    var viewId = UUID()
    let isModallyPresented: Bool
    var bindings: MediaViewerViewStateBindings
}

struct MediaViewerViewStateBindings {
    var selectedIndex = 0

    /// Information describing the currently displayed alert.
    var alertInfo: AlertInfo<MediaViewerScreenErrorType>?
}

enum MediaViewerViewAction {
    case itemAppeared(id: String)
    case itemDisappeared(id: String)
    case cancel
}

enum MediaViewerScreenErrorType: Hashable {
    /// A specific error message shown in an alert.
    case alert(String)
}
