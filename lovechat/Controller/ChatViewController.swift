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
import AVKit
import AVFoundation
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var VoiceButton: UIButton!
    @IBOutlet weak var Textbutton: UIButton!
    @IBOutlet weak var AlbumButton: UIButton!
    @IBOutlet weak var recordVideo: UIButton!
    
    @IBOutlet weak var messagesView: UIView!
    
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    fileprivate var audioRecorder: AVAudioRecorder?
    
    @IBOutlet weak var recordButton: UIButton!
    let recordAnimationView = RecordAnimationView()
    
    let uid = Auth.auth().currentUser!.uid
    var companionId: String!
    let database = Database.database().reference()
    let storage = Storage.storage()
    
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
    
    let textView = { () -> AutoHeightTextView in
        let view = AutoHeightTextView()
        view.backgroundColor = ivoryColor
        view.isEditable = true
        view.isHidden = true
        view.font = inputFont
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil, action: nil
        )
        let cancelBarButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self, action: #selector(ChatViewController.cancelTextMessage)
        )
        let doneBarButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self, action: #selector(ChatViewController.sendTextMessage)
        )
        keyboardToolbar.items = [flexBarButton, cancelBarButton, doneBarButton]
        view.inputAccessoryView = keyboardToolbar
        
        return view
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
        
        messagesView.addSubview(textView)
        textView.minHeight = messagesView.frame.size.height / 6
        textView.maxHeight = messagesView.frame.size.height / 3
        textView.snp.makeConstraints {
            (make) -> Void in
            make.left.right.equalTo(messagesView)
            make.height.equalTo(textView.minHeight)
            make.top.equalTo(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        layoutSubviews()
        adapter.performUpdates(animated: false, completion: nil)
        
        recordAnimationView.delegate = self
        textView.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            recordVideo.isEnabled = false
        }
        
        database.child("users/\(uid)/companionId").observeSingleEvent(
            of: DataEventType.value, with: { (snapshot) -> Void in
                let value = snapshot.value
                self.companionId = value as! String
        })
        
        database.keepSynced(true)
        observeDataChange()
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
    
    var objects: [ListDiffable] = []
    
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
            let controller = PictureMessageSectionController(pictureMessageModel: pictureMessageModel)
            controller.delegate = self
            return controller
        }
        else if let voiceMessageModel = object as? VoiceMessageModel {
            return VoiceMessageSectionController(voiceMessageModel: voiceMessageModel)
        }
        else if let videoMessageModel = object as? VideoMessageModel {
            let controller = VideoMessageSctionController(videoMessageModel: videoMessageModel)
            controller.delegate = self
            return controller
        }
        else {
            fatalError("unrecognizable object")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// Firebase
extension ChatViewController {
    
    func observeDataChange() {
        let uid = Auth.auth().currentUser!.uid
        self.database.child("users/\(uid)").observe(
            DataEventType.childAdded, with: { (snapshot) -> Void in
                if let value = snapshot.value as? NSDictionary {
                    let type = value.object(forKey: "type") as! String
                    switch type {
                    case "text":
                        self.objects.append(TextMessageModel(
                            message: value.object(forKey: "message") as! String,
                            value.object(forKey: "isReceive") as! Bool
                        ))
                    case "audio":
                        self.objects.append(VoiceMessageModel(
                            message: URL(string: value.object(forKey: "url") as! String)!,
                            time: value.object(forKey: "time") as! Int,
                            value.object(forKey: "isReceive") as! Bool
                        ))
                    case "picture":
                        self.objects.append(PictureMessageModel(
                            message: URL(string: value.object(forKey: "url") as! String)!,
                            value.object(forKey: "isReceive") as! Bool
                        ))
                    case "video":
                        self.objects.append(VideoMessageModel(
                            message: URL(string: value.object(forKey: "url") as! String)!,
                            value.object(forKey: "isReceive") as! Bool
                        ))
                    default:
                        fatalError()
                    }
                    self.adapter.performUpdates(animated: false, completion: nil)
                }
        })
    }
    
    func pushMessage(
        _ sendMsg: [String : Any],
        _ receiveMsg: [String : Any]) {
        if companionId == nil {
            database.child("users/\(uid)/companionId").observeSingleEvent(
                of: DataEventType.value, with: { (snapshot) -> Void in
                    let value = snapshot.value
                    let companionId = value as! String
                    self.companionId = companionId
            })
        }
        
        let key = database.child("users/\(uid)").childByAutoId().key
        let childUpdates = [
            "users/\(uid)/\(key)": sendMsg,
            "users/\(companionId!)/\(key)": receiveMsg
        ]
        database.updateChildValues(childUpdates)
    }
    
    func uploadTextMessage(message: String) {
        let sendMsg = ["message": message, "isReceive": false, "type": "text"] as [String : Any]
        let receiveMsg = ["message": message, "isReceive": true, "type": "text"] as [String : Any]
        Async.background {
            self.pushMessage(sendMsg, receiveMsg)
        }
    }
    
    func uploadUrlMessage(fileUrl: URL, type: String, recordTime: Int?) {
        let url = "gs://lovechat-2dc1b.appspot.com/" + uid + "/" + fileUrl.lastPathComponent
        
        Async.background {
            let reference = self.storage.reference(forURL: url)
            _ = reference.putFile(from: fileUrl, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                }
                else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata!.downloadURL() {
                        var sendMsg: [String : Any]!
                        var receiveMsg: [String : Any]!
                        if type == "audio" {
                            sendMsg = [
                                "url": downloadURL.absoluteString,
                                "time": recordTime!, "isReceive": false, "type": "audio"
                                ] as [String : Any]
                            receiveMsg = [
                                "url": downloadURL.absoluteString,
                                "time": recordTime!, "isReceive": true, "type": "audio"
                                ] as [String : Any]
                        }
                        else {
                            sendMsg = [
                                "url": downloadURL.absoluteString,
                                "isReceive": false, "type": type
                                ] as [String : Any]
                            receiveMsg = [
                                "url": downloadURL.absoluteString,
                                "isReceive": true, "type": type
                                ] as [String : Any]
                        }
                        self.pushMessage(sendMsg, receiveMsg)
                    }
                }
            }
        }
    }
    
}

