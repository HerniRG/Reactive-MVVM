// UIImage+Extensions.swift

import UIKit

extension UIImageView {
    func loadImageRemote(url: URL) {
        let placeholderImage = UIImage(named: "person")
        
        // Assign the placeholder image
        DispatchQueue.main.async {
            self.image = placeholderImage
        }
        
        // Capture the current accessibilityIdentifier
        let currentIdentifier = self.accessibilityIdentifier
        
        // Load the image asynchronously
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // Check if the accessibilityIdentifier hasn't changed
                if self.accessibilityIdentifier == currentIdentifier {
                    // Use fade-in animation when assigning the new image
                    UIView.transition(
                        with: self,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.image = image
                        },
                        completion: nil
                    )
                }
            }
        }
    }
}
