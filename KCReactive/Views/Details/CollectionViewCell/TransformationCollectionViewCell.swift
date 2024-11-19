//
//  TransformationCollectionViewCell.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import UIKit

class TransformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var transformationLabel: UILabel!
    
    
    func configure(with transformation: Transformation) {
        transformationLabel.text = transformation.name
        if let url = URL(string: transformation.photo) {
            transformationImageView.loadImageRemote(url: url)
        }
    }
}
