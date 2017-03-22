//
//  HeaderView.swift
//  SRStickyRefresher
//
//  Created by Denis Laboureyras on 08/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SRStickyRefresher

class HeaderView: SRStickyRefresherView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var secondIndicator: SRActivityIndicatorView!
    
    let color  = UIColor(red: 0/255, green: 209/255, blue: 192/255, alpha: 1.0)
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if layoutAttributes is SRStickyRefresherFlowLayoutAttributes {
            UIView.beginAnimations("", context:nil);
            
            self.secondIndicator.color = color
            self.secondIndicator.color2 = self.backgroundColor!
            
            switch(self.state){
            case .initial:
               // print("initial")
                self.secondIndicator.progress = 1;
                self.secondIndicator.isHidden = true
                self.secondIndicator.stopAnimating()
                
                break;
            case .releasing(let progress):

                self.secondIndicator.isHidden = false
                self.secondIndicator.progress = Float(progress)
                break;
            case .finished:
                
                self.secondIndicator.isHidden = true;
                self.secondIndicator.stopAnimating()
                break;
            case .loading:
                self.secondIndicator.isHidden = false
                self.secondIndicator.startAnimating()
                break;
            }
            UIView.commitAnimations();
        }
    }
}
