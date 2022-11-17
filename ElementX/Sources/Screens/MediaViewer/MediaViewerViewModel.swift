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

import SwiftUI

typealias MediaViewerViewModelType = StateStoreViewModel<MediaViewerViewState, MediaViewerViewAction>

class MediaViewerViewModel: MediaViewerViewModelType, MediaViewerViewModelProtocol {
    // MARK: - Properties

    // MARK: Private

    private let timelineController: MediaTimelineControllerProtocol
    private let mediaProvider: MediaProviderProtocol
    private let itemId: String?

    // MARK: Public

    var callback: ((MediaViewerViewModelAction) -> Void)?

    // MARK: - Setup

    init(timelineController: MediaTimelineControllerProtocol,
         mediaProvider: MediaProviderProtocol,
         itemId: String? = nil) {
        self.timelineController = timelineController
        self.mediaProvider = mediaProvider
        self.itemId = itemId

        let selectedIndex = timelineController.mediaItems.firstIndex { $0.id == itemId } ?? 0
        super.init(initialViewState: MediaViewerViewState(bindings: .init(selectedIndex: selectedIndex)))

        updateItems()
    }
    
    // MARK: - Public
    
    override func process(viewAction: MediaViewerViewAction) async {
        switch viewAction {
        case .cancel:
            callback?(.cancel)
        }
    }

    // MARK: - Private

    private func updateItems() {
        let selectedItemId: String?
        if state.bindings.selectedIndex < state.items.count {
            selectedItemId = state.items[state.bindings.selectedIndex].id
        } else {
            selectedItemId = nil
        }
        state.items = timelineController.mediaItems

        if let selectedItemId {
            // if an item was selected before the update
            // re-select the same item after the update
            if let index = state.items.firstIndex(where: { item in
                item.id == selectedItemId
            }) {
                state.bindings.selectedIndex = index
            } else {
                state.bindings.selectedIndex = 0
            }
        }

        // reload the view
        state.viewId = UUID()
    }
}
