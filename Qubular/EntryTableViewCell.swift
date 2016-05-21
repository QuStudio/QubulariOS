//
//  EntryTableViewCell.swift
//  Qubular
//
//  Created by Oleg Dreyman on 20.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell, ForeignLexemePresenting, NativesBriefPresenting {

    @IBOutlet weak var foreignLexemeLemmaLabel: UILabel!
    @IBOutlet weak var permissibilityIndicator: IndicatorView!
    @IBOutlet weak var nativesLabel: UILabel!
    
}
