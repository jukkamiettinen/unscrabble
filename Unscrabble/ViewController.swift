//
//  ViewController.swift
//  ScrabbleHelper
//
//  Created by Jukka Miettinen on 16/01/2018.
//

import UIKit

/// Dictionary stored locally, faster to fetch
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

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let searchController = UISearchController(searchResultsController: nil)
    var dictionary: [String] = []
    var matchingWords: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI test helpers
        view.accessibilityIdentifier = "mainView"
        tableView.accessibilityIdentifier = "table--possibleWordsTableView"

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none

        if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                self.dictionary = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingWords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let matchingWord: String
        matchingWord = matchingWords[indexPath.row]
        cell.textLabel!.text = matchingWord
        return cell
    }

    /**
     Triggered when table cell is selected. Removes focus from search bar.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Search Bar

    /**
     Triggered when search text changes. Reloads table view's data.
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }

        matchingWords = []
        Unscrabble.findWords(from: dictionary, with: text, matchingWords: &matchingWords, notAvailableCharacters: "", maxWordCount: text.count)

        tableView.reloadData()
    }

    /**
     Triggered when search button is clicked. Removes focus from search bar.
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

