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
    @IBOutlet weak var indicatorView: SRActivityIndicatorView!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let layoutAttributes = layoutAttributes as? SRStickyRefresherFlowLayoutAttributes {
            UIView.beginAnimations("", context:nil);
            
            
            switch(self.state){
            case .initial:
               // print("initial")
                self.indicatorView.progress = 0;
                self.indicatorView.isHidden = true;
                self.indicatorView.stopAnimating()
                break;
            case .releasing(let progress):
                //print("releasing \(progress)")
                self.indicatorView.isHidden = false;
                self.indicatorView.progress = Float(progress)
                break;
            case .finished:
                //print("finished")
                self.indicatorView.isHidden = true;
                self.indicatorView.stopAnimating()
                break;
            case .loading:
                //print("loading")
                self.indicatorView.isHidden = false;
                self.indicatorView.startAnimating()
                break;
            }
            
            
            
            UIView.commitAnimations();
        }
        
        
    }
    
}
