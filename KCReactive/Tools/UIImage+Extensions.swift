//
//  UIImage+Extensions.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageRemote(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
