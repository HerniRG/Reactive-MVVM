import UIKit

// MARK: - ToastView
/// Custom view to display temporary "toast" messages.
final class ToastView: UIView {
    
    // MARK: - Properties
    /// Label used to display the toast message.
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - View Configuration
    /// Configures the appearance and constraints of the view.
    private func setupView() {
        addSubview(messageLabel)
        backgroundColor = .black
        layer.cornerRadius = 4
        clipsToBounds = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Methods
    /// Configures the toast message and its background color.
    func configure(message: String, backgroundColor: UIColor) {
        self.messageLabel.text = message
        self.backgroundColor = backgroundColor
    }
    
    /// Displays the toast in a specific view and automatically hides it after a duration.
    func show(in view: UIView, duration: TimeInterval = 2.0) {
        view.addSubview(self)
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        // Fade-in and fade-out animations
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
