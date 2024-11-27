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
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Configuración del containerView
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.2
        
        // Añadir sombra al containerView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2 // Sombra más marcada
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false
        backgroundColor = .clear
        
        // Configuración de la imagen con bordes redondeados selectivos
        let maskPath = UIBezierPath(
            roundedRect: photo.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 12, height: 12)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        photo.layer.mask = shape
        
        // Añadir borde a la imagen
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.systemGray4.cgColor
        borderLayer.lineWidth = 1.5
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = photo.bounds
        photo.layer.addSublayer(borderLayer)
        
        photo.clipsToBounds = true
        
        title.textColor = UIColor.systemGray
    }
}
