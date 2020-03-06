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
    var photoCounter = 0
    var dniData: DniModel?
    
    var cameraSetup = CameraSetupManager.shared
    private var session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    enum PhotoNumber {
        case firstPhoto
        case secondPhoto
        case thirdPhoto
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundCameraView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!    
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        setupCamera()
        setupView(photoNumber: .firstPhoto)
    }
    
    private func setupView(photoNumber: PhotoNumber){
        backgroundCameraView.backgroundColor = .white
        backgroundCameraView.layer.cornerRadius = 5
        backgroundCameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = 5
        cameraView.clipsToBounds = true
        titleLabel.text = TITLE_SELFIE

        setPhotoInfo(photoNumber: photoNumber)
        session.startRunning()
    }
    
    private func setPhotoInfo(photoNumber: PhotoNumber){
        switch photoNumber {
            case .firstPhoto:
                infoLabel.text = INFO_FIRST_IMAGE
                photoCounter = 0
            case .secondPhoto:
                infoLabel.text = INFO_SECOND_IMAGE
                photoCounter = 1
            case .thirdPhoto:
                infoLabel.text = INFO_THIRD_IMAGE
                photoCounter = 2
        }
    }
    
    private func setupCamera() {
        session = cameraSetup.setupCamera(cameraPosition: .front,
                                                 cameraView: self.cameraView,
                                                 isNeedScanCode: false,
                                                 photoOutput: self.photoOutput,
                                                 delegate: nil)
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
                    processImage(image: image)
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
        processImage(image: image)
    }
    
    private func processImage(image: UIImage) {
        self.session.stopRunning()
        self.backgroundCameraView.backgroundColor = .systemPurple
        self.photos?.append(image)

        switch photoCounter {
            case 0:
                setupView(photoNumber: .secondPhoto)
            case 1:
                setupView(photoNumber: .thirdPhoto)
            case 2:
                goToSuccessView()
            default:
                setupView(photoNumber: .firstPhoto)
        }
    }
    
    private func goToSuccessView() {
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
