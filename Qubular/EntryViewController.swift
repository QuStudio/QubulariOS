//
//  EntryViewController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit
import Vocabulaire

class EntryViewController: UITableViewController {
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return entry?.natives.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("foreignLexemeHeader", forIndexPath: indexPath) as! ForeignLexemeHeaderTableViewCell
            if let entry = entry {
                cell.setup(with: entry.foreign)
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("nativeCell", forIndexPath: indexPath)
            if let entry = entry {
                let native = entry.nativesByUsage[indexPath.row]
                cell.textLabel?.text = native.lemma.view
            }
            return cell
        }
    }
    
    // MARK: - Gesture recognition
    
//    @IBAction func formsExpandDidPress(sender: UITapGestureRecognizer) {
//        guard let label = sender.view as? UILabel else { return }
//        label.numberOfLines = label.numberOfLines > 0 ? 0 : 1
//        UIView.animateWithDuration(0.2) {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
