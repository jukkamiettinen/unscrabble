//
//  Unscrabble2000UITests.swift
//  Unscrabble2000UITests
//
//  Created by Jukka Miettinen on 25/01/2018.
//

import XCTest
@testable import Unscrabble2000

extension XCUIApplication {
    var isDisplayingMainView: Bool {
        return otherElements["mainView"].exists
    }
}

class Unscrabble2000UITests: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMainViewDisplayed() {
        let app = XCUIApplication()
        XCTAssertTrue(app.isDisplayingMainView)
    }

    func testWordInputWith7letters() {
        testInputAgainstVisibleCells(
            searchText: "abcdefg",
            foundWords: ["cafe", "ad"]
        )
    }

    func testWordInputWith4letters() {
        testInputAgainstVisibleCells(
            searchText: "lego",
            foundWords: ["ego", "geo"]
        )
    }

    func testWordInputWithMagicCharacters() {
        testInputAgainstVisibleCells(
            searchText: "B__",
            foundWords: ["PUb", "bAR", "WEb", "bIO", "bOA", "AbI"]
        )
    }

    func testWordInputWith5letters() {
        snapshot("01WithoutInput")
        testInputAgainstVisibleCells(
            searchText: "testi",
            foundWords: ["setti", "testi", "itse", "ties", "esi", "ies", "sei", "tie", "tse"]
        )
        snapshot("02WithInput")
    }

    private func testInputAgainstVisibleCells(searchText: String, foundWords: [String]) {
        let app = XCUIApplication()

        // Assert that we are displaying the tableview
        let possibleWordsTableView = app.tables["table--possibleWordsTableView"]
        XCTAssertTrue(possibleWordsTableView.exists, "The possible words table view exists")

        // Find search field within table view and tap it
        let searchField = possibleWordsTableView.children(matching: .searchField).element
        searchField.tap()

        // Type in query
        searchField.typeText(searchText)

        // Get an array of cells
        let tableCells = possibleWordsTableView.cells

        XCTAssertEqual(tableCells.count, foundWords.count)

        if tableCells.count > 0 {
            for i in 0...tableCells.count - 1 {
                XCTAssert(possibleWordsTableView.cells.element(boundBy: i).staticTexts[foundWords[i]].exists)
            }
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
    }
}
