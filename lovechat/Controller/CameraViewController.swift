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

class CameraViewController: UIViewController,
AVCaptureFileOutputRecordingDelegate {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    @IBOutlet var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.cameraView = self.view
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            if (device as AnyObject).position == AVCaptureDevicePosition.front{
                
                
                do{
                    
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    
                    if captureSession.canAddInput(input){
                        
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                        
                        if captureSession.canAddOutput(sessionOutput){
                            
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            previewLayer.bounds = cameraView.frame
                            
                            
                        }
                        
                        captureSession.addOutput(movieOutput)
                        
                        captureSession.startRunning()
                        
                        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                        let fileUrl = paths[0].appendingPathComponent("output.mov")
                        try? FileManager.default.removeItem(at: fileUrl)
                        movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self)
                        
                        let delayTime = DispatchTime.now() + 5
                        DispatchQueue.main.asyncAfter(deadline: delayTime) {
                            print("stopping")
                            self.movieOutput.stopRecording()
                        }
                    }
                    
                }
                catch{
                    
                    print("Error")
                }
                
            }
        }
        
    }
    
    
    //MARK: AVCaptureFileOutputRecordingDelegate Methods
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("FINISHED \(error)")
        // save video to camera roll
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
}

//class CameraViewController: UIViewController {
//    
//    @IBOutlet weak var cameraView: UIView!
//    
//    @IBOutlet weak var button: UIButton!
//    
//    var captureSession = AVCaptureSession()
//    var sessionOutput = AVCapturePhotoOutput()
//    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
//    var previewLayer = AVCaptureVideoPreviewLayer()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDuoCamera, AVCaptureDeviceType.builtInTelephotoCamera,AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
//        for device in (deviceDiscoverySession?.devices)! {
//            if(device.position == AVCaptureDevicePosition.front){
//                do{
//                    let input = try AVCaptureDeviceInput(device: device)
//                    if(captureSession.canAddInput(input)){
//                        captureSession.addInput(input);
//                        
//                        if(captureSession.canAddOutput(sessionOutput)){
//                            captureSession.addOutput(sessionOutput);
//                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
//                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait;
//                            cameraView.layer.addSublayer(previewLayer);
//                        }
//                    }
//                }
//                catch{
//                    print("exception!");
//                }
//            }
//        }
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        previewLayer.frame = cameraView.bounds
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
////        captureSession.sessionPreset = AVCaptureSessionPresetHigh
//        captureSession.startRunning()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    var videoFileOutput: AVCaptureMovieFileOutput!
//    @IBAction func action(_ sender: UIButton) {
//        captureSession.stopRunning()
////        sessionOutput.capturePhoto(with: sessionOutputSetting, delegate: self)
//        videoFileOutput.stopRecording()
//        button.isEnabled = false
//    }
//    
//    @IBAction func startRecordVideo(_ sender: UIButton) {
//        videoFileOutput = AVCaptureMovieFileOutput()
//        
//        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let currentTime = Date().timeIntervalSince1970
//        let videoFileURL = dirPaths[0].appendingPathComponent(String(currentTime) + ".caf")
//        
//        captureSession.addOutput(videoFileOutput)
////        videoFileOutput.maxRecordedDuration = CMTime(seconds: 5, preferredTimescale: 1)
//        videoFileOutput.startRecording(toOutputFileURL: videoFileURL, recordingDelegate: self)
//    }
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//    
//}
//
//extension CameraViewController: AVCapturePhotoCaptureDelegate {
//    
//    // Which delegate methods the photo output calls depends on the photo settings
//    // you initiate capture with. All methods in this protocol are optional at compile time,
//    // but at run time your delegate object must respond to certain methods depending on 
//    // your photo settings.
//    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        print("testing")
//        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
//            print(UIImage(data: dataImage)?.size)
//        }
//    }
//    
//}
//
//extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
//    
//    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
////        print(videoFileOutput)
////        let player = AVPlayer(url: outputFileURL)
////        print(outputFileURL)
////        print(error)
////        print(player.currentItem?.asset.duration)
////        player.actionAtItemEnd = .none
////        let layer = AVPlayerLayer(player: player)
////        layer.frame = previewLayer.frame
////        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
////        cameraView.layer.addSublayer(layer)
////        player.play()
////        print("playing")
//        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.relativeString, nil, nil, nil)
//        return
//    }
//    
//}
