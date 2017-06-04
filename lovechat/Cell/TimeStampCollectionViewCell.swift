//
//  TimeStampCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class TimeStampCollectionViewCell: UICollectionViewCell {
    
    private let timeStampLabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = icebergColor
        label.font = timeStampFont
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    public var timeStamp: String? {
        get {
            return timeStampLabel.text
        }
        
        set(newText) {
            timeStampLabel.text = newText
        }
    }
    public var timeStampSize: CGSize {
        get {
            return timeStampLabel.frame.size
        }
        
        set(newSize) {
            timeStampLabel.frame.size = newSize
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(timeStampLabel)
        timeStampLabel.frame.origin = CGPoint(
            x: (bounds.width - timeStampSize.width) / 2,
            y: 0
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
}
