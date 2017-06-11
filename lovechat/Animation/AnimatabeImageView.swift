//
//  Created by Jake Lin on 11/19/15.
//  Copyright © 2015 Jake Lin. All rights reserved.
//

import UIKit

@IBDesignable open class AnimatableImageView: UIImageView, CornerDesignable, FillDesignable, BorderDesignable, RotationDesignable, ShadowDesignable, BlurDesignable, TintDesignable, GradientDesignable, MaskDesignable, Animatable {
    
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
    
    // MARK: - RotationDesignable
    @IBInspectable open var rotate: CGFloat = CGFloat.nan {
        didSet {
            configRotate()
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
    
    // MARK: - BlurDesignable
    @IBInspectable open var blurEffectStyle: String? {
        didSet {
            configBlurEffectStyle()
        }
    }
    
    @IBInspectable open var vibrancyEffectStyle: String? {
        didSet {
            configBlurEffectStyle()
        }
    }
    
    @IBInspectable open var blurOpacity: CGFloat = CGFloat.nan {
        didSet {
            configBlurEffectStyle()
        }
    }
    
    // MARK: - TintDesignable
    @IBInspectable open var tintOpacity: CGFloat = CGFloat.nan
    @IBInspectable open var shadeOpacity: CGFloat = CGFloat.nan
    @IBInspectable open var toneColor: UIColor?
    @IBInspectable open var toneOpacity: CGFloat = CGFloat.nan
    
    // MARK: - GradientDesignable
    @IBInspectable open var startColor: UIColor?
    @IBInspectable open var endColor: UIColor?
    @IBInspectable open var predefinedGradient: String?
    @IBInspectable open var startPoint: String?
    
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
        configTintedColor()
    }
    
    fileprivate func configAfterLayoutSubviews() {
        configMask()
        configBorder()
        configGradient()
    }
    
}
