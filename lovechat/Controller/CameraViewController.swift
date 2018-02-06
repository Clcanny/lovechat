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
    
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    let videoDevices = AVCaptureDevice.devices(for: AVMediaType.video)
    var cameraPosition: AVCaptureDevice.Position!
    
    let promptLabelA = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = AppFont(size: 10)
        label.textColor = UIColor.white
        label.text = "Tap to take photo and hold to record video"
        return label
    }()
    let promptLabelB = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = AppFont(size: 10)
        label.textColor = UIColor.white
        label.text = "Tap to change camera and hole to exit (outside circle)"
        return label
    }()
    
    let button = { () -> UIButton in
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.frame.size = CGSize(width: 100, height: 100)
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    let progressBar = { () -> KDCircularProgress in
        let progress = KDCircularProgress.defaultProcessBar()
        progress.frame.size = CGSize(width: 120, height: 120)
        return progress
    }()
    
    let takePhotoGesture = UITapGestureRecognizer()
    let recordVideoGesture = UILongPressGestureRecognizer()
    
    var url: URL?
    var type: String?
    let saveGesture = UITapGestureRecognizer()
    let exitGesture = UILongPressGestureRecognizer()
    
    var delegate: DismissToChatViewControllerProtocol!
    
    var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        cameraView = view
        
        cameraPosition = AVCaptureDevice.Position.back
        setCamera()
        
        button.addGestureRecognizer(takePhotoGesture)
        takePhotoGesture.addTarget(self, action: #selector(CameraViewController.takePhoto))
        button.addGestureRecognizer(recordVideoGesture)
        recordVideoGesture.addTarget(self, action: #selector(CameraViewController.recordVideo(_:)))
        
        cameraView.addGestureRecognizer(exitGesture)
        exitGesture.addTarget(self, action: #selector(exit))
        cameraView.addGestureRecognizer(saveGesture)
        saveGesture.addTarget(self, action: #selector(changeCamera))
        
        promptLabelA.frame.size = CGSize(width: cameraView.frame.size.width, height: 10)
        promptLabelA.frame.origin = CGPoint(x: 0, y: cameraView.frame.size.height - 150)
        promptLabelB.frame.size = CGSize(width: cameraView.frame.size.width, height: 10)
        promptLabelB.frame.origin = CGPoint(x: 0, y: cameraView.frame.size.height - 140)
        cameraView.addSubview(promptLabelA)
        cameraView.addSubview(promptLabelB)
        
        // The order is important.
        button.center = CGPoint(x: cameraView.center.x, y: cameraView.frame.size.height - 70)
        cameraView.addSubview(button)
        progressBar.center = button.center
        cameraView.addSubview(progressBar)
    }
    
}

// labels
extension CameraViewController {
    
    func changePromptLabels() {
        promptLabelA.isHidden = true
        promptLabelB.text = "Tap to save and hole to exit"
    }
    
}

// devices
extension CameraViewController {
    
    func setAudioRecorder() {
        do {
            let input = try AVCaptureDeviceInput(device: audioDevice!)
            captureSession.addInput(input)
        }
        catch {
            fatalError()
        }
    }
    
    func setCamera() {
        for device in videoDevices {
            if (device as AnyObject).position == cameraPosition {
                var input: AVCaptureDeviceInput!
                do {
                    input = try AVCaptureDeviceInput(device: device )
                }
                catch {
                    fatalError()
                }
                if captureSession.canAddInput(input){
                    captureSession.addInput(input)
                    sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                    
                    if captureSession.canAddOutput(sessionOutput){
                        captureSession.addOutput(sessionOutput)
                        
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                        
                        previewLayer.position = CGPoint(
                            x: cameraView.frame.width / 2,
                            y: cameraView.frame.height / 2
                        )
                        previewLayer.bounds = cameraView.frame
                        cameraView.layer.addSublayer(previewLayer)
                        cameraView.addSubview(button)
                        
                        button.frame.origin = .zero
                    }
                    captureSession.startRunning()
                }
            }
        }
    }
    
    @objc func changeCamera() {
        let currentCameraInput = captureSession.inputs[0] 
        captureSession.removeInput(currentCameraInput)
        if cameraPosition == AVCaptureDevice.Position.back {
            cameraPosition = AVCaptureDevice.Position.front
        }
        else {
            cameraPosition = AVCaptureDevice.Position.back
        }
        setCamera()
    }
    
}

// photo
extension CameraViewController {
    
    @objc func takePhoto() {
        if let videoConnection = sessionOutput.connection(with: AVMediaType.video) {
            sessionOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                if error != nil {
                    let alert = UIAlertController(
                        title: "Fail to capture photo",
                        message: "Sorry, please try again",
                        preferredStyle: UIAlertControllerStyle.alert
                    )
                    alert.addAction(UIAlertAction(
                        title: "Okay",
                        style: UIAlertActionStyle.default, handler: nil
                    ))
                    self.present(alert, animated: true, completion: nil)
                }
                else if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!) {
                    let fileUrl = FileManager.getUrlByCurrentTime(suffix: "jpeg", false)
                    do {
                        try imageData.write(to: fileUrl)
                    }
                    catch {
                        fatalError()
                    }
                    self.url = fileUrl
                    self.type = "picture"
                }
                
                if (self.captureSession.isRunning) {
                     self.captureSession.stopRunning()
                }
            }
        }
        
        if (button.isEnabled == true) {
            button.isEnabled = false
        }
        saveGesture.removeTarget(self, action: #selector(self.changeCamera))
        saveGesture.addTarget(self, action: #selector(self.save))
        changePromptLabels()
    }
    
}

// video
extension CameraViewController {
    
    @objc func recordVideo(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            startRecordVideo()
        }
        else if (sender.state == .ended) {
            stopRecordVideo()
        }
    }
    
    func startRecordVideo() {
        setAudioRecorder()
        captureSession.addOutput(movieOutput)
        let fileUrl = FileManager.getUrlByCurrentTime(suffix: "mov", false)
        url = fileUrl
        type = "video"
        movieOutput.startRecording(to: url!, recordingDelegate: self)
        progressBar.animate(toAngle: 360, duration: 5, completion: {
            (flag) -> Void in
            self.stopRecordVideo()
        })
    }
    
    func stopRecordVideo() {
        if (movieOutput.isRecording) {
            movieOutput.stopRecording()
        }
        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
        if (progressBar.isAnimating()) {
            progressBar.pauseAnimation()
        }
        if (button.isEnabled == true) {
            button.isEnabled = false
        }
        saveGesture.removeTarget(self, action: #selector(changeCamera))
        saveGesture.addTarget(self, action: #selector(save))
        changePromptLabels()
    }
    
}

// save or exit
extension CameraViewController {
    
    @objc func save() {
        if url != nil {
            delegate.saveUrlMessage(url: url!, type: type!)
        }
        dismiss(animated: false, completion: nil)
    }
    
    @objc func exit() {
        if let fileUrl = url {
            do {
                try FileManager.default.removeItem(at: fileUrl)
            }
            catch {
                // fatalError()
            }
        }
        dismiss(animated: false, completion: nil)
    }
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(
        _ captureOutput: AVCaptureFileOutput,
        didStartRecordingTo fileURL: URL,
        from connections: [AVCaptureConnection]) {
    }
    
    func fileOutput(
        _ captureOutput: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?) {
        if error == nil {
            // UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
    
}
