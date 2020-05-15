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
import FirebaseDatabase

class ViewController: UIViewController, FSCalendarDelegate {
    // viewcontroller for calendar section

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var table: UITableView!
    @IBOutlet var curDateLabel: UILabel!
    
    var curDate = Date();
    var curDateString = String();
    
    var eventDict = Dictionary<String, [MyReminder]>();
    var models = [MyReminder](); // point to the event array on current date
    
    var ud = UserDefaults.standard;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // initialize calendar and date
        calendar.delegate = self
        calendar.scope = .month
        let formatter = DateFormatter() //formatter for start time
        formatter.dateFormat = "yyyy-MM-dd"
        curDateString = "\(formatter.string(from: curDate))"
        curDate = formatter.date(from: curDateString)!
        // initialize label
        curDateLabel.text = "Events on \(curDateString):"
        // initialize event table
        table.delegate = self
        table.dataSource = self
//        // access firebase data
//        let ref = Database.database().reference()
//        ref.child("userid/password").setValue(332)
//
        // fetch data from userdefaults
        if ud.value(forKey: "eventDict") != nil{
            print(type(of: ud.value(forKey: "eventDict") as! Dictionary<String, [String]>))
            for (key, value) in ud.value(forKey: "eventDict") as! Dictionary<String, [String]>{
                print(key)
                print(value)
                eventDict[key] = id_array_to_MyReminder(input: value)
            }
            if eventDict[curDateString] != nil{
                models = eventDict[curDateString]!
            }
        }
  
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
//                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.popToViewController(self, animated: true)
//                self.navigationController?.pushViewController(self, animated: true)
                // create new event
                let formatter = DateFormatter() //formatter for start time
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = "\(formatter.string(from: date))"
                let formatter2 = DateFormatter() // formatter for duration
                formatter2.dateFormat = "HH:mm"
                let durationString = "\(formatter2.string(from: duration))"
                let new = MyReminder(title: title, body: body, date: date, duration: duration, identifier: "\(title)|\(body)|\(dateString)|\(durationString)")
                self.models.append(new)
                self.eventDict[self.curDateString] = self.models // save event array to dictionary
                self.table.reloadData()
                // schedule a notification
                 let content = UNMutableNotificationContent()
                 content.title = "Time to focus!"
                 content.sound = .default
                content.body = "\(title) starts now! \(dateString). Duration: \(durationString). \(body)"
                 // trigger: allow a nofitication be sent based on date/time
                 let targetDate = date
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                    if success {
                        print("notification permission allowed")
                    } else if error != nil{
                        print("error requesting notification permission")
                    }
                })
                 let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false) // can repeat
                // request a notification to be added to notification center
                 let request = UNNotificationRequest(identifier: "\(title)|\(body)|\(dateString)|\(durationString)", content: content, trigger: trigger)
                 UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                     if error != nil{
                         print("something went wrong when requesting notification")
                     }
                 })
                //save data to userdefaults
                var udDict = Dictionary<String, [String]>()
                for (key, events) in self.eventDict{
                    udDict[key] = self.get_id_array(input: events)
                }
                self.ud.set(udDict, forKey: "eventDict")
                print(self.ud.value(forKey: "eventDict"))
            } // end DispatchQueue
            
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }// end didTapAdd
   
    
    func id_array_to_MyReminder(input: [String]) -> [MyReminder]{
        // convert id string array to MyReminder struct array
        var result = [MyReminder]()
        for id in input{
            let vars = id.components(separatedBy: "|")
            let title = vars[0]
            let body = vars[1]
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
            let date = dateformatter.date(from: vars[2])!
            print("id_array_toMyReminder title \(title)")
            print("id_array_toMyReminder date \(date)")
            let durationformatter = DateFormatter()
            durationformatter.dateFormat = "HH:mm"
            let duration = durationformatter.date(from: vars[3])!
            print("id_array_toMyReminder duration \(duration)")
            result.append(MyReminder(title: title, body: body, date: date, duration: duration, identifier:id))
        }
        
        return result
    }
    
    func get_id_array(input: [MyReminder]) -> [String] {
        // convert event array to string array
        var result = [String]()
        for event in input{
            result.append(event.identifier)
        }
        return result
    }
    
    
    @IBAction func didTapDone(){
        // dismiss calendar vc when done
        self.dismiss(animated: true, completion: nil)
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
        formatter.dateFormat = "yyyy-MM-dd"
        let string = formatter.string(from: date)
        curDateString = string
        curDate = date
        print("selected curDatestring: \(curDateString)")
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

    
    
    
} // end class ViewController




extension ViewController: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tap an event to edit
        tableView.deselectRow(at: indexPath, animated: true)
        let oldTitle = models[indexPath.row].title
        let oldBody = models[indexPath.row].body
        let oldDate = models[indexPath.row].date
        let oldDuration = models[indexPath.row].duration
        let oldIdentifier = models[indexPath.row].identifier
        
        // show edit event viewcontroller
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
//                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.popToViewController(self, animated: true)
                // create new event
                let formatter = DateFormatter() //formatter for start time
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = "\(formatter.string(from: date))"
                let formatter2 = DateFormatter() // formatter for duration
                formatter2.dateFormat = "HH:mm"
                let durationString = "\(formatter2.string(from: duration))"
                let new = MyReminder(title: title, body: body, date: date, duration: duration, identifier: "\(title)|\(body)|\(dateString)|\(durationString)")
                self.models[indexPath.row] = new // replace the old event
                self.eventDict[self.curDateString] = self.models // save event array to dictionary
                self.table.reloadData()
                // remove the old notification and schedule a new one
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldIdentifier])
                 let content = UNMutableNotificationContent()
                 content.title = "Time to focus!"
                 content.sound = .default
                content.body = "\(title) starts now! \(dateString). Duration: \(durationString). \(body)"
                 let targetDate = date
                 let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                 let request = UNNotificationRequest(identifier: "\(title)|\(body)|\(dateString)|\(durationString)", content: content, trigger: trigger)
                 UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                     if error != nil{
                         print("something went wrong when requesting notification")
                     }
                 })
                //save data to userdefaults
                var udDict = Dictionary<String, [String]>()
                for (key, events) in self.eventDict{
                    udDict[key] = self.get_id_array(input: events)
                }
                self.ud.set(udDict, forKey: "eventDict")
                print(self.ud.value(forKey: "eventDict"))
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
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
            // handle delete (by removing the data from array and updating the tableview)
            let identifier = models[indexPath.row].identifier
            models.remove(at: indexPath.row)
            eventDict[curDateString] = models
            tableView.deleteRows(at: [indexPath], with: .fade)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            print("notification to remove: \(identifier)")
            //save data to userdefaults
            var udDict = Dictionary<String, [String]>()
            for (key, events) in self.eventDict{
                udDict[key] = self.get_id_array(input: events)
            }
            self.ud.set(udDict, forKey: "eventDict")
            print(self.ud.value(forKey: "eventDict"))
        }
    }
    
    
}





struct MyReminder {
    var title: String // event name
    var body: String // event description
    var date: Date //start time
    var duration: Date // event duration
    var identifier: String // event id
    
    
}






