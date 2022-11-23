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

    // MARK: Public
    
    @ObservedObject var context: MediaViewerViewModel.Context
    
    // MARK: Views
    
    var body: some View {
        TabView(selection: $context.selectedIndex) {
            ForEach(0..<context.viewState.items.count, id: \.self) { index in
                let mediaItem = context.viewState.items[index]

                switch mediaItem {
                case .image(let item):
                    page(with: item)
                        .tag(index)
                case .video(let item):
                    page(with: item)
                        .tag(index)
//                        .onAppear {
//                            context.send(viewAction: .itemAppeared(id: item.id))
//                        }
//                        .onDisappear {
//                            context.send(viewAction: .itemDisappeared(id: item.id))
//                        }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .tabViewStyle(.page(indexDisplayMode: .always))
        .id(context.viewState.viewId)
        .toolbar { toolbar }
//        .onChange(of: context.selectedIndex) { [oldValue = context.selectedIndex] newValue in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if let item = context.viewState.items[safe: newValue] {
//                    context.send(viewAction: .itemAppeared(id: item.id))
//                }
//                if let oldItem = context.viewState.items[safe: oldValue] {
//                    context.send(viewAction: .itemDisappeared(id: oldItem.id))
//                }
//            }
//        }
    }

    @ViewBuilder
    private func page(with item: ImageRoomTimelineItem) -> some View {
        if let image = item.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            loading()
        }
    }

    @ViewBuilder
    private func page(with item: VideoRoomTimelineItem) -> some View {
        if let url = item.cachedVideoURL {
            // ready to play
            VideoPlayer(player: player(with: url))
//                .onTapGesture {
//                    if player.timeControlStatus == .playing {
//                        player.pause()
//                    } else {
//                        player.play()
//                    }
//                }
        } else if let image = item.image {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                ProgressView()
                    .foregroundColor(.white)
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
            }
        } else {
            loading()
        }
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            if context.viewState.isModallyPresented {
                Button { context.send(viewAction: .cancel) } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .accessibilityIdentifier("dismissButton")
            }
        }
    }

    private func loading() -> some View {
        ProgressView(ElementL10n.loading)
            .frame(maxWidth: .infinity)
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
