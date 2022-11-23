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

import AVKit
import SwiftUI

struct MediaViewerCoordinatorParameters {
    let navigationController: NavigationController
    let timelineController: MediaTimelineControllerProtocol
    let mediaProvider: MediaProviderProtocol
    let item: EventBasedTimelineItemProtocol?
    let isModallyPresented: Bool
}

enum MediaViewerCoordinatorAction {
    case cancel
}

final class MediaViewerCoordinator: CoordinatorProtocol {
    private let parameters: MediaViewerCoordinatorParameters
    private var viewModel: MediaViewerViewModelProtocol
    
    var callback: ((MediaViewerCoordinatorAction) -> Void)?
    
    init(parameters: MediaViewerCoordinatorParameters) {
        self.parameters = parameters

        viewModel = MediaViewerViewModel(timelineController: parameters.timelineController,
                                         mediaProvider: parameters.mediaProvider,
                                         itemId: parameters.item?.id,
                                         isModallyPresented: parameters.isModallyPresented)
    }
    
    // MARK: - Public
    
    func start() {
        configureAudioSession(.sharedInstance())

        viewModel.callback = { [weak self] action in
            guard let self else { return }
            MXLog.debug("MediaViewerViewModel did complete with result: \(action).")
            switch action {
            case .cancel:
                self.callback?(.cancel)
            }
        }
    }
        
    func toPresentable() -> AnyView {
        AnyView(MediaViewerScreen(context: viewModel.context))
    }

    // MARK: - Private

    private func configureAudioSession(_ session: AVAudioSession) {
        do {
            try session.setCategory(.playback,
                                    mode: .default,
                                    options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            MXLog.debug("Configure audio session failed: \(error)")
        }
    }
}
