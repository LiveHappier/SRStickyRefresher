//
//  SRActivityIndicatorViewable.swift
//  Pods
//
//  Created by Denis Laboureyras on 12/12/2016.
//
//

import Foundation
import UIKit

/**
 *  UIViewController conforms this protocol to be able to display NVActivityIndicatorView as UI blocker.
 *
 *  This extends abilities of UIViewController to display and remove UI blocker.
 */
public protocol SRActivityIndicatorViewable { }

public extension SRActivityIndicatorViewable where Self: UIViewController {
    
    /**
     Display UI blocker.
     
     Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter size:                 size of activity indicator view.
     - parameter message:              message displayed under activity indicator view.
     - parameter messageFont:          font of message displayed under activity indicator view.
     - parameter type:                 animation type.
     - parameter color:                color of activity indicator view.
     - parameter padding:              padding of activity indicator view.
     - parameter displayTimeThreshold: display time threshold to actually display UI blocker.
     - parameter minimumDisplayTime:   minimum display time of UI blocker.
     */
    public final func startAnimating(
        _ size: CGSize? = nil,
        message: String? = nil,
        messageFont: UIFont? = nil,
        color: UIColor? = nil,
        padding: CGFloat? = nil,
        displayTimeThreshold: Int? = nil,
        minimumDisplayTime: Int? = nil) {
        let activityData = SRActivityData(size: size,
                                        message: message,
                                        messageFont: messageFont,
                                        color: color,
                                        padding: padding,
                                        displayTimeThreshold: displayTimeThreshold,
                                        minimumDisplayTime: minimumDisplayTime)
        
        SRActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    /**
     Remove UI blocker.
     */
    public final func stopAnimating() {
        SRActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}