//
//  RecordAnimationView.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SnapKit

class RecordAnimationView: UIView {
    
    public static let width: CGFloat = 200
    private static let padding: CGFloat = 5

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let imageView = { () -> UIImageView in
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        
        set(newImage) {
            let width = RecordAnimationView.width
            
            imageView.frame.size.width = width / 2
            imageView.frame.size.height = imageView.frame.size.width
                / (newImage?.size.width)! * (newImage?.size.height)!

            imageView.image = newImage
            
            setNeedsLayout()
        }
    }
    
    private let countDownLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    private var countDown: Int {
        get {
            return Int(countDownLabel.text!.substring(with: 0..<2)) ?? -1
        }
        
        set(newCountDown) {
            if newCountDown == RecordAnimationView.recordTime {
                let width = RecordAnimationView.width
                let padding = RecordAnimationView.padding
                
                countDownLabel.text = String(newCountDown) + " seconds left"
                let tsize = textSize(maxWidth: width, text: countDownLabel.text!)
                countDownLabel.frame.size.height = tsize.height + padding * 2
                countDownLabel.frame.size.width = tsize.width + padding * 2
                
                setNeedsLayout()
            }
            else if newCountDown > 1 {
                countDownLabel.text = String(newCountDown) + " seconds left"
            }
            else if newCountDown == 1 {
                countDownLabel.text = String(newCountDown) + " second left"
            }
            else if newCountDown == 0 {
                countDownLabel.text = String(newCountDown) + " second left"
            }
        }
    }
    
    private static let recordTime = 10
    private var leftTime: Int?
    
    var timer: Timer?
    var delegate: TimeOutProtocol?
    public func beat() -> Void {
        leftTime = leftTime! - 1
        countDown = leftTime!
        if (leftTime == 0) {
            delegate!.stop(RecordAnimationView.recordTime)
        }
    }
    public func startCountDown() -> Void {
        leftTime = RecordAnimationView.recordTime
        countDown = leftTime!
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(beat),
            userInfo: nil,
            repeats: true
        )
    }
    public func stopCountDown() -> Int {
        timer = nil
        return RecordAnimationView.recordTime - leftTime!
    }
    
    private let promptLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    private var prompt: String? {
        get {
            return promptLabel.text
        }
        
        set(newPrompt) {
            let width = RecordAnimationView.width
            let padding = RecordAnimationView.padding
            
            let tsize = textSize(maxWidth: width, text: newPrompt!)
            promptLabel.frame.size.height = tsize.height + padding * 2
            promptLabel.frame.size.width = tsize.width + padding * 2

            promptLabel.text = newPrompt
            
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = RecordAnimationView.width
        let padding = RecordAnimationView.padding
        
        bounds.size.width = width
        bounds.size.height = imageView.frame.size.height
            + countDownLabel.frame.size.height
            + promptLabel.frame.size.height
            + padding * 2
        
        addSubview(imageView)
        imageView.frame.origin.x = width / 4
        imageView.frame.origin.y = padding
        
        addSubview(countDownLabel)
        countDownLabel.frame.origin.x = (width - countDownLabel.frame.width) / 2
        countDownLabel.frame.origin.y = imageView.frame.size.height + padding
        
        addSubview(promptLabel)
        promptLabel.frame.origin.x = (width - promptLabel.frame.size.width) / 2
        promptLabel.frame.origin.y = imageView.frame.size.height
            + countDownLabel.frame.size.height + padding
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = nil
        backgroundColor = opaqueColor(red: 106, green: 106, blue: 106)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
    public func recording() {
        image = #imageLiteral(resourceName: "recording")
        prompt = "Slide up to cancel"
        promptLabel.backgroundColor = UIColor.clear
    }
    
    public func readyToCancel() {
        image = #imageLiteral(resourceName: "readyToCancelRecord")
        prompt = "Release to cancel"
        promptLabel.backgroundColor = UIColor.red
    }

}
