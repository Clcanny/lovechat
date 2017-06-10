//
//  TextMessageCollectionViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class TextMessageCollectionViewCell: MessageCollectionViewCell {
    
    public static let maxWidth: CGFloat = 150
    // Margin is on the outside of block elements while padding is on the inside.
    // Use margin to separate the block from things outside it.
    // Use padding to move the contents away from the edges of the block.
    public static let padding: CGFloat = 5
    
    override func click(gestureRecognizer: UIGestureRecognizer) {
        delegate?.callSegueFromCell(data: text)
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.strokeColor = UIColor.gray.cgColor
        addSubview(textLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gesture?.numberOfTapsRequired = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var contentSize: CGSize {
        get {
            let size = textSize
            return CGSize(
                width: size.width + TextMessageCollectionViewCell.padding * 2,
                height: size.height + TextMessageCollectionViewCell.padding * 2
            )
        }
    }
    
    override public func keepLeft() {
        super.keepLeft()
        
        highlightLayer.fillColor = UIColor.white.cgColor
        
        textLabel.frame.origin = CGPoint(
            x: TextMessageCollectionViewCell.padding + MessageCollectionViewCell.radius * 3,
            y: TextMessageCollectionViewCell.padding
        )
    }
    
    override public func keepRight() {
        super.keepRight()
        let radius = TextMessageCollectionViewCell.radius
        let padding = TextMessageCollectionViewCell.padding
        let borderX = bounds.width - (padding * 2 + radius * 3 + textLabel.frame.size.width)
        
        highlightLayer.fillColor = pastelGreenColor.cgColor
        
        textLabel.frame.origin = CGPoint(x: borderX + padding, y: padding)
    }
    
}
