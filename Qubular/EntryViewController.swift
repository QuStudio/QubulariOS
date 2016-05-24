//
//  EntryViewController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit
import Vocabulaire

class EntryViewController: UITableViewController, EntryRepresenting, ForeignPresenterUser {
    
    // MARK: - Outlets
    
    @IBOutlet weak var addedByLabel: UILabel!
    
    // MARK: - Core
    
    var entry: Entry?
    lazy var nativePresenter: NativePresenter? = self.entry.map({ NativePresenter(natives: $0.nativesByUsage) })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = entry?.foreign.lemma.view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // registering nib
        let nib = UINib(nibName: "NativesHeaderView", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "nativeHeader")
        
        addedByLabel.text = entry?.author.map({ "Добавлено пользователем \($0.username)" }) ?? ""
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 25
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return 35
        default:
            return UITableViewAutomaticDimension
        }
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("nativeHeader") as? NativesHeaderView
            header?.titleLabel.text = "Альтернативы:"
            let bitter = UIFont.bitter(ofSize: 15)
            header?.titleLabel.font = bitter
            return header
        default:
            return nil
        }
    }
    
    var foreignPresenter: ForeignLexemePresenter!
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("foreignLexemeHeader", forIndexPath: indexPath) as! ForeignLexemeHeaderTableViewCell
            if let entry = entry {
                foreignPresenter.present(entry.foreign, on: cell)
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("nativeCell", forIndexPath: indexPath) as! NativeTableViewCell
            nativePresenter?.present(nativeAt: indexPath.row, on: cell)
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
