//
//  QRScannerViewController.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    let photoOutput = AVCapturePhotoOutput()
    let session = AVCaptureSession()
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    var photos: [UIImage]? = []
    var dniObject = DniModel()
    var isSecondImage = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var backgroundCameraView: UIView!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var takeAnotherPhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        setupView()
        setupCamera()

    }
    
    func setupView() {
        self.photos?.removeAll()
        backgroundCameraView.backgroundColor = .white
        backgroundCameraView.layer.cornerRadius = 5
        backgroundCameraView.clipsToBounds = true
        
        cameraView.layer.cornerRadius = 5
        cameraView.clipsToBounds = true
        
        continueButton.isHidden = true
        takeAnotherPhotoButton.isHidden = true
        cameraButton.isHidden = false
        capturedImage.isHidden = true
        
        titleLabel.text = "Ubicá el frente de tu DNI dentro del marco blanco"
        subtitleLabel.text = "Asegurate que se vea tu DNI completo y nítido, sin sombras o reflejos sobre los datos"
    }
    
    func setupViewAfterTakeFirstPhoto() {
        titleLabel.text = "Confirmá la foto del DNI"
        self.backgroundCameraView.backgroundColor = .systemPurple
        self.cameraButton.isHidden = true
        self.continueButton.isHidden = false
        self.takeAnotherPhotoButton.isHidden = false
        self.capturedImage.isHidden = false
        continueButton.layer.cornerRadius = 25
        continueButton.clipsToBounds = true
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func setupViewToTakeSecondPhoto() {
        self.backgroundCameraView.backgroundColor = .white
        self.cameraButton.isHidden = false
        self.isSecondImage = true
        self.continueButton.isHidden = true
        self.takeAnotherPhotoButton.isHidden = true
        self.capturedImage.isHidden = true
        titleLabel.text = "Ubicá el dorso de tu DNI dentro del marco blanco"
    }
    
    func setupCamera() {
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }catch{
            print(error.localizedDescription)
        }
        
        guard session.canAddOutput(photoOutput) else {return}
        session.sessionPreset = .photo
        session.addOutput(photoOutput)
        if !isSecondImage{
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.pdf417]
        }
        video = AVCaptureVideoPreviewLayer(session: session)
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.frame = cameraView.bounds
        cameraView.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.pdf417{
                    
                    if let objectString = object.stringValue {
                        let objects: [String] = objectString.components(separatedBy: "@")
                        dniObject.processNumber = objects[0]
                        dniObject.lastName = objects[1]
                        dniObject.name = objects[2]
                        dniObject.sex = objects[3]
                        dniObject.dniNumber = objects[4]
                        dniObject.copy = objects[5]
                        dniObject.birthDate = objects[6]
                        dniObject.createDate = objects[7]
                    }
                }
            }
        }
    }
    
    @IBAction func capturePhoto(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func continueToSecondImage(_ sender: Any) {
        isSecondImage = true
        session.startRunning()
        setupViewToTakeSecondPhoto()
    }
    
    @IBAction func takeAnotherPhoto(_ sender: Any) {
        setupView()
        session.startRunning()
    }
}

extension QRScannerViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {

                if let image = UIImage(data: dataImage) {
                    self.backgroundCameraView.backgroundColor = .systemPurple
                    self.session.stopRunning()
                    self.cameraButton.isHidden = true
                    self.capturedImage.isHidden = false
                    self.photos?.append(image)
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
        setupViewAfterTakeFirstPhoto()
        self.session.stopRunning()
        self.photos?.append(image)
        self.capturedImage.image = image
        if isSecondImage{
            goToSuccessView()
        }
    }
    
    func goToSuccessView() {
        performSegue(withIdentifier: "goToSuccessView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SuccessViewController {
            let vc = segue.destination as? SuccessViewController
            vc?.photos = self.photos
            vc?.dniData = self.dniObject
        }
    }
}
