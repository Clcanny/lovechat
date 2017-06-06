//
//  CameraViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/6.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDuoCamera, AVCaptureDeviceType.builtInTelephotoCamera,AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        for device in (deviceDiscoverySession?.devices)! {
            if(device.position == AVCaptureDevicePosition.front){
                do{
                    let input = try AVCaptureDeviceInput(device: device)
                    if(captureSession.canAddInput(input)){
                        captureSession.addInput(input);
                        
                        if(captureSession.canAddOutput(sessionOutput)){
                            captureSession.addOutput(sessionOutput);
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait;
                            cameraView.layer.addSublayer(previewLayer);
                        }
                    }
                }
                catch{
                    print("exception!");
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        captureSession.startRunning()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var videoFileOutput: AVCaptureMovieFileOutput!
    @IBAction func action(_ sender: UIButton) {
        print("test")
        captureSession.stopRunning()
//        sessionOutput.capturePhoto(with: sessionOutputSetting, delegate: self)
        videoFileOutput.stopRecording()
    }
    
    @IBAction func startRecordVideo(_ sender: UIButton) {
        videoFileOutput = AVCaptureMovieFileOutput()
        captureSession.addOutput(videoFileOutput)

        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let currentTime = Date().timeIntervalSince1970
        let videoFileURL = dirPaths[0].appendingPathComponent(String(currentTime) + ".caf")
        
        videoFileOutput.startRecording(toOutputFileURL: videoFileURL, recordingDelegate: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    // Which delegate methods the photo output calls depends on the photo settings
    // you initiate capture with. All methods in this protocol are optional at compile time,
    // but at run time your delegate object must respond to certain methods depending on 
    // your photo settings.
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        print("testing")
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size)
        }
    }
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
//        let player = AVPlayer(url: videoFileOutput.outputFileURL)
//        player.play()
        return
    }
    
}
