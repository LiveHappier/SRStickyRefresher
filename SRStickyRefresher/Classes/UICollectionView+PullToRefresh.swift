//
//  UICollectionView+PullToRefresh.swift
//  Pods
//
//  Created by Denis Laboureyras on 08/12/2016.
//
//

import Foundation

func associatedObject<ValueType: Any>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}
func associateObject<ValueType: Any>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

private var isInLoadingKey: UInt8 = 0 // We still need this boilerplate

public extension UICollectionView {
    
    var isInLoading: Bool { // cat is *effectively* a stored property
        get {
            return associatedObject(base: self, key: &isInLoadingKey)
            { return false } // Set the initial value of the var
        }
        set { associateObject(base: self, key: &isInLoadingKey, value: newValue) }
    }
    
    public func addPullToRefresh(_ pullToRefresh: SRStickyRefresherView, action: @escaping () -> ()) {
        pullToRefresh.collectionView = self
        pullToRefresh.action = action
        
    }
}
