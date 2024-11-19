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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configuración inicial si es necesario
    }
}
