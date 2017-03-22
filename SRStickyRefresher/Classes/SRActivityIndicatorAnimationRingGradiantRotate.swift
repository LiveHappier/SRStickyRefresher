//
//  SRActivityIndicatorAnimationRingGradiantRotate.swift
//  Pods
//
//  Created by Soto Yanis on 22/03/2017.
//
//

import Foundation

class SRActivityIndicatorAnimationRingGradiantRotate: SRActivityIndicatorAnimationDelegate {
    internal func setUpProgress(in layer: CALayer, size: CGSize, color: UIColor, progress: CGFloat, secondColor: UIColor) {
    }
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, secondColor: UIColor) {
        
        let gradientRingLayer = WCGraintCircleLayer(bounds: layer.bounds, position: layer.position,fromColor:color, toColor:UIColor.white, linewidth:4.0, toValue:0)

        layer.addSublayer(gradientRingLayer)
        let duration = 3.0
        gradientRingLayer.animateCircleTo(duration: duration, fromValue: 0, toValue: 0.99)
        }
}
