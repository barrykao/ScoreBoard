//
//  HomePageViewController.swift
//  ScoreBoard
//
//  Created by BarryKao on 2020/2/19.
//  Copyright © 2020 BarryKao. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    
    
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("123")
        buttonInit(button: startButton)
        
        
        // Do any additional setup after loading the view.
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
