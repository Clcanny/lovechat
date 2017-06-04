//
//  TimeStampCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SnapKit

class TimeStampCollectionViewCell: UICollectionViewCell {
    
    let timeLable = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = icebergColor
        label.font = timeStampFont
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(timeLable)
        timeLable.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(contentView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
}
