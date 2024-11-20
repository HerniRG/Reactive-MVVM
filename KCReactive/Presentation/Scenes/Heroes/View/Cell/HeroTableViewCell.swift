//
//  HeroTableViewCell.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        performEntryAnimation() // Llama a la animación aquí si quieres que ocurra al cargarse
    }
    
    private func setupUI() {
        // Configuración del containerView
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.systemGray6 // Un gris claro más sobrio

        // Añadir sombra al containerView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2 // Sombra más marcada
        layer.shadowOffset = CGSize(width: 0, height: 4) // Mayor desplazamiento vertical
        layer.shadowRadius = 6 // Radio más amplio para una sombra más difusa
        layer.masksToBounds = false
        backgroundColor = .clear

        // Configuración de la imagen con bordes redondeados selectivos
        let maskPath = UIBezierPath(
            roundedRect: photo.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft], // Solo esquinas izquierda arriba y abajo
            cornerRadii: CGSize(width: 12, height: 12) // Bordes redondeados más suaves
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        photo.layer.mask = shape

        // Añadir borde a la imagen
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.systemGray4.cgColor // Gris claro para el borde
        borderLayer.lineWidth = 1.5
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = photo.bounds
        photo.layer.addSublayer(borderLayer)

        photo.clipsToBounds = true

        title.textColor = UIColor.systemGray
    }
    
    func performEntryAnimation() {
        // Configura la celda inicialmente fuera de pantalla
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 20) // Desplazamiento hacia abajo
        
        // Añade la animación
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform.identity // Vuelve a su posición original
        }, completion: nil)
    }
}
