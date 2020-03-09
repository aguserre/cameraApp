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
    private var isProfesional = false
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var dniTextfield: UITextField!
    @IBOutlet weak var birthDayTextfield: UITextField!
    @IBOutlet weak var naciTextField: UITextField!
    @IBOutlet weak var sexTextfield: UITextField!
    @IBOutlet weak var cuilTextfield: UITextField!
    @IBOutlet weak var celularTextfield: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var switchLabel: UISwitch!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var footerImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        titleLabel.text = DATA_CONFIRMATED
        footerImage.image = UIImage(named: "welcomeBackground")

        if let dniName = dniData?.name, let dniLastName = dniData?.lastName {
            nameLabel.textColor = .lightGray
            nameTextfield.isEnabled = false
            nameTextfield.text = dniName + " " + dniLastName
        }
        
        if let dniNumber = dniData?.dniNumber {
            dniLabel.textColor = .lightGray
            dniTextfield.isEnabled = false
            dniTextfield.text = dniNumber
        }
        
        if let birthDate = dniData?.birthDate {
            birthDayLabel.textColor = .lightGray
            birthDayTextfield.isEnabled = false
            birthDayTextfield.text = birthDate
        }
        
        if let sex = dniData?.sex {
            sexLabel.textColor = .lightGray
            sexTextfield.isEnabled = false
            sexTextfield.text = sex
        }
        
        confirmButton.layer.cornerRadius = 25
        confirmButton.clipsToBounds = true
        confirmButton.applyGradient(colours: [.blue, .purple], locations: [0.0,1.0])
        
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func tapSwitch(_ sender: Any) {
        if switchLabel.isOn {
            isProfesional = true
        } else {
            isProfesional = false
        }
    }
    @IBAction func confirmData(_ sender: Any) {
        
        print("Cantidad de fotos:")
        print(photos?.count)
        print("")
        print("Datos DNI:")
        print(dniData?.name)
        print(dniData?.lastName)
        print(dniData?.birthDate)
        print("")
        print("Seleccionó profesional:")
        print(isProfesional)
        
    }
}
