//
//  VideoMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class VideoMessageCollectionViewCell: PVCommonCollectionViewCell {
    
    public var url: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gesture?.numberOfTapsRequired = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var image: UIImage? {
        get {
            return pictureView.image
        }
        
        set (newImage) {
            pictureView.image = newImage
            setHightlightColor()
        }
    }
    
    override func click(gestureRecognizer: UIGestureRecognizer) {
        if pictureView.image != nil {
            delegate?.callSegueFromCell(data: url)
        }
    }
    
}
