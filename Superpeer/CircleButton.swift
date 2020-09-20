//
//  CircleButton.swift
//  Superpeer
//
//  Created by abdbatue on 19.09.2020.
//

import UIKit

class CircleButton: UIButton {

    required init(image: UIImage) {
        super.init(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = Colors.gray10
        self.tintColor = Colors.gray90
        
        let iconImageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        iconImageView.frame.size.width = 20
        iconImageView.frame.size.height = 20
        iconImageView.center = self.center
        self.addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

