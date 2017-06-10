//
//  PVCommonCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class PVCommonCollectionViewCell: MessageCollectionViewCell {
    
    public static let maxWidth: CGFloat = 100
    
    // UIImage contains the data for an image.
    // UIImageView is a custom view meant to display the UIImage.
    let pictureView = { () -> UIImageView in
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    public var pictureSize: CGSize {
        get {
            return pictureView.frame.size
        }
        
        set(newSize) {
            pictureView.frame.size = newSize
        }
    }
    
    public func setHightlightColor() {
        var count = 0
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        let image = pictureView.image!
        let ys = Int(
            PVCommonCollectionViewCell.radius
                * 2.0 / bounds.height * image.size.height
        )
        for x in 0..<3 {
            for y in 0..<ys {
                count += 1
                let rgb = image.getPixelColor(
                    pos: CGPoint(x: CGFloat(x), y: CGFloat(y))
                )
                red += rgb.0
                green += rgb.1
                blue += rgb.2
            }
        }
        red = red / CGFloat(count * 255)
        green = green / CGFloat(count * 255)
        blue = blue / CGFloat(count * 255)
        self.highlightLayer.fillColor = UIColor(
            red: red, green: green,
            blue: blue, alpha: 1).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(pictureView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var contentSize: CGSize {
        get {
            return pictureSize
        }
    }
    
    override func keepLeft() {
        super.keepLeft()
        pictureView.frame.origin = CGPoint(x: MessageCollectionViewCell.radius * 3, y: 0)
    }
    
    override func keepRight() {
        super.keepRight()
        pictureView.frame.origin = CGPoint(x: bounds.size.width - pictureSize.width - MessageCollectionViewCell.radius * 3, y: 0)
    }
    
}
