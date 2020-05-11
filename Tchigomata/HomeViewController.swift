//
//  HomeViewController.swift
//  Tchigomata
//
//  Created by Yichen on 5/3/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var pet1: UIImageView!
    @IBOutlet weak var pet2: UIImageView!
    @IBOutlet weak var pet3: UIImageView!
    @IBOutlet weak var pet4: UIImageView!
    @IBOutlet weak var pet5: UIImageView!
    @IBOutlet weak var pet6: UIImageView!
    @IBOutlet weak var backArrow: UIButton!
    @IBOutlet weak var forwardArrow: UIButton!
    @IBOutlet weak var noPets: UILabel!
    
    let defaults = UserDefaults.standard
    var limit = 0
    
    override func viewWillAppear(_ animated: Bool) {
        var userPets = [String]()
        let imageViews = [pet1, pet2, pet3, pet4, pet5, pet6]
        
        if(defaults.array(forKey: "pets") != nil) {
            userPets = defaults.array(forKey: "pets") as! [String]
            if(userPets.count > 6)
            {
                limit = 5;
                forwardArrow.isHidden = false;
                forwardArrow.isEnabled = true;
            }
            else {
                limit = userPets.count - 1;
            }
            
            for i in 0 ... limit {
                imageViews[i]?.image = UIImage(named: userPets[i] + ".png")
            }
        }
        else {
            noPets.isHidden = false
        }
        
        // detect if any event is happening now
        print("--------------- viewwillappear")
        let formatter = DateFormatter() //formatter for start time
        formatter.dateFormat = "yyyy-MM-dd"
        let curDateString = "\(formatter.string(from: Date()))"
        if defaults.value(forKey: "eventDict") != nil {
            let eventDict = defaults.value(forKey: "eventDict") as! Dictionary<String, [String]>
            if eventDict[curDateString] != nil{
                let curDict = eventDict[curDateString] as! [String]
                for id in curDict{
                    print("checking event id \(id)")
                    let vars = id.components(separatedBy: "|")
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let start = dateformatter.date(from: vars[2])!
                    let durationformatter = DateFormatter()
                    durationformatter.dateFormat = "HH:mm"
                    let duration = durationformatter.date(from: vars[3])!
                    let calendar = Calendar.current
                    let now = Date()
                    let endcomponents = DateComponents(calendar: calendar, hour: calendar.component(.hour, from:duration), minute: calendar.component(.minute, from:duration))
                    let end = calendar.date(byAdding: endcomponents, to: start)!
//                    print("start: \(start)")
//                    print("end: \(end)")
//                    print("now: \(now)")
                    if start <= now && now <= end { // check within duration
                        print("hit")
                        if defaults.value(forKey: "timed") == nil { // no triggered event record
                            let title = vars[0]
                            let body = vars[1]
                            defaults.set(title, forKey: "nowTitle")
                            defaults.set(body, forKey: "nowBody")
                            defaults.set(start, forKey: "nowStart")
                            defaults.set(duration, forKey: "nowDuration")
                            defaults.set(end, forKey: "nowEnd")
                            var timed = [String]()
                            timed.append(id)
                            // record triggered event and push timing viewcontroller
                            defaults.set(timed, forKey: "timed")
                            guard let vc = storyboard?.instantiateViewController(identifier: "time") as? TimeViewController else{
                                return
                            }
                            navigationController?.pushViewController(vc, animated: true)
                        } else{
                            var timed = defaults.value(forKey: "timed") as! [String]
                            if !timed.contains(id){ // event not triggered before
                                let title = vars[0]
                                let body = vars[1]
                                defaults.set(title, forKey: "nowTitle")
                                defaults.set(body, forKey: "nowBody")
                                defaults.set(start, forKey: "nowStart")
                                defaults.set(duration, forKey: "nowDuration")
                                defaults.set(end, forKey: "nowEnd")
                                // record triggered event and push timing viewcontroller
                                timed.append(id)
                                defaults.set(timed, forKey: "timed")
                                guard let vc = storyboard?.instantiateViewController(identifier: "time") as? TimeViewController else{
                                    return
                                }
                                navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                     } else {
                        print("not hit")
                     }
                }// end for
            }// endif
        } // end if
    }
    
    
    @IBAction func forwardArrowClick(_ sender: Any) {
        backArrow.isEnabled = true
        backArrow.isHidden = false
        
        var userPets = defaults.array(forKey: "pets") as! [String]
        let imageViews = [pet1, pet2, pet3, pet4, pet5, pet6]
        
        // clear image views
        for i in imageViews {
            i?.image = nil
        }
        if(userPets.count - 1 <= limit + 6) {
            for i in limit + 1 ... userPets.count - 1 {
                imageViews[i - limit - 1]?.image = UIImage(named: userPets[i] + ".png")
            }
            forwardArrow.isEnabled = false
            forwardArrow.isHidden = true
        }
        else {
            var floor = limit + 1
            limit += 6
            for i in floor ... limit {
                imageViews[i - floor]?.image = UIImage(named: userPets[i] + ".png")
            }
        }
        
    }
    
    @IBAction func backArrowClick(_ sender: Any) {
        var userPets = defaults.array(forKey: "pets") as! [String]
        let imageViews = [pet1, pet2, pet3, pet4, pet5, pet6]
        if (limit == 5) {
            backArrow.isEnabled = false
            backArrow.isHidden = true
            
            for i in 0 ... limit {
                imageViews[i]?.image = UIImage(named: userPets[i] + ".png")
            }
        }
        else {
            var floor = limit - 5
            for i in floor ... limit {
                imageViews[i - floor]?.image = UIImage(named: userPets[i] + ".png")
            }
            limit -= 6
        }
        forwardArrow.isEnabled = true
        forwardArrow.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
       backgroundImage.image = UIImage(named: "616673.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
       self.view.insertSubview(backgroundImage, at: 0)
        print("-------viewdidload")

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
