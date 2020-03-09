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
    
    var cameraSetup = CameraSetupManager.shared
    private var session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    private var photos: [UIImage]? = []
    var dniObject = DniModel()
    private var isNeedScanCode = true
    private var photoCounter = 0
    
    private enum Step {
        case initialView
        case standByView
        case finalView
    }
    
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
        setupCamera()
        setupView(step: .initialView)
    }
    
    private func setupView(step: Step) {
        subtitleLabel.text = FIRST_DNI_IMAGE_SUBTITLE
        backgroundCameraView.layer.cornerRadius = 5
        backgroundCameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = 5
        cameraView.clipsToBounds = true
        continueButton.layer.cornerRadius = 25
        continueButton.clipsToBounds = true
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.white.cgColor
        
        switch step {
            case .initialView:
                self.photos?.removeAll()
                titleLabel.text = FIRST_DNI_IMAGE_TITLE
                backgroundCameraView.backgroundColor = .white
                cameraButton.isHidden = false
                continueButton.isHidden = true
                takeAnotherPhotoButton.isHidden = true
                capturedImage.isHidden = true
                photoCounter = 0
                session.startRunning()
                
            case .standByView:
                titleLabel.text = CONFIRM_DNI_IMAGE
                backgroundCameraView.backgroundColor = .systemPurple
                cameraButton.isHidden = true
                continueButton.isHidden = false
                takeAnotherPhotoButton.isHidden = false
                capturedImage.isHidden = false
                photoCounter = 1
                session.stopRunning()
                
            case .finalView:
                titleLabel.text = SECOND_DNI_IMAGE_TITLE
                backgroundCameraView.backgroundColor = .white
                cameraButton.isHidden = false
                continueButton.isHidden = true
                takeAnotherPhotoButton.isHidden = true
                capturedImage.isHidden = true
                photoCounter = 2
                session.startRunning()
        }
    }
    
    private func setupCamera() {
        session = cameraSetup.setupCamera(cameraPosition: .back,
                                                 cameraView: self.cameraView,
                                                 isNeedScanCode: self.isNeedScanCode,
                                                 photoOutput: self.photoOutput,
                                                 delegate: self)
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.pdf417{
                    if let objectString = object.stringValue {
                        buildDniStruct(objectString: objectString)
                    }
                }
            }
        }
    }
    
    private func buildDniStruct(objectString: String){
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
    
    @IBAction func capturePhoto(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        cameraSetup.captureImage(photoSettings: photoSettings,
                                 photoOutput: photoOutput,
                                 delegate: self)
    }
    
    @IBAction func continueToSecondImage(_ sender: Any) {
        isNeedScanCode = false
        session.startRunning()
        setupView(step: .finalView)
    }
    
    @IBAction func takeAnotherPhoto(_ sender: Any) {
        isNeedScanCode = true
        setupView(step: .initialView)
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
    
    func processImage(image: UIImage) {
        self.session.stopRunning()
        self.photos?.append(image)
        self.capturedImage.image = image
        
        switch photoCounter {
            case 0:
                setupView(step: .standByView)
            case 1:
                setupView(step: .finalView)
            case 2:
                goToSuccessView()
            default:
                setupView(step: .initialView)
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
