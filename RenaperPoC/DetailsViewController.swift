//
//  DetailsViewController.swift
//  RenaperPoC
//
//  Created by Agustin Errecalde on 28/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var photos: [UIImage]?
    var dniData: DniModel?
    
    //Textfields
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var dniTextfield: UITextField!
    @IBOutlet weak var birthDayTextfield: UITextField!
    @IBOutlet weak var naciTextField: UITextField!
    @IBOutlet weak var sexTextfield: UITextField!
    @IBOutlet weak var cuilTextfield: UITextField!
    @IBOutlet weak var celularTextfield: UITextField!
    
    @IBOutlet weak var switchLabel: UISwitch!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var footerImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        titleLabel.text = "Confirmanos tus datos"
        footerImage.image = UIImage(named: "welcomeBackground")

        if let dniName = dniData?.name, let dniLastName = dniData?.lastName {
            nameTextfield.isEnabled = false
            nameTextfield.text = dniName + " " + dniLastName
        }
        
        if let dniNumber = dniData?.dniNumber {
            dniTextfield.isEnabled = false
            dniTextfield.text = dniNumber
        }
        
        if let birthDate = dniData?.birthDate {
            birthDayTextfield.isEnabled = false
            birthDayTextfield.text = birthDate
        }
        
        if let sex = dniData?.sex {
            sexTextfield.isEnabled = false
            sexTextfield.text = sex
        }
        
        confirmButton.layer.cornerRadius = 25
        confirmButton.clipsToBounds = true
        confirmButton.applyGradient(colours: [.blue, .purple], locations: [0.0,1.0])
        
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
