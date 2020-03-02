//
//  SuccessIdentityViewController.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 02/03/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit
import Lottie

class SuccessIdentityViewController: UIViewController {

    var photos: [UIImage]?
    var dniData: DniModel?
    
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tittleLabel.text = "¡Genial! Ya validamos tu identidad"
        setupAnimation()
    }
    
    private func setupAnimation(){
        let animation = AnimationView(name: "succesAnimation")
        animationView.addSubview(animation)
        animation.frame = animationView.bounds
        animation.loopMode = .playOnce
        animation.play { (_) in
            self.performSegue(withIdentifier: "goToDetailsView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let vc = segue.destination as? DetailsViewController
            vc?.photos = self.photos
            vc?.dniData = self.dniData
        }
    }
}
