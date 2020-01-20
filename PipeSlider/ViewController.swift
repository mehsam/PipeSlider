//
//  ViewController.swift
//  PipeSlider
//
//  Created by mehdi on 10/29/1398 AP.
//  Copyright © 1398 AP nikoosoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftToRight: PipeSlider! {
        didSet {
            leftToRight.direction = .leftToRight
        }
    }
    @IBOutlet weak var rightToLeft: PipeSlider! {
           didSet {
            rightToLeft.direction = .rightToLeft
           }
       }
    @IBOutlet weak var topDown: PipeSlider! {
           didSet {
            topDown.direction = .topDown
           }
       }
    @IBOutlet weak var bottomUp: PipeSlider! {
           didSet {
            bottomUp.direction = .bottomUp
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

