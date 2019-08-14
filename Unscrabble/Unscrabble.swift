//
//  Unscrabble.swift
//  Unscrabble2000
//
//  Created by Jukka Miettinen on 26/01/2018.
//

import Foundation

public class Unscrabble {
    struct Word {
        var alphabets: [Alphabet]
        var string: String
        var points: Int
    }

    struct Alphabet {
        var character: Character
        var points: Int
    }

    static let alphabets = [
        Alphabet(character: "A", points: 1),
        Alphabet(character: "I", points: 1),
        Alphabet(character: "N", points: 1),
        Alphabet(character: "S", points: 1),
        Alphabet(character: "T", points: 1),
        Alphabet(character: "E", points: 1),
        Alphabet(character: "K", points: 2),
        Alphabet(character: "L", points: 2),
        Alphabet(character: "O", points: 2),
        Alphabet(character: "Ä", points: 2),
        Alphabet(character: "U", points: 3),
        Alphabet(character: "M", points: 3),
        Alphabet(character: "H", points: 4),
        Alphabet(character: "J", points: 4),
        Alphabet(character: "P", points: 4),
        Alphabet(character: "R", points: 4),
        Alphabet(character: "U", points: 4),
        Alphabet(character: "Y", points: 4),
        Alphabet(character: "V", points: 4),
        Alphabet(character: "W", points: 4),
        Alphabet(character: "D", points: 7),
        Alphabet(character: "Ö", points: 7),
        Alphabet(character: "B", points: 8),
        Alphabet(character: "F", points: 8),
        Alphabet(character: "G", points: 8),
        Alphabet(character: "X", points: 8),
        Alphabet(character: "C", points: 10),
        Alphabet(character: "Z", points: 10),
        Alphabet(character: "Q", points: 10),
    ]

    /**
     Returns all words that have contain all given characters
     - parameter availableCharacters: Available characters
     - parameter matchingWords: Words that match all given criteria
     - parameter notAvailableCharacters: Characters that word should not contain
     - parameter maxCharCount: max word length
     */
    static public func findWords(from dictionary: [String], with availableCharacters: String, matchingWords: inout [String], notAvailableCharacters: String, maxCharCount: Int) {
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

            var word = word.trimmingCharacters(in: .whitespacesAndNewlines)

            guard word.count >= minCharCount, word.count <= maxCharCount, availableCharacters.count >= word.count else { continue }

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
                    _availableCharacters.remove(at: _availableCharacters.firstIndex(of: word[index])!)
                } else if _availableCharacters.contains("_") {
                    // Highlight character that is replacing magic character
                    word = word.replacingCharacters(in: index...index, with: String(word[index]).uppercased())
                    // Remove magic character, not available anymore
                    _availableCharacters.remove(at: _availableCharacters.firstIndex(of: "_")!)
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
                    // and move on to next word
                    break
                }
            }

            guard matching else { continue }

            // Perfect match found
            if !matchingWords.contains(word) {
                matchingWords.append(word)
            }
        }

        // Sort words by points
        matchingWords = matchingWords.sorted(by: sorterForPoints)
    }

    static func sorterForPoints(this: String, that: String) -> Bool {
        return points(word: this) > points(word: that)
    }

    static func points(word: String) -> Int {
        var sum = 0
        for character in word.unicodeScalars {
            if let points = alphabets.filter({ (alphabet) -> Bool in
                String(alphabet.character).lowercased() == String(character).lowercased()
            }).first?.points {
                sum += points
            }
        }

        return sum
    }
}
