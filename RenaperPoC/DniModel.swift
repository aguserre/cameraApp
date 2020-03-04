//
//  DniModel.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

struct DniModel{
    
    var processNumber: String?
    var lastName: String?
    var name: String?
    var sex: String?
    var dniNumber: String?
    var copy: String?
    var birthDate: String?
    var createDate: String?
    
    
}

import AVFoundation
import UIKit

struct CameraSetup {
    
    let photoOutput = AVCapturePhotoOutput()
    
    static var shared = CameraSetup()
    private init(){}
    
    mutating func setupCamera(cameraPosition:AVCaptureDevice.Position,
                              cameraView: UIView,
                              isSecondImage: Bool,
                              delegate: AVCaptureMetadataOutputObjectsDelegate?) -> AVCaptureSession{
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition)
        let session = AVCaptureSession()
        var videoLayer = AVCaptureVideoPreviewLayer()

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }catch{
            print(error.localizedDescription)
        }
        
        if session.canAddOutput(photoOutput){
            session.sessionPreset = .photo
            session.addOutput(photoOutput)
        }
        
        if !isSecondImage {
            let output = AVCaptureMetadataOutput()
            if  session.canAddOutput(output){
                session.addOutput(output)
                output.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                output.metadataObjectTypes = [AVMetadataObject.ObjectType.pdf417]
            }
        }
        
        videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(videoLayer)

        return session
    }
    
    func captureImage(photoSettings: AVCapturePhotoSettings, photoOutput: AVCapturePhotoOutput, delegate: AVCapturePhotoCaptureDelegate) {
        
        let photoSettings = AVCapturePhotoSettings()
        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: delegate)
    }
    
}


