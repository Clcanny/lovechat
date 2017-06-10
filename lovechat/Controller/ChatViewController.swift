//
//  ChatViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import IGListKit
import MobileCoreServices
import Async

class ChatViewController: UIViewController {
    
    @IBOutlet weak var recordVideo: UIButton!
    
    
//    @IBAction func recordVideo_(_ sender: UIButton) {
//        let cameraController = UIImagePickerController()
//        cameraController.sourceType = .camera
//        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
//        cameraController.allowsEditing = false
//        cameraController.delegate = self
//        
//        present(cameraController, animated: true, completion: nil)
//    }
    
    @IBOutlet weak var messagesView: UIView!
    
    private let audioSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder?
    
    @IBOutlet weak var recordButton: UIButton!
    
    let fileMgr = FileManager.default
    
    @IBAction func beginRecord(_ sender: UIButton) {
        recordAnimationView.isHidden = false
        recordAnimationView.recording()
        recordAnimationView.startCountDown()
        
        // audioSession
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch {
            fatalError("audioSession error")
        }
        
        // audioRecorder settings
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let currentTime = Date().timeIntervalSince1970
        let soundFileURL = dirPaths[0].appendingPathComponent(String(currentTime) + ".caf")
        let recordSettings = [
            // 录音质量
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            // 音频格式
            // AVFormatIDKey: kAudioFormatLinearPCM,
            // 采样位数 8/16/24/32（默认为16）
            AVEncoderBitRateKey: 16,
            // 音频通道数 1/2
            AVNumberOfChannelsKey: 1,
            // 采样率 8000/11025/22050/44100/96000（影响音频的质量
            AVSampleRateKey: 44100.0
            ] as [String : Any]
        
        // audioRecorder
        do {
            try audioRecorder = AVAudioRecorder(
                url: soundFileURL,
                settings: recordSettings as [String : AnyObject]
            )
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
        }
        catch {
            fatalError("audioSession error")
        }
        
        do {
            try audioSession.setActive(true)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
        catch {
            print("can't not record")
        }
    }
    
    // UIControlEventTouchDragExit
    // An event where a finger is dragged from within a control to outside its bounds.
    @IBAction func readyToCancelRecord(_ sender: UIButton) {
        recordAnimationView.readyToCancel()
    }
    
    // UIControlEventTouchDragEnter
    // An event where a finger is dragged into the bounds of the control.
    @IBAction func dontCancelRecord(_ sender: UIButton) {
        recordAnimationView.recording()
    }
    
    // UIControlEventTouchUpOutside
    // A touch-up event in the control where the finger is outside the bounds of the control.
    @IBAction func cancelRecord(_ sender: UIButton) {
        recordAnimationView.isHidden = true
        let _ = recordAnimationView.stopCountDown()
        
        audioRecorder?.stop()
        do {
            try audioSession.setActive(false)
        }
        catch {
            fatalError()
        }
        
        do {
            try fileMgr.removeItem(at: audioRecorder!.url)
        }
        catch {
            fatalError("delete voice-record file failed")
        }
        audioRecorder = nil
    }
    
    // UIControlEventTouchUpInside
    // A touch-up event in the control where the finger is inside the bounds of the control.
    @IBAction func finishRecord(_ sender: UIButton) {
        recordAnimationView.isHidden = true
        let recordTime = recordAnimationView.stopCountDown()
        
        audioRecorder?.stop()
        do {
            try audioSession.setActive(false)
        }
        catch {
        }
        objects.append(VoiceMessageModel(message: audioRecorder!.url, time: recordTime, false))
        audioRecorder = nil
        
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    let recordAnimationView = RecordAnimationView()
    
    let collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        return adapter
    }()
    
    // Subclasses can override this method as needed to perform more precise layout of their subviews.
    // You should override this method only if the autoresizing and constraint-based behaviors
    // of the subviews do not offer the behavior you want.
    // You can use your implementation to set the frame rectangles of your subviews directly.
    // 简而言之，该方法管理子控件的布局，自适应也应该写在此方法内
    func layoutSubviews() {
        adapter.collectionView = collectionView
        adapter.dataSource = self
        messagesView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            (make) -> Void in
            make.top.left.bottom.right.equalTo(messagesView)
        }
        messagesView.addSubview(recordAnimationView)
        recordAnimationView.snp.makeConstraints {
            (make) -> Void in
            make.center.equalTo(messagesView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        layoutSubviews()
        adapter.performUpdates(animated: false, completion: nil)
        
        recordAnimationView.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            recordVideo.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    var objects = [
//        PictureMessageModel(message: #imageLiteral(resourceName: "longPictureOfMessage"), false),
        "12:25 PM" as ListDiffable,
        TextMessageModel(message: "This is a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very T--very very very very long message.", true),
//        PictureMessageModel(message: #imageLiteral(resourceName: "defaultPictureOfMessage"), false),
        TextMessageModel(message: "This is also a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long message.", false),
        "12:26 PM" as ListDiffable,
        TextMessageModel(message: "A short message", true),
        TextMessageModel(message: "A short message", true),
        TextMessageModel(message: "A short message", false),
        "12:27 PM" as ListDiffable,
        TextMessageModel(message: "This is a very very very very long message", true),
        TextMessageModel(message: "This is a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long message.", false),
//        PictureMessageModel(message: #imageLiteral(resourceName: "defaultPictureOfMessage"), true)
    ]
//    var objects: [ListDiffable] = []
    
}

extension ChatViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let textMessageModel = object as? TextMessageModel {
            let controller = TextMessageSectionController(textMessageModel: textMessageModel)
            controller.delegate = self
            return controller
        }
        else if let timeStamp = object as? String {
            return TimeStampSectionController(timeStamp: timeStamp)
        }
        else if let pictureMessageModel = object as? PictureMessageModel {
//            let block = Async.background {
//                pictureMessageModel.setImage(image: UIImage(contentsOfFile: pictureMessageModel.getMessage().path)!)
//            }
//            block.wait()
            let controller = PictureMessageSectionController(pictureMessageModel: pictureMessageModel)
            controller.delegate = self
            return controller
        }
        else if let voiceMessageModel = object as? VoiceMessageModel {
            return VoiceMessageSectionController(voiceMessageModel: voiceMessageModel)
        }
        else {
            fatalError("unrecognizable object")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension ChatViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
}

extension ChatViewController: TimeOutProtocol {
    
    func stop(_: Int) {
        recordButton.sendActions(for: .touchUpInside)
    }
    
}

extension ChatViewController: SegueFromCellProtocol {
    
    func callSegueFromCell(data: Any?) {
        if let text = data as? String {
            performSegue(withIdentifier: "ShowTextMessageDetail", sender: text)
        }
        else if let picture = data as? UIImage {
            performSegue(withIdentifier: "ShowPictureMessageDetail", sender: picture)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTextMessageDetail" {
            if let controller = segue.destination as? TextMessageDetailViewController {
                controller.text = sender as? String
            }
        }
        else if segue.identifier == "ShowPictureMessageDetail" {
            if let controller = segue.destination as? PictureMessageDetailViewController {
                controller.image = sender as? UIImage
            }
        }
        else if segue.identifier == "PresentToCameraView" {
            if let controller = segue.destination as? CameraViewController {
                controller.delegate = self
            }
        }
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate {
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
            let currentTime = Date().timeIntervalSince1970
            let videoFileURL = dirPaths[0].appendingPathComponent(String(currentTime) + ".video")
//            guard let path = (info[UIImagePickerControllerMediaURL] as? URL)?.path else { return }
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoFileURL.relativeString) {
                UISaveVideoAtPathToSavedPhotosAlbum(videoFileURL.relativeString, self, #selector(ChatViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
}

extension ChatViewController: UINavigationControllerDelegate {
}

extension ChatViewController: DismissToChatViewControllerProtocol {
    
    func save(_ messageModel: MessageModel) {
        objects.append(messageModel)
//        adapter.performUpdates(animated: false, completion: nil)
        Async.background {
            (messageModel as! PictureMessageModel).getImage()
            }.main {_ in 
                self.adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
}
