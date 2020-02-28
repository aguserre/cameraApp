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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photosCount = photos {
            print(photosCount.count)
        }
        
        if let dniName = dniData?.name {
            print(dniName)
        }
        
    }
    

}
