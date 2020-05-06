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
