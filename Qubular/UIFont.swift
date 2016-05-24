//
//  UIFont.swift
//  Qubular
//
//  Created by Oleg Dreyman on 24.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func bitter(ofSize size: Int) -> Self {
        return self.init(name: "Bitter-Regular", size: CGFloat(size))!
    }
    
    static func italitBitter(ofSize size: Int) -> Self {
        return self.init(name: "Bitter-Italic", size: CGFloat(size))!
    }
    
}
