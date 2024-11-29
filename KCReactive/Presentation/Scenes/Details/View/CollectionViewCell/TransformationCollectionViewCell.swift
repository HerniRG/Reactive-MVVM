//
//  TransformationCollectionViewCell.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import UIKit
import Kingfisher

class TransformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var transformationLabel: UILabel!
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
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.2
        
        // Añadir sombra al containerView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        backgroundColor = .clear
        
        // Configuración de la imagen con bordes redondeados selectivos
        let maskPath = UIBezierPath(
            roundedRect: transformationImageView.bounds,
            byRoundingCorners: [.topLeft, .topRight], // Solo esquinas superiores
            cornerRadii: CGSize(width: 10, height: 10)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        transformationImageView.layer.mask = shape
        
        // Añadir borde a la imagen
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.systemGray5.cgColor
        borderLayer.lineWidth = 2
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = transformationImageView.bounds
        transformationImageView.layer.addSublayer(borderLayer)
        
        transformationImageView.clipsToBounds = true
    }
    
    func configure(with transformation: Transformation) {
        transformationLabel.text = transformation.name
        if let url = URL(string: transformation.photo) {
            transformationImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "person"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
    }
}
