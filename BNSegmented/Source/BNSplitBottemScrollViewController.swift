//
//  BNSplitBottemScrollViewController.swift
//  BNSegmented
//
//  Created by luojie on 16/7/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

open class BNSplitBottemScrollViewController: UIViewController, HasVertitalSplitViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -10 {
            vertitalSplitViewController?.state = .top
        } else if scrollView.contentOffset.y > 10 {
            vertitalSplitViewController?.state = .bottom
        }
    }
    
}

