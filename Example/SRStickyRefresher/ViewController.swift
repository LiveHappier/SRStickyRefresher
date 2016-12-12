//
//  ViewController.swift
//  SRStickyRefresher
//
//  Created by DenisLaboureyras on 12/08/2016.
//  Copyright (c) 2016 DenisLaboureyras. All rights reserved.
//

import Foundation
import UIKit
import SRStickyRefresher

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!;
    var header: UINib!;
    
    fileprivate var layout : SRStickyRefresherFlowLayout? {
        return self.collectionView?.collectionViewLayout as? SRStickyRefresherFlowLayout
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        collectionView.collectionViewLayout = SRStickyRefresherFlowLayout();
        collectionView.backgroundColor = UIColor.clear
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let size = layout.itemSize
            let scale: CGFloat = 375 / 320
            layout.itemSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        }
        
        self.layout?.itemSize = CGSize(width: self.view.frame.size.width / 2 - 10, height: self.view.frame.size.width / 2 - 10)
        self.layout?.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        self.layout?.minimumLineSpacing = 6
        self.layout?.minimumInteritemSpacing = 0
        
        
        // Setup Header
        self.header = UINib(nibName: "Header", bundle: nil)
        
        self.collectionView?.register(self.header, forSupplementaryViewOfKind: SRStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        self.layout?.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.size.width, height: 328)
        self.layout?.parallaxHeaderMinimumReferenceSize = CGSize(width: self.view.frame.size.width, height: 150);
        self.layout?.parallaxHeaderAlwaysOnTop = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == SRStickyHeaderParallaxHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: SRStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader", for: indexPath) as? HeaderView {
                header.collectionView = self.collectionView;
                header.action = {
                    //print("refresh")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        //print("end Refreshing")
                        header.endRefreshing();
                    }
                }
                return header
            }
            
        }
        
        return UICollectionReusableView();
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "squareCell", for: indexPath)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }

    

}

