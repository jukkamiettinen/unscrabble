//
//  Unscrabble.swift
//  Unscrabble2000
//
//  Created by Jukka Miettinen on 26/01/2018.
//

import Foundation

public class Unscrabble {
    struct Alphabet {
        var string: String
        var points: Int
    }

    let alphabets = [
        Alphabet(string: "A", points: 1),
        Alphabet(string: "I", points: 1),
        Alphabet(string: "N", points: 1),
        Alphabet(string: "S", points: 1),
        Alphabet(string: "T", points: 1),
        Alphabet(string: "E", points: 1),
        Alphabet(string: "K", points: 2),
        Alphabet(string: "L", points: 2),
        Alphabet(string: "O", points: 2),
        Alphabet(string: "Ä", points: 2),
        Alphabet(string: "U", points: 3),
        Alphabet(string: "M", points: 3),
        Alphabet(string: "H", points: 4),
        Alphabet(string: "J", points: 4),
        Alphabet(string: "P", points: 4),
        Alphabet(string: "R", points: 4),
        Alphabet(string: "U", points: 4),
        Alphabet(string: "Y", points: 4),
        Alphabet(string: "V", points: 4),
        Alphabet(string: "W", points: 4),
        Alphabet(string: "D", points: 7),
        Alphabet(string: "Ö", points: 7),
        Alphabet(string: "B", points: 8),
        Alphabet(string: "F", points: 8),
        Alphabet(string: "G", points: 8),
        Alphabet(string: "X", points: 8),
        Alphabet(string: "C", points: 10),
        Alphabet(string: "Z", points: 10),
        Alphabet(string: "Q", points: 10),
    ]

    /**
     Returns all words that have contain all given characters
     - parameter availableCharacters: Available characters
     - parameter matchingWords: Words that match all given criteria
     - parameter notAvailableCharacters: Characters that word should not contain
     - parameter maxWordCount: max word length
     */
    static public func findWords(from dictionary: [String], with availableCharacters: String, matchingWords: inout [String], notAvailableCharacters: String, maxWordCount: Int) {
        var availableCharacters = availableCharacters
        var mustContain = ""
        let upperCase = CharacterSet.uppercaseLetters

        // Figure out what characters word must contain
        for character in availableCharacters.unicodeScalars {
            if upperCase.contains(character) {
                mustContain += character.escaped(asASCII: false).lowercased()
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
                } else if _availableCharacters.contains("_") {
//                    word = word.replacingCharacters(in: index...index, with: String(word[index]).uppercased())
                    // Remove magic character, not available anymore
                    _availableCharacters.remove(at: _availableCharacters.index(of: "_")!)
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
}
