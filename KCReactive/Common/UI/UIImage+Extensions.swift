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

        let placeholderImage = UIImage(named: "person")
        
        // Asignar el placeholder inicial en el hilo principal
        DispatchQueue.main.async {
            self.image = placeholderImage
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
