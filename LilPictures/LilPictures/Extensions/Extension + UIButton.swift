//
//  Extension + UIButton.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import UIKit

extension UIButton {
    func dentAnimation() {
        let dent = CASpringAnimation(keyPath: "transform.scale")
        dent.fromValue = 1
        dent.toValue = 0.7
        dent.duration = 0.15
        dent.autoreverses = true
        layer.add(dent, forKey: nil)
    }
}
