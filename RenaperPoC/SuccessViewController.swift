//
//  SuccessViewController.swift
//  RenaperPoC
//
//  Created by Agustin Errecalde on 28/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    var photos: [UIImage]?
    var dniData: DniModel?
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryAgainButton.layer.cornerRadius = 25
        tryAgainButton.clipsToBounds = true
        tryAgainButton.layer.borderWidth = 1
        tryAgainButton.layer.borderColor = UIColor.white.cgColor
        
        if let photosCount = photos {
            print(photosCount.count)
        }
        
        if let dniName = dniData?.name {
            print(dniName)
        }
        
    }
    
    @IBAction func tryAgainAction(_ sender: Any) {
        
    }
    
}
