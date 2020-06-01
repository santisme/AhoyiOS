//
//  AhoyBannerProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol AhoyBannerProtocol {
    func showErrorBanner(message: String, on: UIViewController?)
    func showSuccessBanner(message: String, on: UIViewController?)
}

// MARK: - Extension AhoyBannerProtocol with default implementation
extension AhoyBannerProtocol {
    func showErrorBanner(message: String, on: UIViewController? = nil) {
        let banner = StatusBarNotificationBanner(title: message, style: .danger)
        banner.titleLabel?.font = AhoyUIResources.factory.font(style: .banner14semibold)
        banner.show(bannerPosition: .top, on: on)
        
    }
    
    func showSuccessBanner(message: String, on: UIViewController? = nil) {
        let banner = StatusBarNotificationBanner(title: message, style: .success)
        banner.titleLabel?.font = AhoyUIResources.factory.font(style: .banner14semibold)
        banner.show(bannerPosition: .top, on: on)
        
    }
}
