//
//  EntriesTableViewController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 14.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire
import UIKit

class EntriesTableViewController: UITableViewController, VocabularyControllerUser {
    
    var searchController: UISearchController!
    var filteredEntries: [Entry] = []
    
    weak var vocabularyController: VocabularyController!
    var entries: [Entry] = []
    
    var currentDataSource: [Entry] {
        if searchController.active {
            return filteredEntries
        } else {
            return entries
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        clearsSelectionOnViewWillAppear = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .blackColor()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        entries = vocabularyController.cache.vocabulary ?? []
        updateDataSource()
    }
    
    func updateDataSource(necessaryUpdate isNecessary: Bool = false) {
        let completion = { [weak self] in
            print("Gotcha")
            onMainQueue {
                if let vocabulary = self?.vocabularyController.cache.vocabulary {
                    self?.entries = vocabulary
                    self?.tableView.reloadData()
                }
                self?.refreshControl?.endRefreshing()
            }
        }
        if isNecessary {
            vocabularyController.updateVocabulary(completion)
        } else {
            vocabularyController.prepareVocabulary(completion)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    let foreignPresenter = ForeignLexemePresenter()
    let nativesBriefPresenter = NativesBriefPresenter()
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as! EntryTableViewCell
        let entry = currentDataSource[indexPath.row]
        foreignPresenter.present(entry.foreign, on: cell)
        nativesBriefPresenter.present(entry, on: cell)
        return cell
    }
    
    private var selectedEntry: Entry?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry = currentDataSource[indexPath.row]
        selectedEntry = entry
        searchController.searchBar.resignFirstResponder()
        performSegueWithIdentifier("entryDetail", sender: self)
    }
    
    @IBAction func refreshingDidBegin(sender: UIRefreshControl) {
        updateDataSource(necessaryUpdate: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "entryDetail":
            if let destination = segue.destinationViewController as? protocol<EntryRepresenting, ForeignPresenterUser> {
                destination.entry = selectedEntry
                destination.foreignPresenter = foreignPresenter
            }
            
        default:
            return
        }
    }
    
}

extension EntriesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension EntriesTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let whitespaceCharacterSer = NSCharacterSet.whitespaceCharacterSet()
        let query = searchController.searchBar.text!.stringByTrimmingCharactersInSet(whitespaceCharacterSer)
        if query.characters.isEmpty {
            filteredEntries = entries
        } else {
            filteredEntries = entries.lazy.filter({ $0.isSuited(forString: query) }).sort({ $0.suitRate(forString: query) > $1.suitRate(forString: query) })
        }
        tableView.reloadData()
    }
}
