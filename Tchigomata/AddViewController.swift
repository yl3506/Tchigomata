//
//  AddViewController.swift
//  Tchigomata
//
//  Created by Yichen on 4/30/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign delegate
        titleField.delegate = self
        bodyField.delegate = self
        // add save button in the add event vc
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))

    }
    
    
    
    @objc func didTapSaveButton(){
        // tap save button, save event to table
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty{
            
            let targetDate = datePicker.date
            // pass in completion handler from previous vc to get event content
            completion?(titleText, bodyText, targetDate)
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss the keyboard when user hits return
        textField.resignFirstResponder()
        return true
    }
    
    
    
}





