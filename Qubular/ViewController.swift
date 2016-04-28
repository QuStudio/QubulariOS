//
//  ViewController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit
import Vocabulaire

class ViewController: UIViewController, SlovarUpdateObserver, UpdatingOnAppear {

    var vocabulary = Vocabulary()

    weak var networkController: SlovarNetworkController!
    var dataUpdateAvailable = false

    @IBOutlet weak var testLabel: UILabel!

    let notificationCenter = NSNotificationCenter.defaultCenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(networkController)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notificationCenter.removeObserver(self, name: SlovarNetworkController.slovarFetchingCompletedNotification, object: networkController)
        networkController.fetchingDelegate = self
        updateIfNewDataAvailable()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        notificationCenter.addObserver(self, selector: #selector(slovarDidUpdate(_:)), name: SlovarNetworkController.slovarFetchingCompletedNotification, object: networkController)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        testLabel.textColor = .redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testButtonDidPress(sender: UIButton) {
        networkController.fetchSlovar()
    }

    func slovarDidUpdate(notification: NSNotification) {
        if let vocabulary = networkController.cache.vocabulary {
            self.vocabulary = vocabulary
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

extension ViewController: SlovarFetchingDelegate {
    
    func slovarFetchingCompleted() {
        onMainQueue {
            if let vocabulary = self.networkController.cache.vocabulary {
                self.vocabulary = vocabulary
                self.updateData()
            }
        }
    }
    
}
