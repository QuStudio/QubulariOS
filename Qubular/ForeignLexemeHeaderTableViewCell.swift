//
//  ForeignLexemeHeaderTableViewCell.swift
//  Qubular
//
//  Created by Oleg Dreyman on 11.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import UIKit

class ForeignLexemeHeaderTableViewCell: UITableViewCell, FullForeignLexemePresenting {
    
    @IBOutlet weak var foreignLexemeFormsLabel: UILabel!
    @IBOutlet weak var foreignLexemeLemmaLabel: UILabel!
    // @IBOutlet weak var permissibilityLabel: UILabel!
    @IBOutlet weak var permissibilityIndicator: IndicatorView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var foreignLexemeMeaningLabel: UILabel!
    
}
