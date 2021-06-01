//
//  Extension.swift
//  masterDet
//
//  Created by user192220 on 5/17/27
//

import Foundation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension String
{
    var isNumeric: Bool
    {
        let range = self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        return (range == nil)
    }
}
