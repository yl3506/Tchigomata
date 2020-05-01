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
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func didTapAdd(){
        // show add viewcontroller
        
    }
    
    @IBAction func didTabTest(){
        // fire test notification in a few seconds
        // get user permission to allow notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                // schedule test
                self.scheduleTest()
            }
            else if let error = error{
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
    

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY at h:mm a"
        let string = formatter.string(from: date)
        print("\(string)")
    }

}



extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        return cell
    }
}

struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}






