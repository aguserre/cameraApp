//
//  SuccessViewController.swift
//  RenaperPoC
//
//  Created by Agustin Errecalde on 28/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit
import Lottie

class SuccessViewController: UIViewController {

    var photos: [UIImage]?
    var dniData: DniModel?
    private var errorLoading = true
    
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupAnimation()
    }
    
    private func setupAnimation() {
        var animationString = ""
        
        if errorLoading{
            tryAgainButton.layer.cornerRadius = 25
            tryAgainButton.clipsToBounds = true
            tryAgainButton.layer.borderWidth = 1
            tryAgainButton.layer.borderColor = UIColor.white.cgColor
            animationString = ERROR_ANIMATION
            errorTitleLabel.text = ERROR_TITLE
        } else {
            animationString = SUCCESS_ANIMATION
            tryAgainButton.isHidden = true
            errorTitleLabel.isHidden = true
        }
        
        let animation = AnimationView(name: animationString)
        animation.tag = 404
        animationView.addSubview(animation)
        animation.frame = animationView.bounds
        animation.loopMode = .playOnce
        if errorLoading {
            animation.play()
        } else {
            animation.play { (_) in
                self.performSegue(withIdentifier: "goToTakeSelfie", sender: self)
            }
        }
        
    }
    
    
    @IBAction func tryAgainAction(_ sender: Any) {
        if let viewWithTag = self.view.viewWithTag(404) {
            viewWithTag.removeFromSuperview()
        }
        errorLoading = false
        setupAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SelfieViewController {
            let vc = segue.destination as? SelfieViewController
            vc?.photos = self.photos
            vc?.dniData = self.dniData
        }
    }
}
