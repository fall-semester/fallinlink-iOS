//
//  InsetTextField.swift
//  FallInLink_Example
//
//  Created by 이전희 on 11/7/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    private var insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
    func setInsets(insets: UIEdgeInsets) {
        self.insets = insets
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
