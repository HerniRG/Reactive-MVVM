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
    }
    
    private func setupUI() {
        // Configuración del containerView
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.systemGray6

        // Añadir sombra al containerView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        backgroundColor = .clear

        // Configuración de la imagen con bordes redondeados selectivos
        let maskPath = UIBezierPath(
            roundedRect: photo.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft], // Solo esquinas izquierda arriba y abajo
            cornerRadii: CGSize(width: 10, height: 10)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        photo.layer.mask = shape

        // Añadir borde a la imagen
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.systemGray5.cgColor
        borderLayer.lineWidth = 2
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = photo.bounds
        photo.layer.addSublayer(borderLayer)

        photo.clipsToBounds = true
    }
}
