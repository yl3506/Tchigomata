//
//  TimeViewController.swift
//  Tchigomata
//
//  Created by Yichen on 5/6/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
var ud = UserDefaults.standard

class TimeViewController: UIViewController {
    @IBOutlet weak var giveup: UIButton!
    @IBAction func giveupaction(_ sender: Any) {
        giveUp()
        giveup.isEnabled = false
    }
    
    @IBOutlet var complete_label: UILabel!
    @IBOutlet var title_label: UILabel!
    @IBOutlet var body_label: UILabel!
    @IBOutlet var time_label: UILabel!
            var ud = UserDefaults.standard
            var coins_tohave = Int()
            
            static var didExit = false
            static var screenOff = false
            let timeLeftShapeLayer = CAShapeLayer()
            let bgShapeLayer = CAShapeLayer()
            var timeLeft: TimeInterval = 10
            var endTime: Date?
            var timeLabel =  UILabel()
            var timer = Timer()
            let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
            func drawBgShape() {
                bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                    100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
                bgShapeLayer.strokeColor = UIColor.white.cgColor
                bgShapeLayer.fillColor = UIColor.clear.cgColor
                bgShapeLayer.lineWidth = 15
                view.layer.addSublayer(bgShapeLayer)
            }
            func drawTimeLeftShape() {
                timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                    100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
                timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
                timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
                timeLeftShapeLayer.lineWidth = 15
                view.layer.addSublayer(timeLeftShapeLayer)
            }
            func addTimeLabel() {
                timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
                timeLabel.textAlignment = .center
                timeLabel.text = timeLeft.times
                view.addSubview(timeLabel)
            }
            override func viewDidLoad() {
                self.navigationItem.setHidesBackButton(true, animated: false)
                let gacha = ud.integer(forKey: "coins")
                ud.set(gacha, forKey: "coins")
                super.viewDidLoad()
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                    backgroundImage.image = UIImage(named: "616673.png")
                     backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
                    self.view.insertSubview(backgroundImage, at: 0)
                TimeViewController.didExit = false
                TimeViewController.screenOff = false
                drawBgShape()
                drawTimeLeftShape()
                addTimeLabel()
               
                // retieve event info and calculate duration in seconds
                let end = ud.value(forKey: "nowEnd") as! Date
                let now = Date()
                let start = ud.value(forKey: "nowStart") as! Date
                let finalSeconds: Double = Double(end.timeIntervalSince(now))
                coins_tohave = Int(floor(finalSeconds/Double(3600))) // computer number of coins gained
                print(coins_tohave)
                title_label.text = ud.value(forKey: "nowTitle") as! String
                body_label.text = ud.value(forKey: "nowBody") as! String
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                time_label.text = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
                timeLeft = finalSeconds
                strokeIt.fromValue = 0
                strokeIt.toValue = 1
                strokeIt.duration = finalSeconds
                
                
                timeLeftShapeLayer.add(strokeIt, forKey: nil)
               
                endTime = Date().addingTimeInterval(timeLeft)
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimeViewController.updateTime), userInfo: nil, repeats: true)
                CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), Unmanaged.passUnretained(self).toOpaque(), displayStatusChangedCallback, "com.apple.springboard.lockcomplete" as CFString, nil, .deliverImmediately)
            }
            @objc func updateTime() {
            var gachaCoins = ud.integer(forKey: "coins")
            if TimeViewController.didExit {
                       resetPage()
                       if !TimeViewController.screenOff {
                           resetPage()
                           return
                       }
                   }
                
            if timeLeft > 0 {
                timeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = timeLeft.times
                } else {
                timeLabel.text = "00:00"
                timer.invalidate()
                gachaCoins = gachaCoins + coins_tohave
                complete_label.text = "Congratulations! Event Completed! #Coins gained: \(coins_tohave)"
                self.navigationItem.setHidesBackButton(false, animated: true)
                ud.set(gachaCoins, forKey: "coins")
                print(gachaCoins)
                
                }
            }
        
        func resetPage() {
            self.navigationItem.setHidesBackButton(false, animated: true)
        timer.invalidate()
        timeLabel.text = "00:00:00"
            let alertController = UIAlertController(title: "You started to use your phone!", message: "Your time has been reset", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true) {}
        }
    func giveUp(){
           timer.invalidate()
        timeLeftShapeLayer.removeFromSuperlayer()
           timeLabel.text = "00:00:00"
           let alertController = UIAlertController(title: "Oh no!", message: "You gave up. Try next time!", preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
           alertController.addAction(cancelAction)
           
           self.present(alertController, animated: true) {}
        self.navigationItem.setHidesBackButton(false, animated: true)
       }
    
   


        
    }

    

    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {
            return
        }
        TimeViewController.screenOff = true
    }

