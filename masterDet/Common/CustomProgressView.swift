//
//  CustomProgressView.swift
//  masterDet
//
//  Created by user192220 on 5/17/26.
//

import Foundation
import UIKit

class CustomProgressView: UIProgressView {

    var height:CGFloat = 1.0
    // Do not change this default value,
    // this will create a bug where your progressview wont work for the first x amount of pixel.
    // x being the value you put here.

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size:CGSize = CGSize.init(width: self.frame.size.width, height: height)

        return size
    }
}
