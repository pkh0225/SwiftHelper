//
//  UICollectionViewExtension.swift
//  WiggleSDK
//
//  Created by pkh on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    public func register(_ Class: UICollectionViewCell.Type) {
        register(Class, forCellWithReuseIdentifier: Class.className)
    }
    
    public func registerNibCell(_ Class: UICollectionViewCell.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forCellWithReuseIdentifier: Class.className)
    }
    
    public func registerNibCellHeader(_ Class: UICollectionReusableView.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className)
    }
    
    public func registerNibCellFooter(_ Class: UICollectionReusableView.Type) {
        register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className)
    }
    
    public func registerHeader(_ Class: UICollectionReusableView.Type) {
        register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className)
    }
    
    public func registerCustomKindReusableView(_ Class: UICollectionReusableView.Type, _ Kind: String, _ identifier: String) {
        register(Class, forSupplementaryViewOfKind: Kind, withReuseIdentifier: identifier)
    }
    
    public func registerFooter(_ Class: UICollectionReusableView.Type) {
        register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className)
    }
    
    public func dequeueReusableCell<T:UICollectionViewCell>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: Class.className, for: indexPath) as! T
    }
    
    public func dequeueReusableHeader<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className, for: indexPath) as! T
    }
    
    public func dequeueReusableFooter<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className, for: indexPath) as! T
    }
    
    public func dequeueDefaultSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
    }
    
    
}


