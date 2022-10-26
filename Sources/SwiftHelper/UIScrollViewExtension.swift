//
//  UIScrollViewExtension.swift
//  WiggleSDK
//
//  Created by pkh on 2018. 5. 23..
//  Copyright © 2018년 mykim. All rights reserved.
//

import Foundation
import UIKit

private var headerView_key : UInt8 = 0
private var footerView_key : UInt8 = 0
private var topInsetView_key : UInt8 = 0
private var headerViewIsSticky_key : UInt8 = 0
private var kvoOffsetCallback_key : UInt8 = 0
private var isAddOffsetObserver_key : UInt8 = 0
private var isAddInsetObserver_key : UInt8 = 0
private var isAddContentSizeObserver_key : UInt8 = 0
private var isAddHeaderViewFrameObserver_key : UInt8 = 0

//private var InsetContextTopBefore : UInt8 = 0

private var OffsetContext: UInt8 = 0
private var InsetContext: UInt8 = 0
private var SizeContext: UInt8 = 0
private var CustomHeaderViewHeightContext: UInt8 = 0

public typealias ScrollViewClosure = (_ value: UIScrollView) -> Void


extension UIScrollView {
    
    //MARK:- Observer를 중복으로 Add하는 방지를 위한 Bool 값들
    public var isAddOffsetObserver: Bool {
        get {
            if let result = objc_getAssociatedObject(self, &isAddOffsetObserver_key) as? Bool {
                return result
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &isAddOffsetObserver_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    public var isAddInsetObserver: Bool {
        get {
            if let result = objc_getAssociatedObject(self, &isAddInsetObserver_key) as? Bool {
                return result
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &isAddInsetObserver_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    public var isAddContentSizeObserver: Bool {
        get {
            if let result = objc_getAssociatedObject(self, &isAddContentSizeObserver_key) as? Bool {
                return result
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &isAddContentSizeObserver_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    public var isAddHeaderViewFrameObserver: Bool {
        get {
            if let result = objc_getAssociatedObject(self, &isAddHeaderViewFrameObserver_key) as? Bool {
                return result
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &isAddHeaderViewFrameObserver_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    //MARK:- Sticky Header
    public var headerViewIsSticky: Bool {
        get {
            if let result = objc_getAssociatedObject(self, &headerViewIsSticky_key) as? Bool {
                return result
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &headerViewIsSticky_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
//    private var insetContextTopBefore: CGFloat {
//        get {
//            if let result = objc_getAssociatedObject(self, InsetContextTopBefore_key) as? CGFloat {
//                return result
//            }
//            return contentInset.top
//        }
//        set {
//            objc_setAssociatedObject(self, InsetContextTopBefore_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        }
//    }
    
    //MARK:- Custom Header & Mall Footer
    public var customHeaderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &headerView_key) as? UIView
        }
        set {
            addObserverOffset()
            addObserverInset()
            
            var beforeViewHeight:CGFloat = 0
            if let customHeaderView = self.customHeaderView {
                removeObserverHeaderViewFrame()
                beforeViewHeight = customHeaderView.frame.size.height
                customHeaderView.removeFromSuperview()
            }
            
            objc_setAssociatedObject(self, &headerView_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let view = newValue else { return }
            view.autoresizingMask = .flexibleWidth
            view.frame.size.width = self.frame.size.width
            self.addSubview(view)

            self.contentInset = UIEdgeInsets(top: floor(self.contentInset.top + view.frame.size.height - beforeViewHeight), left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
           
            addObserverCustomHeaderViewFrame()
        }
    }
    
    public var customFooterView: UIView? {
        get {
            return objc_getAssociatedObject(self, &footerView_key) as? UIView
        }
        set {
            addObserverInset()
            addObserverContentSize()
            
            var beforeViewHeight:CGFloat = 0
            if let customFooterView = self.customFooterView {
                beforeViewHeight = customFooterView.frame.size.height
                customFooterView.removeFromSuperview()
            }
            
            objc_setAssociatedObject(self, &footerView_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let view = newValue else { return }
            view.frame.size.width = self.frame.size.width
            view.autoresizingMask = .flexibleWidth
            self.addSubview(view)
            
            self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: floor(self.contentInset.bottom + view.frame.size.height - beforeViewHeight), right: self.contentInset.right)
            
        }
    }
    
    //MARK:- Add Top Inset View
    public var topInsetView: UIView? {
        get {
            return objc_getAssociatedObject(self, &topInsetView_key) as? UIView
        }
        set {
            if let topInsetView = self.topInsetView, newValue == nil {
                self.contentInset = UIEdgeInsets(top: self.contentInset.top - topInsetView.frame.size.height, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
                topInsetView.removeFromSuperview()
            }
            objc_setAssociatedObject(self, &topInsetView_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    public func addTopInset(color: UIColor, height: CGFloat) {
        addObserverInset()
        
        if let topInsetView = self.topInsetView {
            topInsetView.frame.size.height = height
            topInsetView.backgroundColor = color
        }
        else {
            topInsetView = UIView(frame: CGRect(x: 0, y: -self.contentInset.top, w: self.frame.size.width, h: height))
            topInsetView?.autoresizingMask = .flexibleWidth
            topInsetView!.backgroundColor = color
            self.addSubview(topInsetView!)
        }
        
        self.contentInset = UIEdgeInsets(top: height + self.contentInset.top, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.bottom)
    }
    
    public func removeTopInset() {
        topInsetView = nil
    }
    
    //MARK:- Refresh Callback (Offset 값의 변화를 받은 뒤 처리)
    public func addKvoOffsetCallback(_ clousre: @escaping ScrollViewClosure) {
        self.addObserverOffset()
        if var clouserArray = objc_getAssociatedObject(self, &kvoOffsetCallback_key) as? [ScrollViewClosure] {
            clouserArray.append(clousre)
            objc_setAssociatedObject(self, &kvoOffsetCallback_key, clouserArray, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        else {
            var clouserArray = [ScrollViewClosure]()
            clouserArray.append(clousre)
            objc_setAssociatedObject(self, &kvoOffsetCallback_key, clouserArray, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    //MARK:- Refresh Callback (Offset 값의 변화를 받은 뒤 처리)
    public var kvoOffsetCallbacks: [ScrollViewClosure]? {
        return objc_getAssociatedObject(self, &kvoOffsetCallback_key) as? [ScrollViewClosure]
    }
    
    //MARK:- Inset Observer
    private func addObserverInset() {
        guard self.isAddInsetObserver == false else { return }
        self.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentInset), options: [.new, .old], context: &InsetContext)
        self.isAddInsetObserver = true
    }
    
    private func removeObserverInset() {
        guard self.isAddInsetObserver == true else { return }
        self.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentInset))
        self.isAddInsetObserver = false
    }
    
    //MARK:- Content Offset Observer
    private func addObserverOffset() {
        guard self.isAddOffsetObserver == false else { return }
        self.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: &OffsetContext)
        self.isAddOffsetObserver = true
    }
    
    private func removeObserverOffset() {
        guard self.isAddOffsetObserver == true else { return }
        self.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        self.isAddOffsetObserver = false
    }
    
    //MARK:- Content Size Observer
    private func addObserverContentSize() {
        guard self.isAddContentSizeObserver == false else { return }
        self.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [.new, .old], context: &SizeContext)
        self.isAddContentSizeObserver = true
    }
    
    private func removeObserverContentSize() {
        guard self.isAddContentSizeObserver == true else { return }
        self.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        self.isAddContentSizeObserver = false
    }
    
    
    //MARK:- HeaderView Frame Observer
    private func addObserverCustomHeaderViewFrame() {
        if let headerView = self.customHeaderView {
            guard self.isAddHeaderViewFrameObserver == false else { return }
            headerView.addObserver(self, forKeyPath: #keyPath(frame), options: [.new, .old], context: &CustomHeaderViewHeightContext)
            self.isAddHeaderViewFrameObserver = true
        }
    }
    
    private func removeObserverHeaderViewFrame() {
        if let headerView = self.customHeaderView {
            guard self.isAddHeaderViewFrameObserver == true else { return }
            headerView.removeObserver(self, forKeyPath: #keyPath(frame))
            self.isAddHeaderViewFrameObserver = false
        }
    }
    
    public func removeObserverAll() {
        removeObserverInset()
        removeObserverContentSize()
        addObserverCustomHeaderViewFrame()
        removeObserverHeaderViewFrame()
        removeObserverOffset()
    }
    
    
    // MARK: - KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // guard  let scrollView = object as? UIScrollView else { return }
        guard let newValue = change?[.newKey] as? NSValue, let oldValue = change?[.oldKey] as? NSValue else { return }
        
        if context == &CustomHeaderViewHeightContext {
            let new = newValue.cgRectValue.h
            let old = oldValue.cgRectValue.h
            
            guard new != old else { return }
            self.contentInset = UIEdgeInsets(top: floor(self.contentInset.top + new - old), left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
        
        else if context == &OffsetContext {
            
            if newValue.cgPointValue.y != oldValue.cgPointValue.y {
                if let kvoOffsetCallbacks = kvoOffsetCallbacks {
                    for clousre in kvoOffsetCallbacks {
                        clousre(self)
                    }
                }
                
            }
            
            guard let headerView = self.customHeaderView else { return }
            if self.headerViewIsSticky {
                let new = newValue.cgPointValue.y
                //            let old = oldValue.cgPointValue.y
                if new > -self.contentInset.top {
                    headerView.frame.origin.y = new // sticky
                }
                else {
                    headerView.frame.origin.y = -headerView.frame.size.height
                }
            }
            else {
                headerView.frame.origin.y = -headerView.frame.size.height
            }
            
        }
            
        else if context == &InsetContext {
            //            let new = newValue.uiEdgeInsetsValue.top
            //            let old = oldValue.uiEdgeInsetsValue.top
            if let headerView = self.customHeaderView {
                headerView.frame.origin.y = -headerView.frame.size.height
            }
            
            if let topInsetView = self.topInsetView {
                topInsetView.frame.origin.y = -self.contentInset.top
            }
            
            if let footerView = self.customFooterView {
                footerView.frame.origin.y = self.contentSize.height
            }
        }
        
        else if context == &SizeContext {
            if let footerView = self.customFooterView {
                footerView.frame.origin.y = self.contentSize.height
            }
        }
    
    }
    
}
