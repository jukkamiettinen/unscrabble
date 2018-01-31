//
//  Unscrabble2000Tests.swift
//  Unscrabble2000Tests
//
//  Created by Jukka Miettinen on 25/01/2018.
//

import XCTest
@testable import Unscrabble2000

class Unscrabble2000Tests: XCTestCase {
    let unscrabble = Unscrabble()
    var dictionary: [String] = []
    var matchingWords: [String] = []
    
    override func setUp() {
        super.setUp()
        let data = try! String(contentsOfFile: Bundle.main.path(forResource: "words", ofType: "txt")!, encoding: .utf8)
        dictionary = data.components(separatedBy: .newlines)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWordInputWith7letters() {
        Unscrabble.findWords(from: dictionary, with: "abcdefg", matchingWords: &matchingWords, notAvailableCharacters: "", maxWordCount: 5)
        XCTAssertEqual(matchingWords, ["cafe", "ad"])
    }

    func testWordInputMustContainCharacterG() {
        Unscrabble.findWords(from: dictionary, with: "G__", matchingWords: &matchingWords, notAvailableCharacters: "", maxWordCount: 3)
        XCTAssertEqual(matchingWords, ["ego", "geo", "ges", "gis"])
    }

    func testWordInputMustContainCharacterÖ() {
        Unscrabble.findWords(from: dictionary, with: "Ö_", matchingWords: &matchingWords, notAvailableCharacters: "", maxWordCount: 2)
        XCTAssertEqual(matchingWords, ["yö", "öh"])
    }
}