// text
extension ChatViewController: UITextViewDelegate {
    
    @IBAction func inputText(_ sender: UIButton) {
        textView.isHidden = !textView.isHidden
    }
    
    func sendTextMessage() {
        textView.resignFirstResponder()
        textView.isHidden = true
        let message = textView.text!
        textView.text = ""
        
        uploadTextMessage(message: message)
    }
    
    func cancelTextMessage() {
        textView.resignFirstResponder()
        textView.isHidden = true
        textView.text = ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.textView.sizeToFit()
    }
    
}

// audio
extension ChatViewController {
    
    @IBAction func beginRecord(_ sender: UIButton) {
        recordAnimationView.isHidden = false
        recordAnimationView.recording()
        recordAnimationView.startCountDown()
        
        // audioSession
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch {
            fatalError()
        }
        
        // audioRecorder settings
        let url = FileManager.getUrlByCurrentTime(suffix: "caf", false)
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
                url: url,
                settings: recordSettings as [String : AnyObject]
            )
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
        }
        catch {
            fatalError()
        }
        
        do {
            try audioSession.setActive(true)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
        catch {
            fatalError()
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
            try FileManager.default.removeItem(at: audioRecorder!.url)
        }
        catch {
            fatalError()
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
        
        let audioUrl = audioRecorder!.url
        audioRecorder = nil
        
        uploadUrlMessage(fileUrl: audioUrl, type: "audio", recordTime: recordTime)
    }
    
}

// picture
extension ChatViewController: UIImagePickerControllerDelegate {
    
    @IBAction func selectImageFromAlbum(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true) {
            // Handle a movie capture
            if mediaType == kUTTypeMovie {
                let url = FileManager.getUrlByCurrentTime(suffix: "video", false)
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.relativeString) {
                    // do something
                }
            }
            else {
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    let imageData = UIImageJPEGRepresentation(image, 1)
                    let url = FileManager.getUrlByCurrentTime(suffix: "jpeg", false)
                    do {
                        try imageData?.write(to: url)
                    }
                    catch {
                        fatalError()
                    }
                    self.uploadUrlMessage(fileUrl: url, type: "picture", recordTime: nil)
                }
                else {
                    fatalError()
                }
            }
        }
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        else if let url = data as? URL {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: false) {
                playerViewController.player!.play()
            }
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

extension ChatViewController: DismissToChatViewControllerProtocol {
    
    func saveUrlMessage(url: URL, type: String) {
        uploadUrlMessage(fileUrl: url, type: type, recordTime: nil)
    }
    
}

extension ChatViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
}

extension ChatViewController: UINavigationControllerDelegate {
}


