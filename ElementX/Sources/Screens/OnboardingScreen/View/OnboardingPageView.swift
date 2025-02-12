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

struct OnboardingPageView: View {
    /// The content that this page should display.
    let content: OnboardingPageContent
    
    var body: some View {
        VStack {
            Image(content.image.name)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 310) // This value is problematic. 300 results in dropped frames
                // on iPhone 12/13 Mini. 305 the same on iPhone 12/13. As of
                // iOS 15, 310 seems fine on all supported screen widths 🤞.
                .padding(20)
                .accessibilityHidden(true)
            
            VStack(spacing: 8) {
                Text(content.title)
                    .font(.element.title2Bold)
                    .foregroundColor(.element.primaryContent)
                Text(content.message)
                    .font(.element.body)
                    .foregroundColor(.element.secondaryContent)
                    .multilineTextAlignment(.center)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom)
        .padding(.horizontal, 16)
        .readableFrame()
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static let content = OnboardingViewState().content
    static var previews: some View {
        ForEach(0..<content.count, id: \.self) { index in
            OnboardingPageView(content: content[index])
        }
    }
}
