//
//  SRStickyRefresherFlowLayout.swift
//  Pods
//
//  Created by Denis Laboureyras on 08/12/2016.
//
//

import Foundation

public let SRStickyHeaderParallaxHeader: String = "SRtickyHeaderParallexHeader";
let headerZIndex: Int = 1024;
let maxStreching = 1.3


public class SRStickyRefresherFlowLayout: UICollectionViewFlowLayout {
    
    public var parallaxHeaderReferenceSize: CGSize! {
        didSet {
            self.invalidateLayout();
        }
    };
    public var parallaxHeaderMinimumReferenceSize: CGSize!;
    public var parallaxHeaderAlwaysOnTop = true;
    public var disableStickyHeaders = false;
    public var disableStretching = false;
    
    override public func prepare(){
        super.prepare()
    }
    
    override public func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath), elementKind != SRStickyHeaderParallaxHeader else {return nil}
        
        var frame = attributes.frame;
        frame.origin.y += self.parallaxHeaderReferenceSize.height;
        attributes.frame = frame;
        
    
        return attributes;
    }
    
    override public func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if(elementKind == SRStickyHeaderParallaxHeader){
            if let attribute = self.layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath) as? SRStickyRefresherFlowLayoutAttributes {
                self.updateParallaxHeader(currentAttribute: attribute)
                return attribute;
            }
            
        } else{
            return super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        }
        
        return nil
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        if(attributes == nil && elementKind == SRStickyHeaderParallaxHeader) {
            return SRStickyRefresherFlowLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        }
        return attributes
    }
    
    
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard (self.collectionView?.dataSource) != nil else {return nil;}
        guard let cv = self.collectionView else {return nil;}
        
        // The rect should compensate the header size
        var adjustedRect = rect;
        adjustedRect.origin.y -= self.parallaxHeaderReferenceSize.height;
        
        var allItems:  [UICollectionViewLayoutAttributes] = [];
        let originalAttributes = super.layoutAttributesForElements(in: adjustedRect) ?? [];
        
        //Perform a deep copy of the attributes returned from super
        for originalAttribute in originalAttributes {
            allItems.append(originalAttribute)
        }
        var headers = [Int: UICollectionViewLayoutAttributes]();
        var lastCells = [Int: UICollectionViewLayoutAttributes]();
        var visibleParallexHeader = false;
        
        let maxHeight = self.parallaxHeaderReferenceSize.height;
        _ = self.parallaxHeaderMinimumReferenceSize.height;
        let loadingHeight = maxHeight * CGFloat(maxStreching)
        let offsetY = (!cv.isInLoading) ? self.parallaxHeaderReferenceSize.height : loadingHeight
        for (_, attributes) in allItems.enumerated() {
            var frame = attributes.frame;
            frame.origin.y += offsetY;
            attributes.frame = frame;
            
            let indexPath = attributes.indexPath;
            let isHeader = attributes.representedElementKind == UICollectionElementKindSectionHeader
            let isFooter = attributes.representedElementKind == UICollectionElementKindSectionFooter
            
            if (isHeader){
                headers[indexPath.section] = attributes;
            }else if (isFooter){
                // Not implemented
            }else {
                
                // Get the bottom most cell of that section
                if ( lastCells[indexPath.section] == nil) {
                    lastCells[indexPath.section] = attributes;
                }
                
                if let currentAttribute = lastCells[indexPath.section], indexPath.row > currentAttribute.indexPath.row {
                    lastCells[indexPath.section] = attributes;
                }
                
                
                
                if (indexPath.item == 0 && indexPath.section == 0) {
                    visibleParallexHeader = true;
                }
            }
            
            if (isHeader) {
                attributes.zIndex = headerZIndex;
            } else {
                // For iOS 7.0, the cell zIndex should be above sticky section header
                attributes.zIndex = 1;
            }
        };
        
        // when the visible rect is at top of the screen, make sure we see
        // the parallex header
        if (rect.minY <= 0) {
            visibleParallexHeader = true;
        }
        
        if (self.parallaxHeaderAlwaysOnTop == true) {
            visibleParallexHeader = true;
        }
        
        
        // This method may not be explicitly defined, default to 1
        // https://developer.apple.com/library/ios/documentation/uikit/reference/UICollectionViewDataSource_protocol/Reference/Reference.html#jumpTo_6
        //    NSUInteger numberOfSections = [self.collectionView.dataSource
        //                                   respondsToSelector:@selector(numberOfSectionsInCollectionView:)]
        //                                ? [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]
        //                                : 1;
        
        // Create the attributes for the Parallex header
        if (visibleParallexHeader && self.parallaxHeaderReferenceSize != CGSize.zero ) {
            if let currentAttribute = self.layoutAttributesForSupplementaryView(ofKind: SRStickyHeaderParallaxHeader, at:IndexPath()) as? SRStickyRefresherFlowLayoutAttributes {
                self.updateParallaxHeader(currentAttribute : currentAttribute);
                
                allItems.append(currentAttribute);
            }
            
        }
        
        if ( !self.disableStickyHeaders) {
            for (_, obj) in lastCells {
                let indexPath = obj.indexPath;
                let indexPathKey = indexPath.section;
                
                var header = headers[indexPathKey];
                // CollectionView automatically removes headers not in bounds
                if ( header == nil) {
                    let indexPathHeader = IndexPath(row : 0, section : indexPath.section)
                    header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPathHeader);
                
                    if let header = header, header.frame.size == CGSize.zero {
                        allItems.append(header);
                    }
                }
                
                if let header = header, header.frame.size == CGSize.zero, let lastCellAttributes = lastCells[indexPathKey] {
                    self.updateHeader(attributes: header, lastCellAttributes:lastCellAttributes);
                }
            };
        }
        
        // For debugging purpose
        //     [self debugLayoutAttributes:allItems];
        
        return allItems;
    }


    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {return nil;}
        var frame = attributes.frame;
        frame.origin.y += self.parallaxHeaderReferenceSize.height;
        attributes.frame = frame;
        return attributes;
    }
    
    override public var collectionViewContentSize: CGSize {
        // If not part of view hierarchy then return CGSizeZero (as in docs).
        // Call [super collectionViewContentSize] can cause EXC_BAD_ACCESS when collectionView has no superview.
        guard let _ = self.collectionView?.superview else {
            return CGSize.zero;
        }
        var size = super.collectionViewContentSize;
        size.height += self.parallaxHeaderReferenceSize.height;
        return size;
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
   
    

    //MARK : Helper
    
    func updateHeader(attributes : UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes)
    {
        guard let cv = self.collectionView else {return;}
        
        let currentBounds = cv.bounds;
        attributes.zIndex = headerZIndex;
        attributes.isHidden = false;
    
        var origin = attributes.frame.origin;
    
        let sectionMaxY = lastCellAttributes.frame.maxY - attributes.frame.size.height;
        var y = currentBounds.maxY - currentBounds.size.height + cv.contentInset.top;
    
        if (self.parallaxHeaderAlwaysOnTop) {
            y += self.parallaxHeaderMinimumReferenceSize.height;
        }
    
        let maxY = min(max(y, attributes.frame.origin.y), sectionMaxY);
    
        //    NSLog(@"%.2f, %.2f, %.2f", y, maxY, sectionMaxY);
    
        origin.y = maxY;
    
        attributes.frame = CGRect(
            origin: origin,
            size: attributes.frame.size
        );
    }
        

    
    func updateParallaxHeader(currentAttribute : SRStickyRefresherFlowLayoutAttributes) {
        guard let cv = self.collectionView else {return;}
    
        var frame = currentAttribute.frame;
        frame.size.width = self.parallaxHeaderReferenceSize.width;
        frame.size.height = self.parallaxHeaderReferenceSize.height;
        
        let bounds = cv.bounds;
        let maxY = frame.maxY;
        
        // make sure the frame won't be negative values
        var y = min(maxY - self.parallaxHeaderMinimumReferenceSize.height, bounds.origin.y + cv.contentInset.top);
        
        
        
        let maxHeight = self.parallaxHeaderReferenceSize.height;
        let minHeight = self.parallaxHeaderMinimumReferenceSize.height;
        let loadingHeight = maxHeight * CGFloat(maxStreching)
        let height = (!cv.isInLoading) ? min(max(0, -y + maxY), loadingHeight) :  loadingHeight;
        let progressiveness = (height - minHeight)/(maxHeight - minHeight);
        currentAttribute.progressiveness = progressiveness;
        let progressState = max((height - maxHeight), 0) / ( maxHeight * (CGFloat(maxStreching) - 1))
        currentAttribute.progressState = progressState
        // if zIndex < 0 would prevents tap from recognized right under navigation bar
        if(!cv.isInLoading){
            currentAttribute.zIndex = headerZIndex;
        }else{
            currentAttribute.zIndex = headerZIndex;
        }
        
        
        // When parallaxHeaderAlwaysOnTop is enabled, we will check when we should update the y position
        if (self.parallaxHeaderAlwaysOnTop && height <= self.parallaxHeaderMinimumReferenceSize.height) {
            let insetTop = cv.contentInset.top;
            // Always stick to top but under the nav bar
            y = cv.contentOffset.y + insetTop;
            currentAttribute.zIndex = 2000;
        }
        
        let finalHeight = self.disableStretching && height > maxHeight ? maxHeight : height
        
        
        currentAttribute.frame = CGRect(
            x: frame.origin.x,
            y: y,
            width: frame.size.width,
            height: finalHeight
        );
    }
    
    
    
    
}

