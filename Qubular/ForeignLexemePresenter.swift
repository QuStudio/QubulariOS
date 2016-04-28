//
//  ForeignLexemePresenter.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire
import UIKit

protocol ForeignLexemePresenter {

    weak var foreignLexemeLemmaLabel: UILabel! { get set }
    weak var foreignLexemeFormsLabel: UILabel! { get set }
    weak var permissibilityLabel: UILabel! { get set }
    weak var permissibilityIndicator: UIView! { get set }
    weak var originLabel: UILabel! { get set }
    weak var foreignLexemeMeaningLabel: UILabel! { get set }

}

extension ForeignLexemePresenter where Self: UIViewController {
    
    func setup(with foreignLexeme: ForeignLexeme) {
        foreignLexemeLemmaLabel.text = foreignLexeme.lemma.view
        foreignLexemeFormsLabel.text = foreignLexeme.forms.isEmpty ?
            "" : "(\(foreignLexeme.forms.map({ $0.view }).joinWithSeparator(", ")))"
        permissibilityLabel.text = foreignLexeme.permissibility.russian
        permissibilityIndicator.layer.cornerRadius = permissibilityLabel.frame.height / 2
        permissibilityIndicator.backgroundColor = foreignLexeme.permissibility.indicatorColor
        originLabel.text = foreignLexeme.origin.view
        foreignLexemeMeaningLabel.text = foreignLexeme.meaning
    }

}

private extension ForeignLexeme.Permissibility {
    
    var russian: String {
        switch self {
        case .NotAllowed:
            return "Непозволительно"
        case .NotRecommended:
            return "Не рекомендуется"
        case .GenerallyAllowed:
            return "В целом позволительно"
        case .Allowed:
            return "Позволительно"
        }
    }

    var indicatorColor: UIColor {
        switch self {
        case .NotAllowed:
            return UIColor(red: 128/255, green: 0, blue: 0, alpha: 1.0)
        case .NotRecommended:
            return UIColor(red: 211/255, green: 84/255, blue: 0, alpha: 1.0)
        case .GenerallyAllowed:
            return UIColor(red: 245/255, green: 215/255, blue: 110/255, alpha: 1.0)
        case .Allowed:
            return UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1.0)
        }
    }

}
