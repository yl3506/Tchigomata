//
//  OneViewController.swift
//  Tchigomata
//
//  Created by Zhongheng Sun on 5/3/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class OneViewController: UIViewController {

     let timeLeftShapeLayer = CAShapeLayer()
        let bgShapeLayer = CAShapeLayer()
        var timeLeft: TimeInterval = 3600
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
            timeLabel.text = timeLeft.time
            view.addSubview(timeLabel)
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
            drawBgShape()
            drawTimeLeftShape()
            addTimeLabel()
           
            strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = 3600
            
            timeLeftShapeLayer.add(strokeIt, forKey: nil)
           
            endTime = Date().addingTimeInterval(timeLeft)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
        @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
            } else {
            timeLabel.text = "00:00"
            timer.invalidate()
            }
        }
    }


    extension TimeInterval {
        var time: String {
            return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
        }
    }
    extension Double {
        var degreesToRadians : CGFloat {
            return CGFloat(self) * .pi / 180
        }
}