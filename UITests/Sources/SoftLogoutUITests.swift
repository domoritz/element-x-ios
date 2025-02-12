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

import ElementX
import XCTest

@MainActor
class SoftLogoutUITests: XCTestCase {
    var app: XCUIApplication!

    @MainActor
    override func setUp() async throws {
        app = nil
    }

    func testInitialState() {
        app = Application.launch()
        app.goToScreenWithIdentifier(.softLogout)
        
        XCTAssertTrue(app.staticTexts["titleLabel"].exists, "The title should be shown.")
        XCTAssertTrue(app.staticTexts["messageLabel1"].exists, "The message 1 should be shown.")
        XCTAssertTrue(app.staticTexts["clearDataTitleLabel"].exists, "The clear data title should be shown.")
        XCTAssertTrue(app.staticTexts["clearDataMessageLabel"].exists, "The clear data message should be shown.")
        
        let passwordTextField = app.secureTextFields["passwordTextField"]
        XCTAssertTrue(passwordTextField.exists, "The password text field should be shown.")
        XCTAssertTrue(passwordTextField.label.isEmpty, "The password text field text should be empty before text is input.")
        XCTAssertEqual(passwordTextField.placeholderValue, ElementL10n.loginSignupPasswordHint, "The password text field should be showing the placeholder before text is input.")
        
        let nextButton = app.buttons["nextButton"]
        XCTAssertTrue(nextButton.exists, "The next button should be shown.")
        XCTAssertFalse(nextButton.isEnabled, "The next button should be disabled before text is input.")

        let forgotPasswordButton = app.buttons["forgotPasswordButton"]
        XCTAssertTrue(forgotPasswordButton.exists, "The forgot password button should be shown.")
        XCTAssertTrue(forgotPasswordButton.isEnabled, "The forgot password button should be enabled.")

        let clearDataButton = app.buttons["clearDataButton"]
        XCTAssertTrue(clearDataButton.exists, "The clear data button should be shown.")
        XCTAssertTrue(clearDataButton.isEnabled, "The clear data button should be enabled.")

        app.assertScreenshot(.softLogout)
    }
}
