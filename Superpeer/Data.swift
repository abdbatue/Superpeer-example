//
//  Data.swift
//  Superpeer
//
//  Created by abdbatue on 19.09.2020.
//

import UIKit

struct Data {
    static let cornerRadius: CGFloat = 8
}

struct Device {
    static let screenSize = UIScreen.main.bounds
}

struct Colors {
    static let primary = UIColor.colorWithRGBHex(hex: 0x3488FA)
    static let white = UIColor.colorWithRGBHex(hex: 0xFFFFFF)
    static let gray10 = UIColor.colorWithRGBHex(hex: 0xF4F7FA)
    static let gray40 = UIColor.colorWithRGBHex(hex: 0xB9C3D4)
    static let gray80 = UIColor.colorWithRGBHex(hex: 0x818B9D)
    static let gray90 = UIColor.colorWithRGBHex(hex: 0x222222)
}

struct Fonts {
    static let bodyRegular = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let bodyBold = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let smallRegular = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let h3Bold = UIFont.systemFont(ofSize: 24, weight: .bold)
}

struct Icons {
    static let calendar = UIImage(named: "calendar")
    static let camera = UIImage(named: "camera")
    static let clock = UIImage(named: "clock")
    static let microphone = UIImage(named: "microphone")
    static let options = UIImage(named: "options")
    static let user = UIImage(named: "user")
}
