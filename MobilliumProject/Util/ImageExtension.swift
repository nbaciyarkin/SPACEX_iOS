//
//  ImageExtension.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 17.05.2022.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(_ imageUrl: String, placeHolder: String) {
        self.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: placeHolder))
    }
}
