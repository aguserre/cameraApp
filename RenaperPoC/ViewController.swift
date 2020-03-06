//
//  ViewController.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var bigTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var centralImage: UIImageView!
    @IBOutlet weak var footerImage: UIImageView!
    @IBOutlet weak var warningImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    private let centralImageName = "illusId3X"
    private let footerImageName = "welcomeBackground"
    
    var gradient:CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }

    private func configureView(){
        self.navigationController?.navigationBar.isHidden = true
        centralImage.image = UIImage(named: centralImageName)
        footerImage.image = UIImage(named: footerImageName)
        headLabel.text = "T u s  d a t o s".uppercased()
        bigTitleLabel.text = VALIDATE_IDENTITY
        subtitleLabel.text = APP_INFO
        warningLabel.text = WARNING_WELCOME
        continueButton.layer.cornerRadius = 25
        continueButton.clipsToBounds = true
        continueButton.applyGradient(colours: [.blue, .purple], locations: [0.0,1.0])
    }
}
