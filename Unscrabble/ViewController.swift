//
//  ViewController.swift
//  ScrabbleHelper
//
//  Created by Jukka Miettinen on 16/01/2018.
//

import UIKit

let dictionaryPath = Bundle.main.path(forResource: "wlist", ofType: "xml")!
let dictionaryUrl = URL(fileURLWithPath: dictionaryPath)
let maxRetries = 20
let minWordCount = 2

/**
 Collection of array extensions
 */
extension Array {
    /**
     Returns randomly shuffled array.
     */
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            self.swapAt(i, j)
        }
    }
}

/**
 Collection of string extensions
 */
extension String {
    /**
     Returns squeezed string where all duplicate characters are removed.
     Example: "aanndpp" -> "andp"
     */
    var squeezed: String {
        var set = Set<Character>()
        return String(filter{ set.insert($0).inserted })
    }
}

class ViewController: UIViewController {
    var dictionary: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                self.dictionary = data.components(separatedBy: .newlines)
                findPossibleWords(
                    availableCharacters: "G****",
                    notAvailableCharacters: "",
                    maxWordCount: 5)
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     Returns all possible permuations of passed in string
     - parameter str: String to calculate permutation for
     - parameter left: Starting index
     - parameter right: End index
     - parameter output: All possible permuations of passed in string
     */
    private func permute(str: String, left: Int, right: Int, output: inout [String]) {
        var input = str
        if (left == right) {
            output.append(input)
        }
        else {
            for index in left...right {
                var characters = Array(input)
                characters.swapAt(index, left)
                input = String(characters)

                permute(str: input, left: left + 1, right: right, output: &output);

                characters.swapAt(index, left)
                input = String(characters)
                if !output.contains(input) {
                    output.append(input)
                }
            }
        }
    }

    /**
     Returns all words that have contain all given characters
     - parameter availableCharacters: Available characters
     - parameter matchingWords: Words that match all given criteria
     - parameter notAvailableCharacters: Characters that word should not contain
     - parameter maxWordCount: max word length
     */
    func findWords(using availableCharacters: String, matchingWords: inout [String], notAvailableCharacters: String, maxWordCount: Int) {
        var availableCharacters = availableCharacters
        var mustContain = ""
        let upperCase = CharacterSet.uppercaseLetters

        // Figure out what characters word must contain
        for character in availableCharacters.unicodeScalars {
            if upperCase.contains(character) {
                mustContain += character.escaped(asASCII: true).lowercased()
            }
        }
        availableCharacters = availableCharacters.lowercased()

        for word in dictionary {
            var matching = true

            let word = word.trimmingCharacters(in: .whitespacesAndNewlines)

            guard word.count >= minWordCount, word.count <= maxWordCount, availableCharacters.count >= word.count else { continue }

            for character in mustContain {
                if !word.contains(character) {
                    matching = false
                    break
                }
            }

            guard matching else { continue }

            // Make sure word contains _all_ available characters
            var _availableCharacters = availableCharacters
            for index in word.indices {
                if _availableCharacters.contains(word[index]) {
                    // Remove used character, not available anymore
                    _availableCharacters.remove(at: _availableCharacters.index(of: word[index])!)
                } else if _availableCharacters.contains("*") {
                    // Remove magic character, not available anymore
                    _availableCharacters.remove(at: _availableCharacters.index(of: "*")!)
                } else {
                    matching = false
                    // At least one character did not match, break the for loop
                    // and move on to next word
                    break
                }
            }

            guard matching else { continue }

            // Make sure word does not contain characters that are not available
            for character in notAvailableCharacters {
                if word.contains(character) {
                    matching = false
                    // At least one character did not match, break the for loop
                    // and move on to next wor
                    break
                }
            }

            guard matching else { continue }

            // Perfect match found
            if !matchingWords.contains(word) {
                matchingWords.append(word)
            }
        }
    }

    /**
     Returns all words that have contain all given characters
     - parameter availableCharacters: Available characters
     - parameter notAvailableCharacters: Characters that word should not contain
     - parameter maxWordCount: max word length
     */
    func findPossibleWords(availableCharacters: String, notAvailableCharacters: String, maxWordCount: Int) {
        print("Searching")

        var matchingWords: [String] = []
        findWords(using: availableCharacters, matchingWords: &matchingWords, notAvailableCharacters: notAvailableCharacters, maxWordCount: maxWordCount)

        if matchingWords.count == 0 {
            print("\nNO MATCHING WORDS FOUND", terminator:"")
        }

        for word in matchingWords {
            print("\nMatching word: \(word)", terminator:"")
        }
    }
}

