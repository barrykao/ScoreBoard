//
//  extension.swift
//  ScoreBoard
//
//  Created by BarryKao on 2020/2/14.
//  Copyright © 2020 BarryKao. All rights reserved.
//

import Foundation
import UIKit


func textFieldBoard(textField: UITextField){
    textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.black.cgColor
//        textField.layer.backgroundColor = UIColor.clear.cgColor
    textField.layer.cornerRadius = 10.0
    textField.layer.shadowColor = UIColor.black.cgColor
    textField.layer.shadowRadius = 2
    textField.layer.shadowOffset = CGSize(width: 2, height: 2)
    textField.layer.shadowOpacity = 0.3
    
}
func buttonInit(button: UIButton) {
    
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.backgroundColor = UIColor.clear.cgColor
    button.layer.cornerRadius = 10.0
//        button.backgroundColor = UIColor.blue
//        button.tintColor = UIColor.white
    
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowRadius = 2
    button.layer.shadowOffset = CGSize(width: 2, height: 2)
    button.layer.shadowOpacity = 0.3
    
    
}
