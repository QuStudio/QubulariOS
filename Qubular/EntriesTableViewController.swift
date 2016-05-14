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
    
    weak var vocabularyController: VocabularyController!
    var entries: [Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = vocabularyController.cache.vocabulary ?? []
        vocabularyController.prepareVocabulary { [weak self] in
            onMainQueue {
                if let vocabulary = self?.vocabularyController.cache.vocabulary {
                    self?.entries = vocabulary
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath)
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.foreign.lemma.view
        cell.detailTextLabel?.text = entry.nativesByUsage.first?.lemma.view
        return cell
    }
    
    private var selectedEntry: Entry?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry = entries[indexPath.row]
        selectedEntry = entry
        performSegueWithIdentifier("entryDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "entryDetail":
            if let entryViewController = segue.destinationViewController as? EntryViewController {
                entryViewController.entry = selectedEntry
            }
            
        default:
            return
        }
    }
    
}
