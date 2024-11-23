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
        
        // Cargar la imagen de forma asíncrona
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Usar fade-in al asignar la nueva imagen
                    UIView.transition(
                        with: self!,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: {
                            self?.image = image
                        },
                        completion: nil
                    )
                }
            }
        }
    }
}
