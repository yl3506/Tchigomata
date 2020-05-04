//
//  TestTimerViewController.swift
//  Tchigomata
//
//  Created by Zhongheng Sun on 5/3/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class TestTimerViewController: UIViewController {
        static var didExit = false
        static var screenOff = false
            var ud = UserDefaults.standard
            let timeLeftShapeLayer = CAShapeLayer()
            let bgShapeLayer = CAShapeLayer()
            var timeLeft: TimeInterval = 10
            var endTime: Date?
            var timeLabel =  UILabel()
            var timer = Timer()
            let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
            func drawBgShape() {
                bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                    100, startAngle: -90.degreesToRadianst, endAngle: 270.degreesToRadianst, clockwise: true).cgPath
                bgShapeLayer.strokeColor = UIColor.white.cgColor
                bgShapeLayer.fillColor = UIColor.clear.cgColor
                bgShapeLayer.lineWidth = 15
                view.layer.addSublayer(bgShapeLayer)
            }
            func drawTimeLeftShape() {
                timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                    100, startAngle: -90.degreesToRadianst, endAngle: 270.degreesToRadianst, clockwise: true).cgPath
                timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
                timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
                timeLeftShapeLayer.lineWidth = 15
                view.layer.addSublayer(timeLeftShapeLayer)
            }
            func addTimeLabel() {
                timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
                timeLabel.textAlignment = .center
                timeLabel.text = timeLeft.time
                view.addSubview(timeLabel)
            }
            override func viewDidLoad() {
                let gacha = ud.integer(forKey: "gacha")
                ud.set(gacha, forKey: "gacha")
                super.viewDidLoad()
                view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
                drawBgShape()
                drawTimeLeftShape()
                addTimeLabel()
               
                strokeIt.fromValue = 0
                strokeIt.toValue = 1
                strokeIt.duration = 10
                
                timeLeftShapeLayer.add(strokeIt, forKey: nil)
               
                endTime = Date().addingTimeInterval(timeLeft)
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TestTimerViewController.updateTime), userInfo: nil, repeats: true)
                CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), Unmanaged.passUnretained(self).toOpaque(), displayStatusChangedCallback, "com.apple.springboard.lockcomplete" as CFString, nil, .deliverImmediately)
            }
            @objc func updateTime() {
              var gachaCoins = ud.integer(forKey: "coins")
                if TestTimerViewController.didExit {
                                  resetPage()
                                  if !TestTimerViewController.screenOff {
                                      resetPage()
                                      return
                                  }
                              }
               
            if timeLeft > 0 {
                timeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = timeLeft.timet
                } else {
                timeLabel.text = "00:00"
                timer.invalidate()
                gachaCoins = gachaCoins + 1
                ud.set(gachaCoins, forKey: "coins")
                print(gachaCoins)
                
                }
            }
    func resetPage() {
       timer.invalidate()
       timeLabel.text = "00:00:00"
           let alertController = UIAlertController(title: "You started to use your phone!", message: "Your time has been reset", preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "OK", style: .default ) { action in print("canceled") }
           alertController.addAction(cancelAction)
           
           self.present(alertController, animated: true) {}
       }

                 

        }
               



        extension TimeInterval {
            var timet: String {
                return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
            }
        }
        extension Int {
            var degreesToRadianst : CGFloat {
                return CGFloat(self) * .pi / 180
            }
    }

private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
    guard let lockState = cfName?.rawValue as String? else {
        return
    }
    TestTimerViewController.screenOff = true
}
