//
//  EditViewController.swift
//  Tchigomata
//
//  Created by Yichen on 5/2/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
// viewcontroller to edit an event
    
 @IBOutlet var titleField: UITextField! // event name
 @IBOutlet var bodyField: UITextField! // event type
 @IBOutlet var datePicker: UIDatePicker!
 @IBOutlet var durationPicker: UIDatePicker! // event duration
 
 public var completion: ((String, String, Date, Date) -> Void)?
    
struct oldEvent{ // old event info
    static var oldTitle = String()
    static var oldBody = String()
    static var oldDate = Date() // start time
    static var oldDuration = Date()
    static var oldIdentifier = String()
}
    
 override func viewDidLoad() {
     super.viewDidLoad()
     // assign delegate
     titleField.delegate = self
     bodyField.delegate = self
     // add save button in the add event vc
     navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    // display old event info
    titleField.text = oldEvent.oldTitle
    bodyField.text = oldEvent.oldBody
    datePicker.date = oldEvent.oldDate
    durationPicker.date = oldEvent.oldDuration
    print("old identifier to be removed: \(oldEvent.oldIdentifier)")
 }
 
 
 
 @objc func didTapSaveButton(){
     // tap save button, save event to table
     if let titleText = titleField.text, !titleText.isEmpty,
         let bodyText = bodyField.text {
         
         let targetDate = datePicker.date
         let durationDate = durationPicker.date
         // pass in completion handler from previous vc to get event content
         completion?(titleText, bodyText, targetDate, durationDate)
     }
     
 }
 
 
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     // dismiss the keyboard when user hits return
     textField.resignFirstResponder()
     return true
 }

}
