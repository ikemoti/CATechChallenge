//
//  Extensions.swift
//  CATechChallenge
//
//  Created by Sousuke Ikemoto on 2020/09/17.
//  Copyright © 2020 Sousuke Ikemoto. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat.random(in: 0 ... 1),
                       green: CGFloat.random(in: 0 ... 1),
                       blue: CGFloat.random(in: 0 ... 1),
                       alpha: 1)
    }
}

extension UIImageView {
    func getFileName() -> String? {
        return self.image?.accessibilityIdentifier
    }
}



