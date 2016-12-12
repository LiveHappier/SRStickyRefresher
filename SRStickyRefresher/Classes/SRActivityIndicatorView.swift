//
//  SRActivityIndicatorView.swift
//  Pods
//
//  Created by Denis Laboureyras on 12/12/2016.
//
//

import Foundation

/// Activity indicator view with nice animations
public final class SRActivityIndicatorView: UIView {
    
    
    /// Default color. Default value is UIColor.whiteColor().
    public static var DEFAULT_COLOR = UIColor.white
    
    /// Default padding. Default value is 0.
    public static var DEFAULT_PADDING: CGFloat = 0
    
    /// Default size of activity indicator view in UI blocker. Default value is 60x60.
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
    
    /// Default display time threshold to actually display UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
    
    /// Default minimum display time of UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
    
    /// Default message displayed in UI blocker. Default value is nil.
    public static var DEFAULT_BLOCKER_MESSAGE: String? = nil
    
    /// Default font of message displayed in UI blocker. Default value is bold system font, size 20.
    public static var DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
    
    
    /// Color of activity indicator view.
    @IBInspectable public var color: UIColor = SRActivityIndicatorView.DEFAULT_COLOR
    
    /// Padding of activity indicator view.
    @IBInspectable public var padding: CGFloat = SRActivityIndicatorView.DEFAULT_PADDING
    
   
    /// Current status of animation, read-only.
    public private(set) var isAnimating: Bool = false
    
    /**
     Returns an object initialized from data in a given unarchiver.
     self, initialized using the data in decoder.
     
     - parameter decoder: an unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    /**
     Create a activity indicator view.
     
     Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter frame:   view's frame.
     - parameter type:    animation type.
     - parameter color:   color of activity indicator view.
     - parameter padding: padding of activity indicator view.
     
     - returns: The activity indicator view.
     */
    public init(frame: CGRect, color: UIColor? = nil, padding: CGFloat? = nil) {
        self.color = color ?? SRActivityIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? SRActivityIndicatorView.DEFAULT_PADDING
        super.init(frame: frame)
        isHidden = true
    }
    
    // Fix issue #62
    // Intrinsic content size is used in autolayout
    // that causes mislayout when using with MBProgressHUD.
    /**
     Returns the natural size for the receiving view, considering only properties of the view itself.
     
     A size indicating the natural size for the receiving view based on its intrinsic properties.
     
     - returns: A size indicating the natural size for the receiving view based on its intrinsic properties.
     */
    public override var intrinsicContentSize : CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    /**
     Start animating.
     */
    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
    }
    
    /**
     set progress.
     */
    public final var progress: Float = 0 {
        didSet {
            isHidden = false
            isAnimating = false
            setUpProgress(progress)
        }
    }

    
    /**
     Stop animating.
     */
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    
    
    // MARK: Privates
    
    private final func setUpProgress(_ progress : Float) {
        let animation: SRActivityIndicatorAnimationDelegate = SRActivityIndicatorAnimationLineSpinFadeLoader()
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpProgress(in: layer, size: animationRect.size, color: color, progress: progress)
    }
    
    private final func setUpAnimation() {
        let animation: SRActivityIndicatorAnimationDelegate = SRActivityIndicatorAnimationLineSpinFadeLoader()
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: color)
    }
}
