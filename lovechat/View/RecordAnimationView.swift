//
//  RecordAnimationView.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

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
            imageView.frame.origin.x = width / 4
            imageView.frame.origin.y = 0
            imageView.image = newImage
        }
    }
    
    private let promptLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor.white
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
            promptLabel.frame.origin.x = (width - tsize.width) / 2
            promptLabel.frame.origin.y = imageView.frame.size.height + padding
            promptLabel.text = newPrompt
            promptLabel.textAlignment = .center
            
            bounds.size.width = width
            bounds.size.height = imageView.frame.size.height
                + promptLabel.frame.size.height + padding * 4
        }
    }
    
    override func layoutSubviews() {
        addSubview(imageView)
        addSubview(promptLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
