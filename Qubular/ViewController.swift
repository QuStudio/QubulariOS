//
//  ViewController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit
import Vocabulaire

class ViewController: UIViewController, VocabularyControllerUser {

    var vocabulary = Vocabulary()

    weak var vocabularyController: VocabularyController!
    var dataUpdateAvailable = false

    @IBOutlet weak var testLabel: UILabel!

    let notificationCenter = NSNotificationCenter.defaultCenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(vocabularyController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testButtonDidPress(sender: UIButton) {
        vocabularyController.prepareVocabulary { [weak self] in
            self?.slovarFetchingDidComplete()
        }
    }

    func updateData() {
        self.testLabel.text = String(vocabulary)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            print("No identifier")
            return
        }
        switch identifier {
        case "entryDetail":
            if let entryViewController = segue.destinationViewController as? EntryViewController {
                entryViewController.entry = vocabulary.first!
            }
        default:
            return
        }
    }

}

extension ViewController {
    
    func slovarFetchingDidComplete() {
        onMainQueue {
//            if let vocabulary = self.vocabularyController.cache.vocabulary {
//                self.vocabulary = vocabulary
//                self.updateData()
//            }
        }
    }
    
}
