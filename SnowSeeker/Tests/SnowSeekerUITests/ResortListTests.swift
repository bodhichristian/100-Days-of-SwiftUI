//
//
//  SnowSeekerUITests.swift
//  SnowSeekerUITests
//
//  Created by christian on 5/16/24.
//

import XCTest

final class ResortListTests: XCTestCase {
    
    var app: XCUIApplication!
    var screen: ResortListScreen!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
        
        screen = ResortListScreen(app: app)
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSortOptionsButtonPresentsModal() {
        XCTAssertFalse(screen.cancelButton.exists)
        screen.sortOptionsButton.tap()
        
        XCTAssertTrue(screen.cancelButton.exists)
    }
    
    func testSortOptionSelectionDismissesModal() {
        screen.sortOptionsButton.tap()
        screen.sortDefaultButton.tap()
        XCTAssertFalse(screen.cancelButton.exists)
        
        screen.sortOptionsButton.tap()
        screen.sortAlphabeticalButton.tap()
        XCTAssertFalse(screen.cancelButton.exists)

        screen.sortOptionsButton.tap()
        screen.sortByCountryButton.tap()
        XCTAssertFalse(screen.cancelButton.exists)
        
    }
    
    func testCancelButtonDismissesModal() {
        screen.sortOptionsButton.tap()
        screen.cancelButton.tap()
        XCTAssertFalse(screen.cancelButton.exists)
    }
}
    
