//
//  SRActivityIndicatorAnimationDelegate.swift
//  Pods
//
//  Created by Denis Laboureyras on 12/12/2016.
//
//

import Foundation
import UIKit

protocol SRActivityIndicatorAnimationDelegate {
    func setUpAnimation(in layer:CALayer, size: CGSize, color: UIColor, secondColor: UIColor)
    func setUpProgress(in layer: CALayer, size: CGSize, color: UIColor, progress: CGFloat, secondColor: UIColor)
}
