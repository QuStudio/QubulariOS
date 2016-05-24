//
//  NSAttributedString.swift
//  Qubular
//
//  Created by Oleg Dreyman on 24.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import UIKit

protocol StringAttribute {
    var attribute: (name: String, value: AnyObject) { get }
}

private extension StringAttribute {
    var flatAttribute: [String: AnyObject] {
        return [attribute.name: attribute.value]
    }
}

extension SequenceType where Generator.Element == StringAttribute {
    var attributes: [String: AnyObject] {
        var attrs: [String: AnyObject] = [:]
        for (name, attribute) in self.map({ $0.attribute }) {
            attrs[name] = attribute
        }
        return attrs
    }
}

protocol StringAttributeAppliable {
    func applied(with attribute: StringAttribute) -> NSAttributedString
    func applied(with attributes: [StringAttribute]) -> NSAttributedString
}

func * (lhs: StringAttributeAppliable, rhs: StringAttribute) -> NSAttributedString {
    return lhs.applied(with: rhs)
}

func * (lhs: StringAttributeAppliable, rhs: [StringAttribute]) -> NSAttributedString {
    return lhs.applied(with: rhs)
}

func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let mutable = NSMutableAttributedString(attributedString: lhs)
    mutable.appendAttributedString(rhs)
    return NSAttributedString(attributedString: mutable)
}

extension String: StringAttributeAppliable {
    func applied(with attribute: StringAttribute) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attribute.flatAttribute)
    }
    func applied(with attributes: [StringAttribute]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes.attributes)
    }
}

extension StringAttributeAppliable where Self: NSAttributedString {
    func applied(with attribute: StringAttribute) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.addAttribute(attribute.attribute.name, value: attribute.attribute.value, range: NSRange(location: 0, length: length))
        return NSAttributedString(attributedString: mutable)
    }
    func applied(with attributes: [StringAttribute]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        mutable.addAttributes(attributes.attributes, range: NSRange(location: 0, length: length))
        return NSAttributedString(attributedString: mutable)
    }
}

extension NSAttributedString: StringAttributeAppliable { }

extension UIFont: StringAttribute {
    var attribute: (name: String, value: AnyObject) {
        return (NSFontAttributeName, self)
    }
}

extension NSTextAttachment: StringAttribute {
    var attribute: (name: String, value: AnyObject) {
        return (NSAttachmentAttributeName, self)
    }
}

enum Attribute: StringAttribute {

    case BackgroundColor(UIColor)
    case BaselineOffset(Double)
    case Expansion(Double)
    case ForegroundColor(UIColor)
    case Kern(Double)
    case Ligature(Int)
    case Obliqueness(Double)
    case StrikethroughColor(UIColor)
    
    enum Stroke: StringAttribute {
        case Color(UIColor)
        case Width(Double)
        
        var attribute: (name: String, value: AnyObject) {
            switch self {
            case .Color(let color):
                return (NSStrokeColorAttributeName, color)
            case .Width(let width):
                return (NSStrokeWidthAttributeName, width)
            }
        }
    }
    
    case TextEffect(String)
    case UnderlineColor(UIColor)
    
    var attribute: (name: String, value: AnyObject) {
        switch self {
        case .BackgroundColor(let color):
            return (NSBackgroundColorAttributeName, color)
        case .BaselineOffset(let offset):
            return (NSBaselineOffsetAttributeName, offset)
        case .Expansion(let exp):
            return (NSExpansionAttributeName, exp)
        case .ForegroundColor(let color):
            return (NSForegroundColorAttributeName, color)
        case .Kern(let kern):
            return (NSKernAttributeName, kern)
        case .Ligature(let ligature):
            return (NSLigatureAttributeName, ligature)
        case .Obliqueness(let obliqueness):
            return (NSObliquenessAttributeName, obliqueness)
        case .StrikethroughColor(let color):
            return (NSStrikethroughColorAttributeName, color)
        case .TextEffect(let effect):
            return (NSTextEffectAttributeName, effect)
        case .UnderlineColor(let color):
            return (NSUnderlineColorAttributeName, color)
        }
    }
    
}

let attributed = "String" * Attribute.BackgroundColor(.blackColor()) * Attribute.ForegroundColor(.whiteColor())

