//
//  SRStickyRefresherFlowLayoutAttributes.swift
//  Pods
//
//  Created by Denis Laboureyras on 08/12/2016.
//
//

import Foundation

public class SRStickyRefresherFlowLayoutAttributes: UICollectionViewLayoutAttributes {
 
    
    // 0 = minimized, 1 = fully expanded, > 1 = stretched
    public var progressiveness: CGFloat = 0.0;
    public var progressState: CGFloat = 0.0;
    var isInLoading = false;
    override public var zIndex: Int  {
        didSet {
            // Fixes: Section header go behind cell when insert via performBatchUpdates #68
            // https://github.com/jamztang/CSStickyHeaderFlowLayout/issues/68#issuecomment-108678022
            // Reference: UICollectionView setLayout:animated: not preserving zIndex
            // http://stackoverflow.com/questions/12659301/uicollectionview-setlayoutanimated-not-preserving-zindex
            
            // originally our solution is to translate the section header above the original z position,
            // however, scroll indicator will be covered by those cells and section header if z position is >= 1
            // so instead we translate the original cell to be -1, and make sure the cell are hit test proven.
            self.transform3D = CATransform3DMakeTranslation(0, 0, zIndex == 1 ? -1 : 0);
        }
    }
    
}
