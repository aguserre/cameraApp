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
    var errorLoading = true
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        configureAnimation()
        print("SuccessView:")
        if let photosCount = photos {
            print(photosCount.count)
        }
        
        if let dniName = dniData?.name {
            print(dniName)
        }
        
    }
    
    func configureAnimation() {
        var animationString = ""
        
        if errorLoading{
            tryAgainButton.layer.cornerRadius = 25
            tryAgainButton.clipsToBounds = true
            tryAgainButton.layer.borderWidth = 1
            tryAgainButton.layer.borderColor = UIColor.white.cgColor
            animationString = "errorAnimation"
            
        } else {
            animationString = "succesAnimation"
            tryAgainButton.isHidden = true
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
        configureAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DniScannerViewController {
            let vc = segue.destination as? DniScannerViewController
            vc?.photos = self.photos
            vc?.dniData = self.dniData
        }
    }
}