//
//  PictureMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Async

class PictureMessageCollectionViewCell: UICollectionViewCell {
    
    public static let maxWidth: CGFloat = 100
    private static let radius: CGFloat = 15
    
    var delegate: SegueFromCellProtocol?
    private var gesture: UITapGestureRecognizer?
    func click(gestureRecognizer: UIGestureRecognizer) {
        delegate?.callSegueFromCell(data: picture)
    }
    
    private let avatar = { () -> UIImageView in
        var imageView = UIImageView()
        imageView.frame.size = CGSize(width: radius * 2, height: radius * 2)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = robinEggColor
        return imageView
    }()
    
    // UIImage contains the data for an image.
    // UIImageView is a custom view meant to display the UIImage.
    public let pictureView = { () -> UIImageView in
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    var picture: UIImage? {
        get {
            return pictureView.image
        }
        
        set(newPicture) {
            Async.background {
                self.backgroundColor = UIColor.black
                var count = 0
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                let ys = Int(
                    PictureMessageCollectionViewCell.radius
                        * 2.0 / self.bounds.height * (newPicture?.size.height)!
                )
                for x in 0..<3 {
                    for y in 0..<ys {
                        count += 1
                        let rgb = newPicture?.getPixelColor(
                            pos: CGPoint(x: CGFloat(x), y: CGFloat(y))
                        )
                        red += (rgb?.0)!
                        green += (rgb?.1)!
                        blue += (rgb?.2)!
                    }
                }
                self.backgroundColor = UIColor.green
                red = red / CGFloat(count * 255)
                green = green / CGFloat(count * 255)
                blue = blue / CGFloat(count * 255)
                self.highlightLayer.fillColor = UIColor(
                    red: red, green: green,
                    blue: blue, alpha: 1).cgColor
                self.pictureView.image = newPicture
                print("loaded image")
            }
        }
    }
    var pictureSize: CGSize {
        get {
            return pictureView.frame.size
        }
        
        set(newSize) {
            pictureView.frame.size = newSize
        }
    }
    
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
        // The order is important.
        layer.addSublayer(highlightLayer)
        addSubview(pictureView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(PictureMessageCollectionViewCell.click(gestureRecognizer:))
        )
        gesture?.numberOfTapsRequired = 2
        addGestureRecognizer(gesture!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func keepLeft() {
        let radius = PictureMessageCollectionViewCell.radius
        let borderWidth = radius * 3 + pictureView.frame.size.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: radius * 2, y: radius))
        path.addArc(
            withCenter: CGPoint(x: radius * 2, y: 0),
            radius: radius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false
        )
        path.addLine(to: CGPoint(x: borderWidth, y: 0))
        path.addLine(to: CGPoint(x: borderWidth, y: bounds.height))
        path.addLine(to: CGPoint(x: radius * 3, y: bounds.height))
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
        pictureView.frame.origin = CGPoint(x: radius * 3, y: 0)
    }
    
    public func keepRight() {
        let radius = PictureMessageCollectionViewCell.radius
        let borderX = bounds.width - (radius * 3 + pictureView.frame.size.width)
        
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
        pictureView.frame.origin = CGPoint(x: borderX, y: 0)
    }
    
}
