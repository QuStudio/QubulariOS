//
//  ForeignLexemeHeaderTableViewCell.swift
//  Qubular
//
//  Created by Oleg Dreyman on 11.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import UIKit

class ForeignLexemeHeaderTableViewCell: UITableViewCell, ForeignLexemePresenter {
    
    @IBOutlet weak var foreignLexemeFormsLabel: UILabel!
    @IBOutlet weak var foreignLexemeLemmaLabel: UILabel!
    // @IBOutlet weak var permissibilityLabel: UILabel!
    @IBOutlet weak var permissibilityIndicator: UIView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var foreignLexemeMeaningLabel: UILabel!
    
}
