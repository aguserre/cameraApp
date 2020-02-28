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
    
    var photos: [UIImage]?
    var dniData: DniModel?
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice!
    let photoOutput = AVCapturePhotoOutput()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundCameraView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var capturedImage: UIImageView!
    
    
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
        capturedImage.isHidden = true
        titleLabel.text = "Ubicá el frente de tu DNI dentro del marco blanco"
        infoLabel.text = "Asegurate que se vea tu DNI completo y nítido, sin sombras o reflejos sobre los datos."
    }
    
    private func setupCamera() {
         captureSession.beginConfiguration()
         let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
         guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput)
             else {return}
         captureSession.addInput(videoDeviceInput)
         
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
        
        let photoSettings = AVCapturePhotoSettings()
        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func takeAnotherPhoto(_ sender: Any) {
        self.backgroundCameraView.backgroundColor = .white
        self.cameraButton.isHidden = false
        self.cancelButton.isHidden = true
        self.capturedImage.image = nil
        self.capturedImage.isHidden = true
        captureSession.startRunning()
    }
    


}

extension DniScannerViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {

                if let image = UIImage(data: dataImage) {
                    self.capturedImage.image = image
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
        self.captureSession.stopRunning()
        self.cameraButton.isHidden = true
        self.cancelButton.isHidden = false
        self.capturedImage.isHidden = false
        self.capturedImage.image = image
    }
}
