//
//  SetTimeViewController.swift
//  ScoreBoard
//
//  Created by BarryKao on 2019/11/4.
//  Copyright © 2019 BarryKao. All rights reserved.
//

import UIKit

protocol SetTimeViewControllerDelegate: class {
    func setTimeAction(hour: String?, minute: String?, second: String?)
}

class SetTimeViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    var delegate: SetTimeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hourTextField.delegate = self
        self.minuteTextField.delegate = self
        self.secondTextField.delegate = self
        self.saveButton.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        self.setEditing(editing, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        checkText(textField: textField, controller: self)

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkText(textField: textField, controller: self)

        if self.hourTextField.text == "" && self.minuteTextField.text == "" && self.secondTextField.text == ""{
            self.saveButton.isEnabled = false
        }
        
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
      
        checkText(textField: self.hourTextField, controller: self)
        checkText(textField: self.minuteTextField, controller: self)
        checkText(textField: self.secondTextField, controller: self)

//        blankTextField(textField: self.hourTextField)
//        blankTextField(textField: self.minuteTextField)
//        blankTextField(textField: self.secondTextField)
        
        delegate?.setTimeAction(hour: self.hourTextField.text, minute: self.minuteTextField.text, second: self.secondTextField.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func checkText(textField: UITextField, controller: UIViewController){
        
        guard let text = textField.text else {return}
        guard let num = Int(text) else {return}
        if num >= 60 {
            alertAction(controller: controller, title: "Error!", message: "The range is 0~59.")
            textField.text = ""
        
        }else {
            self.saveButton.isEnabled = true
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
