//
//  SRRefreshState.swift
//  Pods
//
//  Created by Denis Laboureyras on 08/12/2016.
//
//

import Foundation

public enum SRRefreshState: Equatable, CustomStringConvertible {
    
    case initial
    case releasing(progress: CGFloat)
    case loading
    case finished
    
    public var description: String {
        switch self {
        case .initial: return "Inital"
        case .releasing(let progress): return "Releasing:\(progress)"
        case .loading: return "Loading"
        case .finished( _): return "Finished"
        }
    }
}

public func ==(a: SRRefreshState, b: SRRefreshState) -> Bool {
    switch (a, b) {
    case (.initial, .initial): return true
    case (.loading, .loading): return true
    case (.finished, .finished): return true
    case (.releasing, .releasing): return true
    default: return false
    }
}
