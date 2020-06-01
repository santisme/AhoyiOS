//
//  AhoyUIResources.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

enum FontStyle {
    case body14regular
    case body14bold
    case body18regular
    case body18bold
    case navigation16Bold
    case navigation16Black
    case caption14light
    case headline20medium
    case subtitle24semibold
    case title28bold
    case button16semibold
    case secondaryButton14regular
    case textField16regular
    case banner14semibold
}

enum Color: String {
    case ahoyMainBackgroundColor
    case ahoyMainTextColor
    case ahoyLigthBlue
    case ahoyRuby
    case ahoyYellow
    case ahoyButtonBackground
    case ahoySecondaryButtonBackground
    case ahoyButtonTextColor
    case ahoySecondaryButtonTextColor
    case ahoyCancelButtonBackground
    case ahoyGray
    case ahoyWhite
    case ahoyPlaceHolder
}

struct AhoyUIResources {
    
    static let factory: AhoyUIResources = AhoyUIResources()
    
    private init() { }
    
    func font(style: FontStyle) -> UIFont {
        let customFont: UIFont
        
        switch style {
        case .body18regular:
            customFont = UIFont(name: "SFProDisplay-Regular", size: 18.0) ??
                UIFont.systemFont(ofSize: 18.0)
        case .body18bold:
            customFont = UIFont(name: "SFProDisplay-Bold", size: 18.0) ??
                UIFont.systemFont(ofSize: 18.0)
        case .body14regular:
            customFont = UIFont(name: "SFProDisplay-Regular", size: 14.0) ??
                UIFont.systemFont(ofSize: 14.0)
        case .body14bold:
            customFont = UIFont(name: "SFProDisplay-Bold", size: 14.0) ??
                UIFont.systemFont(ofSize: 14.0)
        case .navigation16Bold:
                customFont = UIFont(name: "SFProDisplay-Bold", size: 16.0) ??
                    UIFont.systemFont(ofSize: 16.0)
        case .navigation16Black:
                customFont = UIFont(name: "SFProDisplay-Black", size: 16.0) ??
                    UIFont.systemFont(ofSize: 16.0)
        case .caption14light:
            customFont = UIFont(name: "SFProDisplay-Light", size: 14.0) ??
                UIFont.systemFont(ofSize: 14.0)
        case .headline20medium:
            customFont = UIFont(name: "SFProDisplay-Medium", size: 20.0) ??
                UIFont.systemFont(ofSize: 20.0)
        case .subtitle24semibold:
            customFont = UIFont(name: "SFProDisplay-SemiBold", size: 24.0) ??
                UIFont.systemFont(ofSize: 24.0)
        case .title28bold:
            customFont = UIFont(name: "SFProDisplay-Bold", size: 28.0) ??
                UIFont.boldSystemFont(ofSize: 28.0)
        case .button16semibold:
            customFont = UIFont(name: "SFProDisplay-SemiBold", size: 16.0) ??
                UIFont.systemFont(ofSize: 16.0)
        case .secondaryButton14regular:
            customFont = UIFont(name: "SFProDisplay-Regular", size: 14.0) ??
                UIFont.systemFont(ofSize: 14.0)
        case .textField16regular:
            customFont = UIFont(name: "SFProDisplay-Regular", size: 16.0) ??
                UIFont.systemFont(ofSize: 16.0)
        case .banner14semibold:
            customFont = UIFont(name: "SFProDisplay-SemiBold", size: 14.0) ??
                UIFont.boldSystemFont(ofSize: 14.0)
        }
        
        return customFont
    }
    
    func color(usage: Color) -> UIColor {
        switch usage {
        case .ahoyMainBackgroundColor:
            return UIColor(named: Color.ahoyMainBackgroundColor.rawValue) ?? UIColor.systemBackground
        case .ahoyMainTextColor:
            return UIColor(named: Color.ahoyMainTextColor.rawValue) ?? UIColor.darkText
        case .ahoyLigthBlue:
            return UIColor(named: Color.ahoyLigthBlue.rawValue) ?? UIColor.systemBlue
        case .ahoyRuby:
            return UIColor(named: Color.ahoyRuby.rawValue) ?? UIColor.systemRed
        case .ahoyYellow:
            return UIColor(named: Color.ahoyYellow.rawValue) ?? UIColor.systemYellow
        case .ahoyButtonBackground:
            return UIColor(named: Color.ahoyLigthBlue.rawValue) ?? UIColor.systemBlue
        case .ahoySecondaryButtonBackground:
            return UIColor.clear
        case .ahoyButtonTextColor:
            return UIColor(named: Color.ahoyWhite.rawValue) ?? UIColor.white
        case .ahoySecondaryButtonTextColor:
            return UIColor(named: Color.ahoyGray.rawValue) ?? UIColor.systemGray
        case .ahoyCancelButtonBackground:
            return UIColor(named: Color.ahoyRuby.rawValue) ?? UIColor.systemRed
        case .ahoyGray:
            return UIColor(named: Color.ahoyGray.rawValue) ?? UIColor.systemGray
        case .ahoyWhite:
            return UIColor(named: Color.ahoyWhite.rawValue) ?? UIColor.white
        case .ahoyPlaceHolder:
            return UIColor.placeholderText
        }
    }
}

enum Spacing {
    case leading
    case trailing
    case top
    case bottom
    case standard  // 8 px
    case standard2 // 16 px
    case standard3 // 24 px
}

