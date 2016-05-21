//
//  IndicatorView.swift
//  Qubular
//
//  Created by Oleg Dreyman on 20.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import UIKit

@IBDesignable class IndicatorView: UIView {

    enum Shape {
        case Circle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var shape: Shape = .Circle
    @IBInspectable var color: UIColor = .redColor()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillEllipseInRect(context, rect)
    }

}
