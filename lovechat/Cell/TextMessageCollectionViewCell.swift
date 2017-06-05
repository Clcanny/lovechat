//
//  TextMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class TextMessageCollectionViewCell: UICollectionViewCell {
    
    public static let maxWidth: CGFloat = 100
    private static let radius: CGFloat = 15
    // Margin is on the outside of block elements while padding is on the inside.
    // Use margin to separate the block from things outside it.
    // Use padding to move the contents away from the edges of the block.
    public static let padding: CGFloat = 5
    
    private var gesture: UITapGestureRecognizer?
    func click(gestureRecognizer: UIGestureRecognizer) {
        delegate?.callSegueFromCell(data: text)
    }
    
    private let avatar = { () -> UIImageView in
        var imageView = UIImageView()
        imageView.frame.size = CGSize(width: radius * 2, height: radius * 2)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = robinEggColor
        return imageView
    }()
    
    private let textLabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = textMessageFont
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    public var text: String? {
        get {
            return textLabel.text
        }
        
        set(newText) {
            textLabel.text = newText
        }
    }
    // A view's frame (CGRect) is the position of its rectangle in the superview's coordinate system.
    // By default it starts at the top left.
    // A view's bounds (CGRect) expresses a view rectangle in its own coordinate system.
    // A center is a CGPoint expressed in terms of the superview's coordinate system
    // and it determines the position of the exact center point of the view.
    // frame.origin = center - (bounds.size / 2.0)
    // center = frame.origin + (bounds.size / 2.0)
    // frame.size = bounds.size
    // These relationships do not apply if views are rotated.
    public var textSize: CGSize {
        get {
            return textLabel.frame.size
        }
        
        set(newSize) {
            textLabel.frame.size = newSize
        }
    }
    
    private let highlightLayer = { () -> CAShapeLayer in
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 1
        return layer
    }()
    
    public var delegate: SegueFromCellProtocol?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(avatar)
        // The order is important.
        layer.addSublayer(highlightLayer)
        addSubview(textLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(TextMessageCollectionViewCell.click(gestureRecognizer:))
        )
        gesture?.numberOfTapsRequired = 2
        addGestureRecognizer(gesture!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func keepLeft() {
        let radius = TextMessageCollectionViewCell.radius
        let padding = TextMessageCollectionViewCell.padding
        let borderWidth = padding * 2 + radius * 3 + textLabel.frame.size.width
        
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
        
        highlightLayer.fillColor = ivoryColor.cgColor
        highlightLayer.path = path.cgPath
        
        avatar.frame.origin = .zero
        textLabel.frame.origin = CGPoint(x: padding + radius * 3, y: padding)
    }
    
    public func keepRight() {
        let radius = TextMessageCollectionViewCell.radius
        let padding = TextMessageCollectionViewCell.padding
        let borderX = bounds.width - (padding * 2 + radius * 3 + textLabel.frame.size.width)
        
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
        
        highlightLayer.fillColor = pastelGreenColor.cgColor
        highlightLayer.path = path.cgPath
        
        avatar.frame.origin = CGPoint(x: bounds.width - radius * 2, y: 0)
        textLabel.frame.origin = CGPoint(x: borderX + padding, y: padding)
    }
    
}
