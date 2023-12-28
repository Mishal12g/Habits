//
//  UIProgressHUD.swift
//  Habits
//
//  Created by mihail on 27.11.2023.
//

import ProgressHUD
import UIKit

final class UIProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate("Please wait...", .activityIndicator)
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
