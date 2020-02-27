//
//  DniScannerViewController.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit
import AVFoundation


class DniScannerViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice!
    var stillImageOutput = AVCapturePhotoOutput()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundCameraView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCamera()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    private func setupView(){
        backgroundCameraView.layer.cornerRadius = 5
        cameraView.layer.cornerRadius = 5
        cancelButton.isHidden = true
        titleLabel.text = "Ubicá el frente de tu DNI dentro del marco blanco"
        infoLabel.text = "Asegurate que se vea tu DNI completo y nítido, sin sombras o reflejos sobre los datos."
    }
    
    private func setupCamera() {
         captureSession.beginConfiguration()
         let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
         guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput)
             else {return}
         captureSession.addInput(videoDeviceInput)
         
         let photoOutput = AVCapturePhotoOutput()
         guard captureSession.canAddOutput(photoOutput) else {return}
         
         captureSession.sessionPreset = .photo
         captureSession.addOutput(photoOutput)
         
         
         previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
         previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
         previewLayer?.frame = cameraView.bounds
         cameraView.layer.addSublayer(previewLayer!)
        
         captureSession.commitConfiguration()
         captureSession.startRunning()
    }
    
    @IBAction func capturePicture(_ sender: Any) {
    }
    


}
