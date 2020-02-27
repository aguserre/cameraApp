//
//  ViewController.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bigTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var centralImage: UIImageView!
    @IBOutlet weak var warningImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var footerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }



    private func configureView(){
        
    }
    
    
    @IBAction func goToScan(_ sender: Any) {
        
        
        
    }
    
}

