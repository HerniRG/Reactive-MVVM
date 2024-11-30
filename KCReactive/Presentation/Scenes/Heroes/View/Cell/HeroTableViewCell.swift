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
        // Configure containerView appearance
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.borderColor = UIColor.borderDarkAndLight.cgColor
        containerView.layer.borderWidth = 0.2
        
        // Add shadow to containerView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false
        backgroundColor = .clear
        
        // Configure selective rounded corners for the photo
        let maskPath = UIBezierPath(
            roundedRect: photo.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 12, height: 12)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        photo.layer.mask = shape
        
        // Add border to the photo
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.borderDarkAndLight.cgColor
        borderLayer.lineWidth = 1.5
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = photo.bounds
        photo.layer.addSublayer(borderLayer)
        
        // Ensure the photo respects clipping
        photo.clipsToBounds = true
        
        // Configure title text color
        title.textColor = UIColor.systemGray
    }
}
