//
//  VoiceMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceMessageCollectionViewCell: MessageCollectionViewCell {
    
    private static let baseWidth: CGFloat = 50
    public var addWidth: CGFloat?
    
    var url: URL?
    
    private var audioPlayer: AVAudioPlayer!
    fileprivate var updater: CADisplayLink!
    
    var processBar: UIProgressView?
    func trackAudio() {
        let normalizedTime = Float(audioPlayer.currentTime * 1.0 / audioPlayer.duration)
        processBar?.setProgress(normalizedTime, animated: false)
    }
    
    override func click(gestureRecognizer: UIGestureRecognizer) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            fatalError()
        }
        do {
            updater = CADisplayLink(target: self, selector: #selector(VoiceMessageCollectionViewCell.trackAudio))
            updater.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.numberOfLoops = 0
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            processBar?.isHidden = false
            audioPlayer.play()
        }
        catch {
            fatalError()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        highlightLayer.strokeColor = babyBlueColor.cgColor
        highlightLayer.fillColor = babyBlueColor.cgColor
        
        processBar = UIProgressView(frame: CGRect(
            x: MessageCollectionViewCell.radius * 3,
            y: 1  * MessageCollectionViewCell.radius - 1,
            width: VoiceMessageCollectionViewCell.baseWidth + addWidth! - 1, height: 1
        ))
        processBar?.trackTintColor = UIColor.white
        processBar?.progressTintColor = babyBlueColor
        processBar?.transform = CGAffineTransform(
            scaleX: 1.0,
            y: VoiceMessageCollectionViewCell.radius - 1
        )
        addSubview(processBar!)
        processBar?.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var contentSize: CGSize {
        get {
            return CGSize(
                width: VoiceMessageCollectionViewCell.baseWidth + addWidth!,
                height: bounds.size.height
            )
        }
    }
    
    // do nothing in keepLeft
    override func keepRight() {
        super.keepRight()
        processBar?.frame.origin.x = bounds.size.width
            - processBar!.frame.size.width - MessageCollectionViewCell.radius * 3
    }
    
}

extension VoiceMessageCollectionViewCell: UIGestureRecognizerDelegate {
}

extension VoiceMessageCollectionViewCell: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updater.invalidate()
        processBar?.isHidden = true
    }
    
}
