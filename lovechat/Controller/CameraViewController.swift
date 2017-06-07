//
//  CameraViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/6.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    let videoButton = { () -> UIButton in
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.frame.size = CGSize(width: 60, height: 60)
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    func startRecordVideo() {
        captureSession.addOutput(movieOutput)
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let currentTime = Date().timeIntervalSince1970
        let fileUrl = paths[0].appendingPathComponent(String(currentTime) + ".mov")
        movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self)
    }
    
    func stopRecordVideo() {
        movieOutput.stopRecording()
        captureSession.stopRunning()
    }
    
    @IBOutlet var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        cameraView = view
        
        videoButton.addTarget(self, action: #selector(CameraViewController.startRecordVideo), for: .touchDown)
        videoButton.addTarget(self, action: #selector(CameraViewController.stopRecordVideo), for: .touchUpInside)
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            if (device as AnyObject).position == AVCaptureDevicePosition.back {
                do {
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    if captureSession.canAddInput(input){   
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                            
                            previewLayer.position = CGPoint(
                                x: cameraView.frame.width / 2,
                                y: cameraView.frame.height / 2
                            )
                            previewLayer.bounds = cameraView.frame
                            cameraView.layer.addSublayer(previewLayer)
                            cameraView.addSubview(videoButton)
                            
                            videoButton.frame.origin = .zero
                        }
                        
                        captureSession.startRunning()
                    }
                }
                catch {
                    fatalError()
                }
            }
        }
    }
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {

    func capture(
        _ captureOutput: AVCaptureFileOutput!,
        didStartRecordingToOutputFileAt fileURL: URL!,
        fromConnections connections: [Any]!) {
    }
    
    func capture(
        _ captureOutput: AVCaptureFileOutput!,
        didFinishRecordingToOutputFileAt outputFileURL: URL!,
        fromConnections connections: [Any]!,
        error: Error!) {
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
    
}
