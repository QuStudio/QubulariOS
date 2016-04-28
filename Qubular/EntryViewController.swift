//
//  EntryViewController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit
import Vocabulaire

class EntryViewController: UIViewController, ForeignLexemePresenter {
    
    var entry: Entry?
    
    @IBOutlet weak var foreignLexemeFormsLabel: UILabel!
    @IBOutlet weak var foreignLexemeLemmaLabel: UILabel!
    @IBOutlet weak var permissibilityLabel: UILabel!
    @IBOutlet weak var permissibilityIndicator: UIView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var foreignLexemeMeaningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entry = entry {
            setup(with: entry.foreign)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Gesture recognition
    
    @IBAction func formsExpandDidPress(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        label.numberOfLines = label.numberOfLines > 0 ? 0 : 1
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
