//
//  CheckViewController.swift
//  Tchigomata
//
//  Created by admin on 5/4/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    
    @IBOutlet weak var numCoins: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var notEnoughCoinsLabel: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        // show amount of coins available
        let coins = defaults.integer(forKey: "coins")
        numCoins.text = String(coins)
        
        // if < 3 coins, roll not available
        if(coins < 3){
            startButton.isEnabled = false;
            startButton.setTitleColor(.gray, for: .normal)
            notEnoughCoinsLabel.isHidden = false;
        }
    }
    
    // coins from userdefaults
    // grey out start button
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                  backgroundImage.image = UIImage(named: "ios-wallpaper-11.png")
                   backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
                  self.view.insertSubview(backgroundImage, at: 0)
        super.viewDidLoad()
//        defaults.set(3, forKey: "coins")
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

