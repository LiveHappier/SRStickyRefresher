//
//  SRActivityIndicatorAnimationBallClipRotate.swift
//  Pods
//
//  Created by Soto Yanis on 17/03/2017.
//
//

import Foundation


class SRActivityIndicatorAnimationBallClipRotateMultiple: SRActivityIndicatorAnimationDelegate {
    internal func setUpProgress(in layer: CALayer, size: CGSize, color: UIColor, progress: CGFloat, secondColor: UIColor) {
        let bigCircleSize: CGFloat = size.width
        let _: CGFloat = (size.width / 100) * 90
        let longDuration: CFTimeInterval = 1
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        circleOf(shape: .ringWithGradient,
                 duration: longDuration,
                 timingFunction: timingFunction,
                 layer: layer,
                 size: bigCircleSize,
                 color: color, reverse: false,
                 progress: progress,
                 animated: false)
        
       /* circleOf(shape: .circle,
                 duration: longDuration,
                 timingFunction: timingFunction,
                 layer: layer,
                 size: smallCircleSize,
                 color: secondColor, reverse: false,
                 progress: progress,
                 animated: false) */
    }
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, secondColor: UIColor) {
        let bigCircleSize: CGFloat = size.width
        let _: CGFloat = (size.width / 100) * 90
        let longDuration: CFTimeInterval = 1
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        circleOf(shape: .ringWithGradient,
                 duration: longDuration,
                 timingFunction: timingFunction,
                 layer: layer,
                 size: bigCircleSize,
                 color: color, reverse: false,
                 progress: 0,
                 animated: true)
        
   /*     circleOf(shape: .circle,
                 duration: longDuration,
                 timingFunction: timingFunction,
                 layer: layer,
                 size: smallCircleSize,
                 color: secondColor, reverse: false,
                 progress: 0,
                 animated: true) */
    }
    
    func createAnimationIn(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction, reverse: Bool) -> CAAnimation {
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        rotateAnimation.timingFunctions = [timingFunction, timingFunction]
        if !reverse {
            rotateAnimation.values = [0, Double.pi, 2 * Double.pi]
        } else {
            rotateAnimation.values = [0, -Double.pi, -2 * Double.pi]
        }
        rotateAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        animation.animations = [rotateAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func circleOf(shape: SRActivityIndicatorShape, duration: CFTimeInterval, timingFunction: CAMediaTimingFunction, layer: CALayer, size: CGFloat, color: UIColor, reverse: Bool, progress: CGFloat, animated: Bool) {
        let circle = shape.layerWith(size: CGSize(width: size, height: size), color: color, progress: progress)
        let frame = CGRect(x: (layer.bounds.size.width - size) / 2,
                           y: (layer.bounds.size.height - size) / 2,
                           width: size,
                           height: size)
        circle.frame = frame
        if animated {
            let animation = createAnimationIn(duration: duration, timingFunction: timingFunction, reverse: reverse)
            circle.add(animation, forKey: "animation")
        }
        layer.addSublayer(circle)
    }
}
