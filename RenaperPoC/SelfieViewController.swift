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
    
//    private let captureSession = AVCaptureSession()
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//    private var captureDevice: AVCaptureDevice!
//    private let photoOutput = AVCapturePhotoOutput()
    
    
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
        //CameraSetup.shared.setupCamera(cameraView: self.cameraView)
    }
    
    private func setupView(){
        backgroundCameraView.layer.cornerRadius = 5
        backgroundCameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = 5
        cameraView.clipsToBounds = true
        titleLabel.text = "Ubicá tu rostro dentro del marco"
        infoLabel.text = "En esta selfie, guiñá un ojo, si tenes anteojos, no los uses."
    }
    
//    private func setupCamera() {
//         captureSession.beginConfiguration()
//         let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
//         guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput)
//             else {return}
//         captureSession.addInput(videoDeviceInput)
//
//         guard captureSession.canAddOutput(photoOutput) else {return}
//
//         captureSession.sessionPreset = .photo
//         captureSession.addOutput(photoOutput)
//
//
//         previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//         previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//         previewLayer?.frame = cameraView.bounds
//         cameraView.layer.addSublayer(previewLayer!)
//
//         captureSession.commitConfiguration()
//         captureSession.startRunning()
//    }
    
    @IBAction func capturePicture(_ sender: Any) {
        
        let photoSettings = AVCapturePhotoSettings()
        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }
        //photoOutput.capturePhoto(with: photoSettings, delegate: self)
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
                    //self.captureSession.stopRunning()
                    self.cameraButton.isHidden = true
                    self.photos?.append(image)
                    self.performSegue(withIdentifier: "goToSuccessIdentity", sender: self)
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
        //self.captureSession.stopRunning()
        self.cameraButton.isHidden = true
        self.photos?.append(image)
        self.performSegue(withIdentifier: "goToSuccessIdentity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SuccessIdentityViewController {
            let vc = segue.destination as? SuccessIdentityViewController
            vc?.photos = self.photos
            vc?.dniData = self.dniData
        }
    }
}
