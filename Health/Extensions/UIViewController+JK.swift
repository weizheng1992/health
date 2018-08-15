//
//  UIViewController+JK.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    public func alert(_ style: UIAlertControllerStyle, title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    public func showHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    public func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    public func showToast(_ toast: String, duration: Double) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = toast
        hud.label.numberOfLines = 0
        hud.hide(animated: true, afterDelay: duration)
    }
    
}
