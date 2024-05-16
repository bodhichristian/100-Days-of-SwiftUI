//
//  ResortListScreen.swift
//  SnowSeekerUITests
//
//  Created by christian on 5/16/24.
//

import Foundation
import XCTest

class ResortListScreen: Screen {
    // Conform to Screen protocol
    var app: XCUIApplication
    
    // Screen-specific elements
    let resortsNavBar: XCUIElement
    let sortOptionsButton: XCUIElement
    let sortDefaultButton: XCUIElement
    let sortAlphabeticalButton: XCUIElement
    let sortByCountryButton: XCUIElement
    let cancelButton: XCUIElement
   
    init(app: XCUIApplication) {
        self.app = app
        self.resortsNavBar = app.navigationBars["Resorts"]
        
        self.sortOptionsButton = resortsNavBar.buttons["Change sort order"]
        self.sortAlphabeticalButton = app.buttons["Alphabetical"]
        self.sortByCountryButton = app.buttons["By Country"]
        self.sortDefaultButton = app.buttons["Default"]
        self.cancelButton = app.buttons["Cancel"]

    }
}
