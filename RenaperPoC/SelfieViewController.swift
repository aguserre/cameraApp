//
//  SelfieViewController.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit
import AVFoundation


class SelfieViewController: UIViewController {
    
    var photos: [UIImage]?
    var dniData: DniModel?
    
    var cameraSetup = CameraSetup.shared
    private var session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundCameraView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!    
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        setupView()
        setupCamera()
    }
    
    private func setupView(){
        backgroundCameraView.layer.cornerRadius = 5
        backgroundCameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = 5
        cameraView.clipsToBounds = true
        titleLabel.text = "Ubicá tu rostro dentro del marco"
        infoLabel.text = "En esta selfie, guiñá un ojo, si tenes anteojos, no los uses."
    }
    
    private func setupCamera() {
        session = cameraSetup.setupCamera(cameraPosition: .front,
                                                 cameraView: self.cameraView,
                                                 isNeedScanCode: false,
                                                 photoOutput: self.photoOutput,
                                                 delegate: nil)
        session.startRunning()
    }
    
    @IBAction func capturePicture(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        cameraSetup.captureImage(photoSettings: photoSettings,
                                 photoOutput: self.photoOutput,
                                 delegate: self)
    }
}

extension SelfieViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {

                if let image = UIImage(data: dataImage) {
                    self.backgroundCameraView.backgroundColor = .systemPurple
                    self.session.stopRunning()
                    self.cameraButton.isHidden = true
                    self.photos?.append(image)
                    goToSuccessView()
                }
            }
        }
    }

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let data = photo.fileDataRepresentation(),
              let image =  UIImage(data: data)  else {
                return
        }
        self.backgroundCameraView.backgroundColor = .systemPurple
        self.session.stopRunning()
        self.cameraButton.isHidden = true
        self.photos?.append(image)
        goToSuccessView()
    }
    
    func goToSuccessView() {
        performSegue(withIdentifier: "goToSuccessIdentity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SuccessIdentityViewController {
            let vc = segue.destination as? SuccessIdentityViewController
            vc?.photos = self.photos
            vc?.dniData = self.dniData
        }
    }
}
