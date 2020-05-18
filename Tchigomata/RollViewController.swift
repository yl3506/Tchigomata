//
//  RollViewController.swift
//  Tchigomata
//
//  Created by Justin on 5/3/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class RollViewController: UIViewController {
    
    // initialize info
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petImg: UIImageView!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "ios-wallpaper-11.png")
             backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        super.viewDidLoad()
        
        // take 3 coins for roll
        let coins = defaults.integer(forKey: "coins")
        defaults.set(coins - 3, forKey: "coins")
        
        // weighted randomization
        let pets = ["Panda": 10,
                    "Pangry": 5,
                    "Not Panda": 1,
                    "Lion": 10,
                    "Kinguin": 1,
                    "Dandelion": 5,
                    "Cliown": 1,
                    "Penguin": 10,
                    "Flapper": 5]
        let totalWeight = 48;
        
        // set name and image of roll
        let name = roll(pets: pets, totalWeight: totalWeight)
        let img = UIImage(named: name + ".png")
        petName.text = name + "!";
        petImg.image = img
        
        // set user pets
        var userPets = [String]()
        // check if user has pets already; if not, create array
        if(defaults.array(forKey: "pets") == nil) {
            defaults.set(userPets, forKey: "pets")
        }
        else {
            userPets = defaults.array(forKey: "pets") as! [String]
        }
        userPets.append(name)
        defaults.set(userPets, forKey: "pets")
        for i in defaults.array(forKey: "pets")! {
            print(i)
        }

    }
    
    func roll(pets: Dictionary<String, Int>, totalWeight: Int) -> String {
        var chance = Int.random(in: 1 ... totalWeight)
        var counter = 0;
        for (key, value) in pets {
            counter = counter + value
            if chance <= counter {
                return key
            }
        }
        return ""
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

