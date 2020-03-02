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
    
    var gradient:CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }

    private func configureView(){
        self.navigationController?.navigationBar.isHidden = true
        centralImage.image = UIImage(named: "illusId3X")
        footerImage.image = UIImage(named: "welcomeBackground")
        headLabel.text = "T u s  d a t o s".uppercased()
        bigTitleLabel.text = "Validemos tu identidad"
        subtitleLabel.text = "Buscá tu DNI para tomarle unas fotos y preparate para una selfie."
        warningLabel.text = "Recorda que si te registras como empresa, el DNI debe ser del titular o representante legal."
        continueButton.layer.cornerRadius = 25
        continueButton.clipsToBounds = true
        continueButton.applyGradient(colours: [.blue, .purple], locations: [0.0,1.0])
    }
}
