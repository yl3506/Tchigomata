//
//  ViewController.swift
//  Tchigomata
//
//  Created by Yichen on 4/17/20.
//  Copyright © 2020 NYU. All rights reserved.
//
import FSCalendar
import UserNotifications
import UIKit

class ViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var table: UITableView!
    @IBOutlet var curDateLabel: UILabel!
    
    var models = [MyReminder]() // point to the event array on current date
    var curDateString = String();
    var curDate = Date();
    
    let userDefaults = UserDefaults.standard;
    var eventDict = Dictionary<String, [MyReminder]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize calendar
        calendar.delegate = self
        calendar.scope = .week
        // initialize event table
        table.delegate = self
        table.dataSource = self

    }
    
    @IBAction func didTapAdd(){
        // show add viewcontroller
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
            
        vc.title = "New Event"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date, duration in
            // dismiss Add vc when complete
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                // create new event
                let formatter = DateFormatter() //formatter for start time
                formatter.dateFormat = "EEEE, MM-dd-YYYY, HH:mm a"
                let startString = "\(formatter.string(from: date))"
                let new = MyReminder(title: title, body: body, date: date, duration: duration, identifier: "\(title)_start_\(startString)")
                self.models.append(new)
                self.eventDict[self.curDateString] = self.models // save event array to dictionary
                self.table.reloadData()
                // schedule a notification
                 let content = UNMutableNotificationContent()
                 content.title = "Time to focus!"
                 content.sound = .default
                let formatter2 = DateFormatter() // formatter for duration
                formatter2.dateFormat = "HH:mm"
                content.body = "\(title) starts now! \(startString). Duration: \(formatter2.string(from: duration)). \(body)"
                 // trigger: allow a nofitication be sent based on date/time
                 let targetDate = date
                 let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false) // can repeat
                // request a notification to be added to notification center
                 let request = UNNotificationRequest(identifier: "\(title)_start_\(startString)", content: content, trigger: trigger)
                 UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                     if error != nil{
                         print("something went wrong when requesting notification")
                     }
                 })
            } // end DispatchQueue
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
   
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// testing
    @IBAction func didTabTest(){
        // fire test notification in a few seconds
        // get user permission to allow notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                // schedule test
                self.scheduleTest()
            }
            else if error != nil{
                // raise error
                print("error: button for testing push notification")
            }
        })
    }
    func scheduleTest(){
        // schedule a test notification in a few seconds
        // content parameter: title, body, sound, etc
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "This is a test notification triggered automatically after ten seconds after you hitted the test button"
        // trigger: allow a nofitication be sent based on date/time
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false) // can repeat
       // request a notification to be added to notification center
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil{
                print("something went wrong when requesting notification")
            }
        })
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// end testing

    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // when hit a date on calendar
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        curDateString = string
        curDate = date
        print("curDatestring: \(curDateString)")
        // change label content
        curDateLabel.text = "Events on \(string):"
        // switch to reminder/event array for that date
        if eventDict.keys.contains(curDateString){
            models = eventDict[curDateString] as! [MyReminder]
        } else{
            models = [MyReminder]()
        }
        table.reloadData()
    }

}




extension ViewController: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tap an event to edit
        tableView.deselectRow(at: indexPath, animated: true)
        let oldTitle = models[indexPath.row].title
        let oldBody = models[indexPath.row].body
        let oldDate = models[indexPath.row].date
        let oldDuration = models[indexPath.row].duration
        let oldIdentifier = models[indexPath.row].identifier
        
        // show edit viewcontroller
        guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else{
            return
        }
        vc.title = "Edit Event"
        vc.navigationItem.largeTitleDisplayMode = .never
        EditViewController.oldEvent.oldTitle = oldTitle
        EditViewController.oldEvent.oldBody = oldBody
        EditViewController.oldEvent.oldDate = oldDate
        EditViewController.oldEvent.oldDuration = oldDuration
        EditViewController.oldEvent.oldIdentifier = oldIdentifier
        
        vc.completion = {title, body, date, duration in
            // dismiss Add vc when complete
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                // create new event
                let formatter = DateFormatter() //formatter for start time
                formatter.dateFormat = "EEEE, MM-dd-YYYY, HH:mm a"
                let startString = "\(formatter.string(from: date))"
                let new = MyReminder(title: title, body: body, date: date, duration: duration, identifier: "\(title)_start_\(startString)")
                self.models[indexPath.row] = new // replace the old event
                self.eventDict[self.curDateString] = self.models // save event array to dictionary
                self.table.reloadData()
                // replace the old notification
                 let content = UNMutableNotificationContent()
                 content.title = "Time to focus!"
                 content.sound = .default
                let formatter2 = DateFormatter() // formatter for duration
                formatter2.dateFormat = "HH:mm"
                content.body = "\(title) starts now! \(startString). Duration: \(formatter2.string(from: duration)). \(body)"
                 let targetDate = date
                 let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                 let request = UNNotificationRequest(identifier: "\(oldIdentifier)", content: content, trigger: trigger)
                 UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                     if error != nil{
                         print("something went wrong when requesting notification")
                     }
                 })
            } // end DispatchQueue
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}




extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return table row number
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // render each cell in table
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        // convert date to string
        let date = models[indexPath.row].date
        let duration = models[indexPath.row].duration
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "EEEE, MM-dd-YYYY, HH:mm a"
        formatter2.dateFormat = "HH:mm"
        cell.detailTextLabel?.text = "Start: \(formatter.string(from: date)). Duration \(formatter2.string(from: duration))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // enable swipping action
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) { // swipe to delete cell
            // handle delete (by removing the data from your array and updating the tableview)
            let identifier = models[indexPath.row].identifier
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            print("notification to remove: \(identifier)")
        }
    }
    
    
}





struct MyReminder{
    let title: String // event name
    let body: String // event description
    let date: Date //start time
    let duration: Date // event duration
    let identifier: String // event id
    
}






