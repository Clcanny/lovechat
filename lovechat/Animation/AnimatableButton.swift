//
//  Created by Jake Lin on 11/18/15.
//  Copyright © 2015 Jake Lin. All rights reserved.
//

import UIKit

@IBDesignable open class AnimatableButton: UIButton, CornerDesignable, FillDesignable, BorderDesignable, ShadowDesignable, MaskDesignable, Animatable {
    
    // MARK: - CornerDesignable
    @IBInspectable open var cornerRadius: CGFloat = CGFloat.nan {
        didSet {
            configCornerRadius()
        }
    }
    
    // MARK: - FillDesignable
    @IBInspectable open var fillColor: UIColor? {
        didSet {
            configFillColor()
        }
    }
    
    @IBInspectable open var predefinedColor: String? {
        didSet {
            configFillColor()
        }
    }
    
    @IBInspectable open var opacity: CGFloat = CGFloat.nan {
        didSet {
            configOpacity()
        }
    }
    
    // MARK: - BorderDesignable
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            configBorder()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = CGFloat.nan {
        didSet {
            configBorder()
        }
    }
    
    @IBInspectable open var borderSide: String? {
        didSet {
            configBorder()
        }
    }
    
    // MARK: - ShadowDesignable
    @IBInspectable open var shadowColor: UIColor? {
        didSet {
            configShadowColor()
        }
    }
    
    @IBInspectable open var shadowRadius: CGFloat = CGFloat.nan {
        didSet {
            configShadowRadius()
        }
    }
    
    @IBInspectable open var shadowOpacity: CGFloat = CGFloat.nan {
        didSet {
            configShadowOpacity()
        }
    }
    
    @IBInspectable open var shadowOffset: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan) {
        didSet {
            configShadowOffset()
        }
    }
    
    // MARK: - MaskDesignable
    @IBInspectable open var maskType: String? {
        didSet {
            configMask()
            configBorder()
        }
    }
    
    // MARK: - Animatable
    @IBInspectable open var animationType: String?
    @IBInspectable open var autoRun: Bool = true
    @IBInspectable open var duration: Double = Double.nan
    @IBInspectable open var delay: Double = Double.nan
    @IBInspectable open var damping: CGFloat = CGFloat.nan
    @IBInspectable open var velocity: CGFloat = CGFloat.nan
    @IBInspectable open var force: CGFloat = CGFloat.nan
    @IBInspectable open var repeatCount: Float = Float.nan
    @IBInspectable open var x: CGFloat = CGFloat.nan
    @IBInspectable open var y: CGFloat = CGFloat.nan
    
    // MARK: - Lifecycle
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configInspectableProperties()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        configInspectableProperties()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        configAfterLayoutSubviews()
        autoRunAnimation()
    }
    
    // MARK: - Private
    fileprivate func configInspectableProperties() {
        configAnimatableProperties()
    }
    
    fileprivate func configAfterLayoutSubviews() {
        configMask()
        configBorder()
    }
}
