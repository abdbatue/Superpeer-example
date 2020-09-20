//
//  TestButton.swift
//  Superpeer
//
//  Created by abdbatue on 19.09.2020.
//

import UIKit

class TestButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = Data.cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.primary.cgColor
        self.titleLabel?.font = Fonts.bodyRegular
        self.setTitleColor(Colors.primary, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
