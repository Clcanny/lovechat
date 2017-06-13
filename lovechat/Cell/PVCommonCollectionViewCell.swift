//
//  PVCommonCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SnapKit

class PVCommonCollectionViewCell: MessageCollectionViewCell {
    
    public static let maxWidth: CGFloat = 100
    
    // UIImage contains the data for an image.
    // UIImageView is a custom view meant to display the UIImage.
    let pictureView = { () -> UIImageView in
        var imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.backgroundColor = babyBlueColor
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
    
    let loadingView = { () -> UIActivityIndicatorView in
        let view = UIActivityIndicatorView()
        view.backgroundColor = UIColor.black
        view.contentMode = .scaleToFill
        view.activityIndicatorViewStyle = .whiteLarge
        view.frame.size = CGSize(
            width: PVCommonCollectionViewCell.maxWidth / 3,
            height: PVCommonCollectionViewCell.maxWidth / 3
        )
        return view
    }()
    
    public func setHightlightColor() {
        if let image = pictureView.image {
            let left = isLeft!
            var count = 0
            
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            let width = Int(image.size.width)
            
            let ys = Int(
                PVCommonCollectionViewCell.radius
                    * 2.0 / bounds.height * image.size.height
            )
            var xs: CountableRange<Int>!
            if left {
                xs = 0..<10
            }
            else {
                xs = (width - 10)..<width
            }
            
            for x in xs {
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
            highlightLayer.fillColor = UIColor(
                red: red, green: green,
                blue: blue, alpha: 1).cgColor
        }
        else {
            fatalError()
        }
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
            if pictureSize.height < PVCommonCollectionViewCell.maxWidth {
                return CGSize(
                    width: PVCommonCollectionViewCell.maxWidth,
                    height: PVCommonCollectionViewCell.maxWidth
                )
            }
            return pictureSize
        }
    }
    
    func keepHelper(center: CGPoint) {
        if pictureView.image == nil {
            highlightLayer.fillColor = babyBlueColor.cgColor
            addSubview(loadingView)
            loadingView.center = center
            loadingView.isHidden = false
            loadingView.startAnimating()
        }
        else {
            loadingView.stopAnimating()
            loadingView.isHidden = true
        }
    }
    
    override func keepLeft() {
        super.keepLeft()
        pictureView.frame.origin = CGPoint(x: MessageCollectionViewCell.radius * 3, y: 0)
        keepHelper(center: CGPoint(x: MessageCollectionViewCell.radius * 3 + PVCommonCollectionViewCell.maxWidth / 2, y: PVCommonCollectionViewCell.maxWidth / 2))
    }
    
    override func keepRight() {
        super.keepRight()
        pictureView.frame.origin = CGPoint(x: bounds.size.width - pictureSize.width - MessageCollectionViewCell.radius * 3, y: 0)
        keepHelper(center: CGPoint(x: bounds.width - MessageCollectionViewCell.radius * 3 - PVCommonCollectionViewCell.maxWidth / 2, y: PVCommonCollectionViewCell.maxWidth / 2))
    }
    
}
