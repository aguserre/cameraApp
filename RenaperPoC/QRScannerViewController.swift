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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }catch{
            print(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.pdf417]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.pdf417{
                    print(object.stringValue)
                }
            }
        }
    }


}
