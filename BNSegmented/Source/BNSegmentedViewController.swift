//
//  BNSegmentedViewController.swift
//  CustomSegement
//
//  Created by luojie on 15/12/24.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

open class BNSegmentedViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet open weak var segmentedControl: BNSegmentedControl!
    @IBOutlet open weak var scrollView: UIScrollView!
    
    open var selectedIndex: Int {
        get { return segmentedControl.selectedIndex }
        set { segmentedControl.selectedIndex = newValue }
    }
    
    open var selectedViewController: UIViewController {
        return viewControllersBySegueIdentifier[selectedIndex.segueIdentifier]!
    }
    
    @IBInspectable
    open var animationEnable: Bool = true
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offsetX = CGFloat(selectedIndex) * scrollView.bounds.width
        if offsetX != scrollView.contentOffset.x {
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        }
    }
    
    @IBAction open func changeViewController(_ sender: BNSegmentedControl) {
        performSafeSegueWithIdentifier(sender.selectedIndex.segueIdentifier, sender: sender)
        let offsetX = CGFloat(selectedIndex) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animationEnable)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
    open override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard viewControllersBySegueIdentifier[identifier] == nil else { return false }
        return identifier == selectedIndex.segueIdentifier
    }
    
    fileprivate var viewControllersBySegueIdentifier: [String: UIViewController] = [:]
    
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewControllersBySegueIdentifier[segue.identifier!] = segue.destination
    }
}

extension UIViewController {
    func performSafeSegueWithIdentifier(_ identifier: String, sender: AnyObject?) {
        guard shouldPerformSegue(withIdentifier: identifier, sender: sender) else { return }
        performSegue(withIdentifier: identifier, sender: sender)
    }
}

private extension Int {
    var segueIdentifier: String {
        return "EmbedVC\(self)"
    }
}
