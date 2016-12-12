//
//  SRStickyRefresherView.swift
//  Pods
//
//  Created by Denis Laboureyras on 08/12/2016.
//
//

import Foundation


open class SRStickyRefresherView: UICollectionReusableView {
    
    
    weak open var collectionView: UICollectionView?;
    
    open var animator: SRRefreshAnimator?
    
    open var animationDuration: TimeInterval = 1
    open var hideDelay: TimeInterval = 0
    open var springDamping: CGFloat = 0.4
    open var initialSpringVelocity: CGFloat = 0.8
    open var animationOptions: UIViewAnimationOptions = [.curveLinear]
    
    open var action: (() -> ())?
    
    // MARK: - State
    
    open fileprivate(set) var state: SRRefreshState = .initial {
        didSet {
            animator?.animate(state)
            switch state {
            case .loading:
                if oldValue != .loading {
                    animateLoadingState()
                }
                
            case .finished:
                if isCurrentlyVisible() {
                    collectionView?.isInLoading = false;
                    animateFinishedState()
                } else {
                    state = .initial
                }
                
            default: break
            }
        }
    }
    
    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        if let layoutAttributes = layoutAttributes as? SRStickyRefresherFlowLayoutAttributes {
            
            
            let progress = layoutAttributes.progressState
            if(progress == 0){
                self.state = .initial
            }else if progress < 1{
                self.state = .releasing(progress: progress)
            }else {
                collectionView?.isInLoading = true;
                self.state = .loading
            }
            
            
        
        }
        
        
    }

}

// MARK: - Start/End Refreshin
public extension SRStickyRefresherView {
    
    open func startRefreshing() {
        if self.state != .initial {
            return
        }
        
        var offsetY: CGFloat
        
        //offsetY = -refreshView.frame.height - scrollViewDefaultInsets.top
       
        
        //scrollView?.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        let delayTime = DispatchTime.now() + Double(Int64(0.27 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            self?.state = .loading
        }
    }
    
    open func endRefreshing() {
        if state == .loading {
            state = .finished
            collectionView?.isInLoading = false;
        }
    }
}

// MARK: - Animate scroll view
private extension SRStickyRefresherView {
    
    func animateLoadingState() {
        
        
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
//                
//                    let insets = self.refreshView.frame.height + self.scrollViewDefaultInsets.top
//                    scrollView.contentInset.top = insets
//                    scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets)
                
               
        },
            completion: { _ in
//                scrollView.bounces = true
        }
        )
        
        action?()
    }
    
    func animateFinishedState() {
        
        UIView.animate(
            withDuration: animationDuration,
            delay: hideDelay,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: initialSpringVelocity,
            options: animationOptions,
            animations: {
                self.collectionView?.collectionViewLayout.invalidateLayout();
                self.collectionView?.layoutAttributesForSupplementaryElement(ofKind: SRStickyHeaderParallaxHeader, at: IndexPath(row: 0, section: 0))
//                self.scrollView?.contentInset = self.scrollViewDefaultInsets
//                if case .top = self.position {
//                    self.scrollView?.contentOffset.y = -self.scrollViewDefaultInsets.top
//                }
        },
            completion: { _ in
//                self.addScrollViewObserving()
//                self.state = .initial
        }
        )
    }
}


// MARK: - Helpers
private extension SRStickyRefresherView {
    
    func isCurrentlyVisible() -> Bool {
                
        return true
    }
}
