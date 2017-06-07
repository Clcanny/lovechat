//
//  CameraViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/6.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import AVFoundation
import KDCircularProgress

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    let videoButton = { () -> UIButton in
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.frame.size = CGSize(width: 100, height: 100)
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    let tapGesture = UITapGestureRecognizer()
    
    let longPressGesture = UILongPressGestureRecognizer()
    
    func takePhoto() {
        if let videoConnection = sessionOutput.connection(withMediaType: AVMediaTypeVideo) {
            sessionOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
            }
        }
        videoButton.isEnabled = false
    }
    
    func recordVideo(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            startRecordVideo()
        }
        else if (sender.state == .ended) {
            stopRecordVideo()
        }
    }
    
    func startRecordVideo() {
        captureSession.addOutput(movieOutput)
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let currentTime = Date().timeIntervalSince1970
        let fileUrl = paths[0].appendingPathComponent(String(currentTime) + ".mov")
        movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self)
        progressBar.animate(toAngle: 360, duration: 5, completion: {
            (flag) -> Void in
            self.stopRecordVideo()
        })
    }
    
    func stopRecordVideo() {
        if (movieOutput.isRecording) {
            movieOutput.stopRecording()
            captureSession.stopRunning()
            videoButton.isEnabled = false
        }
        if (progressBar.isAnimating()) {
            progressBar.pauseAnimation()
        }
    }
    
    let progressBar = { () -> KDCircularProgress in
        let progress = KDCircularProgress()
        progress.frame.size = CGSize(width: 120, height: 120)
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.2
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: UIColor.cyan, UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        return progress
    }()
    
    @IBOutlet var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        cameraView = view

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
        
        videoButton.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(CameraViewController.takePhoto))
        videoButton.addGestureRecognizer(longPressGesture)
        longPressGesture.addTarget(self, action: #selector(CameraViewController.recordVideo(_:)))
        
        // The order is important.
        videoButton.center = CGPoint(x: cameraView.center.x, y: cameraView.frame.height - 70)
        cameraView.addSubview(videoButton)
        progressBar.center = videoButton.center
        cameraView.addSubview(progressBar)
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
