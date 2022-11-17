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

struct MediaViewerScreen: View {
    // MARK: Private
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedIndex = 0
    @State private var items: [EventBasedTimelineItemProtocol] = []

    // MARK: Public
    
    @ObservedObject var context: MediaViewerViewModel.Context
    
    // MARK: Views
    
    var body: some View {
        TabView(selection: $context.selectedIndex) {
            ForEach(0..<context.viewState.items.count, id: \.self) { index in
                let item = context.viewState.items[index]

                if let item = item as? ImageRoomTimelineItem {
                    page(with: item)
                        .tag(index)
                } else if let item = item as? VideoRoomTimelineItem {
                    page(with: item)
                        .tag(index)
                } else {
                    EmptyView()
                        .tag(index)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .id(context.viewState.viewId)
    }

    @ViewBuilder
    private func page(with item: ImageRoomTimelineItem) -> some View {
        if let image = item.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView(ElementL10n.loading)
                .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func page(with item: VideoRoomTimelineItem) -> some View {
        if let url = item.cachedVideoURL {
            // ready to play
            VideoPlayer(player: player(with: url))
        } else if let image = item.image {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial, in: Circle())
                    .foregroundColor(.white)
            }
        } else {
            ProgressView(ElementL10n.loading)
                .frame(maxWidth: .infinity)
        }
    }

    private func player(with url: URL, autoplay: Bool = true) -> AVPlayer {
        let player = AVPlayer(url: url)
        if autoplay {
            player.play()
        }
        return player
    }
}

// MARK: - Previews

struct MediaViewer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let viewModel = MediaViewerViewModel(timelineController: MockMediaTimelineController(),
                                                 mediaProvider: MockMediaProvider())
            MediaViewerScreen(context: viewModel.context)
        }
        .tint(.element.accent)
    }
}
