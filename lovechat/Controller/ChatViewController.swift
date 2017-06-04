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

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messagesView: UIView!
    
    var audioRecorder: AVAudioRecorder?
    
    @IBAction func beginRecord(_ sender: UIButton) {
        recordAnimationView.isHidden = false
        recordAnimationView.recording()
        audioRecorder?.record()
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
        audioRecorder?.stop()
    }
    
    // UIControlEventTouchUpInside
    // A touch-up event in the control where the finger is inside the bounds of the control.
    @IBAction func finishRecord(_ sender: UIButton) {
        recordAnimationView.isHidden = true
        audioRecorder?.stop()
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
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        let recordSettings = [
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
            ] as [String : Any]
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch {
            fatalError("audioSession error")
        }
        do {
            try audioRecorder = AVAudioRecorder(
                url: soundFileURL,
                settings: recordSettings as [String : AnyObject]
            )
            audioRecorder?.prepareToRecord()
        } catch {
            fatalError("audioSession error")
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
    
}

extension ChatViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            "12:25 PM" as ListDiffable,
            TextMessageModel(message: "This is a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long message.", true),
            PictureMessageModel(message: #imageLiteral(resourceName: "defaultPictureOfMessage"), false),
            TextMessageModel(message: "This is also a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long message.", false),
            "12:26 PM" as ListDiffable,
            TextMessageModel(message: "A short message", true),
            TextMessageModel(message: "A short message", true),
            TextMessageModel(message: "A short message", false),
            "12:27 PM" as ListDiffable,
            TextMessageModel(message: "This is a very very very very long message", true),
            TextMessageModel(message: "This is a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long message.", false),
            PictureMessageModel(message: #imageLiteral(resourceName: "defaultPictureOfMessage"), true)
        ]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let textMessageModel = object as? TextMessageModel {
            return TextMessageSectionController(textMessageModel: textMessageModel)
        }
        else if let timeStamp = object as? String {
            return TimeStampSectionController(timeStamp: timeStamp)
        }
        else if let pictureMessageModel = object as? PictureMessageModel {
            return PictureMessageSectionController(pictureMessageModel: pictureMessageModel)
        }
        else {
            fatalError("unrecognizable object")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
