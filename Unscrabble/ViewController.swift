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
let minCharCount = 2

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

    /**
     Called before each cell is drawn. Populated with matching words.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let matchingWord: String
        matchingWord = matchingWords[indexPath.row]
        cell.textLabel!.text = matchingWord
        cell.detailTextLabel!.text = String(Unscrabble.points(word: matchingWord)) + " p."
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
        Unscrabble.findWords(from: dictionary, with: text, matchingWords: &matchingWords, notAvailableCharacters: "", maxCharCount: text.count)

        tableView.reloadData()
    }

    /**
     Triggered when search button is clicked. Removes focus from search bar.
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

