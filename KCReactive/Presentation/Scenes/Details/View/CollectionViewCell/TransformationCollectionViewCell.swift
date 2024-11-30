import UIKit
import Kingfisher

class TransformationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var transformationLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Configure containerView appearance
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.borderColor = UIColor.borderDarkAndLight.cgColor
        containerView.layer.borderWidth = 0.2
        
        // Add shadow to the cell
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        backgroundColor = .clear
        
        // Round top corners of the image view
        let maskPath = UIBezierPath(
            roundedRect: transformationImageView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 10, height: 10)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        transformationImageView.layer.mask = shape
        
        // Add a border to the image view
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.strokeColor = UIColor.borderDarkAndLight.cgColor
        borderLayer.lineWidth = 2
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = transformationImageView.bounds
        transformationImageView.layer.addSublayer(borderLayer)
        
        transformationImageView.clipsToBounds = true
    }
    
    // MARK: - Configuration
    /// Configures the cell with a `Transformation` model.
    /// - Parameter transformation: The transformation to display.
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
