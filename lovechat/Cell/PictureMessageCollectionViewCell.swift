//
//  PictureMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Async
import SDWebImage

class PictureMessageCollectionViewCell: PVCommonCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gesture?.numberOfTapsRequired = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPicture(url: URL) {
        pictureView.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
            super.setHightlightColor()
        })
    }
    
    override func click(gestureRecognizer: UIGestureRecognizer) {
        if let picture = pictureView.image {
            delegate?.callSegueFromCell(data: picture)
        }
    }
    
}
