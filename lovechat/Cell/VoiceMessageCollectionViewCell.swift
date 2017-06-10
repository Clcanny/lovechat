//
//  VoiceMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceMessageCollectionViewCell: UICollectionViewCell {
    
    private static let baseWidth: CGFloat = 50
    public static let radius: CGFloat = 15
    
    public var addWidth: CGFloat?
    
    private var audioPlayer: AVAudioPlayer!
    fileprivate var updater: CADisplayLink!
    
    var gesture: UITapGestureRecognizer?
    var processBar: UIProgressView?
    func trackAudio() {
        let normalizedTime = Float(audioPlayer.currentTime * 1.0 / audioPlayer.duration)
        processBar?.setProgress(normalizedTime, animated: false)
    }
    var url: URL?
    func click(gestureRecognizer: UIGestureRecognizer) {
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
    
    private let avatar = { () -> UIImageView in
        var imageView = UIImageView()
        imageView.frame.size = CGSize(width: radius * 2, height: radius * 2)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = robinEggColor
        return imageView
    }()
    
    private let highlightLayer = { () -> CAShapeLayer in
        let layer = CAShapeLayer()
        layer.strokeColor = babyBlueColor.cgColor
        layer.lineWidth = 1
        layer.fillColor = babyBlueColor.cgColor
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(avatar)
        layer.addSublayer(highlightLayer)
        processBar = UIProgressView(frame: CGRect(
            x: VoiceMessageCollectionViewCell.radius * 3,
            y: 1  * VoiceMessageCollectionViewCell.radius - 1,
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
        
        gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(VoiceMessageCollectionViewCell.click(gestureRecognizer:))
        )
        addGestureRecognizer(gesture!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func keepLeft() {
        let radius = VoiceMessageCollectionViewCell.radius
        let borderWidth = VoiceMessageCollectionViewCell.baseWidth + radius * 3 + addWidth!
        
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: radius * 2, y: 0),
            radius: radius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false
        )
        path.addLine(to: CGPoint(x: borderWidth, y: 0))
        path.addLine(to: CGPoint(x: borderWidth, y: radius * 2))
        path.addLine(to: CGPoint(x: radius * 3, y: radius * 2))
        path.addArc(
            withCenter: CGPoint(x: radius * 2, y: radius * 2),
            radius: radius,
            startAngle: 0,
            endAngle: .pi / 2 * 3,
            clockwise: false
        )
        path.close()
        
        highlightLayer.path = path.cgPath
        
        avatar.frame.origin = .zero
    }
    
    public func keepRight() {
        let radius = VoiceMessageCollectionViewCell.radius
        let borderX = bounds.width - (radius * 3 + VoiceMessageCollectionViewCell.baseWidth + addWidth!)
        
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: bounds.width - radius * 2, y: 0),
            radius: radius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: false
        )
        path.addArc(
            withCenter: CGPoint(x: bounds.width - radius * 2, y: radius * 2),
            radius: radius,
            startAngle: .pi / 2 * 3,
            endAngle: .pi,
            clockwise: false
        )
        path.addLine(to: CGPoint(x: bounds.width - radius * 3, y: bounds.height))
        path.addLine(to: CGPoint(x: borderX, y: bounds.height))
        path.addLine(to: CGPoint(x: borderX, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - radius * 3, y: 0))
        path.close()
        
        highlightLayer.path = path.cgPath
        
        avatar.frame.origin = CGPoint(x: bounds.width - radius * 2, y: 0)
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
