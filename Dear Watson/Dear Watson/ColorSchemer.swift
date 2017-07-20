//
//  ColorSchemer.swift
//  WhiskBot
//
//  Created by whisk on 7/7/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

enum ColorMode{
    case Light
    case Dark
}

struct ColorSchemeKeys {
    static let colorSchemeStoreKey = "ColorSchemeKey"
    static let colorSchemeLight = "LightColorScheme"
    static let colorSchemeDark = "DarkColorScheme"
}

class ColorSchemer: NSObject {
    static let sharedInstance = ColorSchemer()
    let defaultColorScheme: String = ColorSchemeKeys.colorSchemeLight
    override init() {
        let defaults = UserDefaults.standard
        if let colorScheme = defaults.string(forKey: ColorSchemeKeys.colorSchemeStoreKey){
            if colorScheme == ColorSchemeKeys.colorSchemeLight{
                self.colorMode = .Light
            }else{
                self.colorMode = .Dark
            }
        }else{
            self.colorMode = .Light
        }
    }
    var colorMode: ColorMode = .Light{
        didSet{
            let defaults = UserDefaults.standard
            if colorMode == .Light{
                defaults.set(ColorSchemeKeys.colorSchemeLight, forKey: ColorSchemeKeys.colorSchemeStoreKey)
            }else{
                defaults.set(ColorSchemeKeys.colorSchemeDark, forKey: ColorSchemeKeys.colorSchemeStoreKey)
            }
        }
    }
}

extension UIViewController{
    func delay(delay:Double, closure: @escaping ()->()){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
