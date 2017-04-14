//
//  SRActivityIndicatorShape.swift
//  Pods
//
//  Created by Denis Laboureyras on 12/12/2016.
//
//

import Foundation

enum SRActivityIndicatorShape {
    case circle
    case circleSemi
    case ring
    case ringTwoHalfVertical
    case ringTwoHalfHorizontal
    case ringThirdFour
    case rectangle
    case triangle
    case line
    case pacman
    case ringWithGradient
    
    func layerWith(size: CGSize, color: UIColor, progress: CGFloat = 2) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        
        
        switch self {
        case .circle:
            
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false);
            layer.fillColor = color.cgColor
        case .circleSemi:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-Double.pi / 6),
                        endAngle: CGFloat(-5 * Double.pi / 6),
                        clockwise: false)
            path.close()
            layer.fillColor = color.cgColor
        case .ring:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi * 2),
                        clockwise: false);
            
            layer.fillColor =  UIColor.clear.cgColor
            layer.strokeColor = UIColor.black.cgColor
            layer.lineWidth = lineWidth
            
        case .ringWithGradient:

            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(0),
                        endAngle:CGFloat(Double.pi * 2),
                        clockwise:false)
            
//            layer.fillColor =  nil
  //          layer.strokeColor = UIColor.green.cgColor
    //        layer.lineWidth = lineWidth
            
            //Gradient
            //let colorGradStart  = color
            //let colorGradEnd  = color.withAlphaComponent(0.6)
            
            let gradient = CAGradientLayer()
            gradient.bounds = CGRect(origin:CGPoint.zero, size: CGSize(width:layer.bounds.width/2,height:layer.bounds.height/2))
            
            
            gradient.frame = path.bounds
            gradient.colors = [UIColor.red, UIColor.white]
            layer.addSublayer(gradient)

            
            //gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            //gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
            //gradient.locations = [ 0.0, 1.0]

            let shapeMask = CAShapeLayer()
            shapeMask.position = layer.position
            shapeMask.path = path.cgPath
            shapeMask.bounds = layer.bounds
            shapeMask.strokeColor = UIColor.red.cgColor
            shapeMask.fillColor = UIColor.clear.cgColor
            shapeMask.lineWidth = lineWidth
            shapeMask.lineCap = kCALineCapRound
            shapeMask.strokeStart = 0.010
            shapeMask.strokeEnd = 0.99
            gradient.mask = shapeMask
            
            
            //shapeMask.fillColor = UIColor.clear.cgColor
            //shapeMask.strokeColor = UIColor.red.cgColor
            //shapeMask.lineWidth = 0.1
            
            
            //layer.insertSublayer(gradient, at: 0)
            layer.mask = shapeMask
            //layer.addSublayer(shapeMask)
            

        case .ringTwoHalfVertical:

            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(-3 * (Double.pi / 4)),
                        endAngle:CGFloat(-(Double.pi / 4)),
                        clockwise:true)
            path.move(
                to: CGPoint(x: size.width / 2 - size.width / 2 * CGFloat(cos(Double.pi / 4)),
                            y: size.height / 2 + size.height / 2 * CGFloat(sin(Double.pi / 4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(-5 * (Double.pi / 4)),
                        endAngle:CGFloat(-7 * (Double.pi / 4)),
                        clockwise:false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfHorizontal:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(3 * (Double.pi / 4)),
                        endAngle:CGFloat(5 * (Double.pi / 4)),
                        clockwise:true)
            path.move(
                to: CGPoint(x: size.width / 2 + size.width / 2 * CGFloat(cos(Double.pi / 4)),
                            y: size.height / 2 - size.height / 2 * CGFloat(sin(Double.pi / 4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius:size.width / 2,
                        startAngle:CGFloat(-(Double.pi / 4)),
                        endAngle:CGFloat(Double.pi / 4),
                        clockwise:true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringThirdFour:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(3 * Double.pi / 2),
                        endAngle: CGFloat(Double.pi),
                        clockwise: true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = 2
        case .rectangle:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            layer.fillColor = color.cgColor
        case .triangle:
            let offsetY = size.height / 4
            
            path.move(to: CGPoint(x: 0, y: size.height - offsetY))
            path.addLine(to: CGPoint(x: size.width / 2, y: size.height / 2 - offsetY))
            path.addLine(to: CGPoint(x: size.width, y: size.height - offsetY))
            path.close()
            layer.fillColor = color.cgColor
        case .line:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                cornerRadius: size.width / 2)
            layer.fillColor = color.cgColor
        case .pacman:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 4,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: true);
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = size.width / 2
        }
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }
    
    
    
    func graint(fromColor:UIColor, toColor:UIColor, count:Int) -> [UIColor]{
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        var result : [UIColor]! = [UIColor]()
        
        for i in 0...count {
            let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
            let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
            let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
            let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
            let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
            print(oneColor)
            
        }
        return result
    }
    
    func positionArrayWith(bounds:CGRect) -> [CGPoint]{
        let first = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*1)
        let second = CGPoint(x:(bounds.width/4)*3,y: (bounds.height/4)*3)
        let third = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*3)
        let fourth = CGPoint(x:(bounds.width/4)*1,y: (bounds.height/4)*1)
        print([first,second,third,fourth])
        return [first,second,third,fourth]
    }
    
    
    func startPoints() -> [CGPoint] {
        return [CGPoint.zero,CGPoint(x:1,y:0),CGPoint(x:1,y:1),CGPoint(x:0,y:1)]
    }
    
    func endPoints() -> [CGPoint] {
        return [CGPoint(x:1,y:1),CGPoint(x:0,y:1),CGPoint.zero,CGPoint(x:1,y:0)]
    }
    
    func midColorWithFromColor(fromColor:UIColor, toColor:UIColor, progress:CGFloat) -> UIColor {
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        let oneR = fromR + (toR - fromR) * progress
        let oneG = fromG + (toG - fromG) * progress
        let oneB = fromB + (toB - fromB) * progress
        let oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
        return oneColor
    }
    
    
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
