//
//  BNVertitalSplitViewController.swift
//  BNSegmented
//
//  Created by luojie on 16/7/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

open class BNVertitalSplitViewController: UIViewController {
    
    open var state = State.top {
        didSet { stateDidChange(old: oldValue, new: state) }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!

}

extension BNVertitalSplitViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        state = scrollView.contentOffset.y < 5 ? .top : .bottom
    }
    
    
    fileprivate func stateDidChange(old: State, new: State) {
        guard old != new else {
            return
        }
        switch new {
        case .top:      scrollView.scrollsTo(.top)
        case .bottom:   scrollView.scrollsTo(.bottom)
        }
    }
}

extension BNVertitalSplitViewController {
    public enum State {
        case top, bottom
    }
}


public protocol HasVertitalSplitViewController {}

public extension HasVertitalSplitViewController where Self: UIViewController {
    public var vertitalSplitViewController: BNVertitalSplitViewController? {
        return parentViewControllerWithType(BNVertitalSplitViewController.self)
    }
}

