//
//  MessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    public static let radius: CGFloat = 15
    
    internal var delegate: SegueFromCellProtocol?
    
    var gesture: UITapGestureRecognizer?
    // abstract method
    func click(gestureRecognizer: UIGestureRecognizer) {
        fatalError()
    }
    
    private let avatar = { () -> UIImageView in
        var imageView = UIImageView()
        imageView.frame.size = CGSize(width: radius * 2, height: radius * 2)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = robinEggColor
        return imageView
    }()
    
    internal let highlightLayer = { () -> CAShapeLayer in
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        return layer
    }()
    // abstract method
    public func setHighlightColor() {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.addSublayer(highlightLayer)
        addSubview(avatar)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.click(gestureRecognizer:))
        )
        addGestureRecognizer(gesture!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // abstract method
    var contentSize: CGSize {
        get {
            fatalError()
        }
    }
    
    var isLeft: Bool?
    
    public func keepLeft() {
        isLeft = true
        
        let radius = MessageCollectionViewCell.radius
        let borderWidth = radius * 3 + contentSize.width
        
        let path = UIBezierPath()
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
    }
    
    public func keepRight() {
        isLeft = false
        
        let radius = MessageCollectionViewCell.radius
        let borderX = bounds.width - (radius * 3 + contentSize.width)
        
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
