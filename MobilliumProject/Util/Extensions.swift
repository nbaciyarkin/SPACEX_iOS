//
//  ImageExtension.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 17.05.2022.
//

import Foundation
import Kingfisher
import UIKit

extension String {
    func expectedString(str: String?) -> String {
        var counter = 0
        var newStr = ""
        
         for i in str!  {
             newStr.append(i)
                counter += 1
                if counter == 10 {
                    break
                }
            }
         return newStr
    }
}

extension UIImageView {
    func setImage(_ imageUrl: String, placeHolder: String) {
        self.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: placeHolder))
    }
}
