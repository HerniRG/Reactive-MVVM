//
//  UIView+Animations.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 24/11/24.
//

import UIKit

extension UIView {
    
    // MARK: - Entrada/Transición
    
    /// Anima la vista con un desvanecimiento (fade-in).
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0) {
        self.alpha = 0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut) {
            self.alpha = 1
        }
    }
    
    /// Anima la entrada de una vista desde fuera de pantalla con un desplazamiento vertical y efecto de resorte.
    func animateFromBottomWithBounce(yOffset: CGFloat, delay: TimeInterval = 0.05, springDamping: CGFloat = 0.8, duration: TimeInterval = 1.0) {
        self.transform = CGAffineTransform(translationX: 0, y: yOffset)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.transform = .identity
            },
            completion: nil
        )
    }
    
    /// Anima la entrada de una vista desde fuera de pantalla con un desplazamiento vertical.
    func animateFromBottom(yOffset: CGFloat, duration: TimeInterval = 0.6, delay: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(translationX: 0, y: yOffset)
        self.isHidden = false // Asegura que la vista esté visible antes de animar
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseOut,
            animations: {
                self.transform = .identity // Restaura la posición original
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// Anima la entrada de una vista combinada con un desvanecimiento.
    func fadeInWithTranslation(yOffset: CGFloat, duration: TimeInterval = 0.5, delay: TimeInterval = 0) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: yOffset)
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: nil)
    }
    
    // MARK: - Salida
    
    /// Oculta una vista con un desplazamiento hacia fuera de pantalla.
    func animateAndHide(duration: TimeInterval = 0.6, completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }, completion: { _ in
            self.isHidden = true
            self.transform = .identity
            self.alpha = 1
            completion()
        })
    }
    
    // MARK: - Interacciones
    
    /// Anima una vista simulando un efecto de pulsación.
    func animatePress(scale: CGFloat = 0.95, duration: TimeInterval = 0.1, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            },
            completion: { _ in
                UIView.animate(withDuration: duration, animations: {
                    self.transform = .identity
                }, completion: { _ in
                    completion?()
                })
            }
        )
    }
}
