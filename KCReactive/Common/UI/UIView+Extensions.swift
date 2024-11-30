import UIKit

extension UIView {
    
    // MARK: - Default Constants
    private enum AnimationDefaults {
        static let fadeDuration: TimeInterval = 0.5
        static let springDamping: CGFloat = 0.8
        static let defaultScale: CGFloat = 0.95
    }
    
    // MARK: - Entry/Transition Animations
    
    /// Animates the view with a fade-in effect.
    func fadeIn(duration: TimeInterval = AnimationDefaults.fadeDuration, delay: TimeInterval = 0.0) {
        self.alpha = 0
        animateView(duration: duration, delay: delay) {
            self.alpha = 1
        }
    }
    
    /// Animates the view entering from the bottom with a bounce effect.
    func animateFromBottomWithBounce(
        yOffset: CGFloat,
        delay: TimeInterval = 0.05,
        springDamping: CGFloat = AnimationDefaults.springDamping,
        duration: TimeInterval = 1.0
    ) {
        self.transform = CGAffineTransform(translationX: 0, y: yOffset)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.transform = .identity
            }
        )
    }
    
    /// Animates the view entering from the bottom.
    func animateFromBottom(
        yOffset: CGFloat,
        duration: TimeInterval = 0.6,
        delay: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        self.transform = CGAffineTransform(translationX: 0, y: yOffset)
        self.isHidden = false
        animateView(duration: duration, delay: delay, completion: completion) {
            self.transform = .identity
        }
    }
    
    /// Combines a fade-in effect with vertical translation.
    func fadeInWithTranslation(
        yOffset: CGFloat,
        duration: TimeInterval = AnimationDefaults.fadeDuration,
        delay: TimeInterval = 0
    ) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: yOffset)
        animateView(duration: duration, delay: delay) {
            self.alpha = 1
            self.transform = .identity
        }
    }
    
    // MARK: - Exit Animations
    
    /// Hides the view with a downward translation.
    func animateAndHide(duration: TimeInterval = 0.6, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
            },
            completion: { _ in
                self.isHidden = true
                self.alpha = 1
                self.transform = .identity
                completion?()
            }
        )
    }
    
    // MARK: - Interaction Animations
    
    /// Simulates a press effect on the view.
    func animatePress(
        scale: CGFloat = AnimationDefaults.defaultScale,
        duration: TimeInterval = 0.1,
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            },
            completion: { _ in
                UIView.animate(withDuration: duration, animations: {
                    self.transform = .identity
                }, completion: { _ in
                    completion?()
                })
            }
        )
    }
    
    // MARK: - Private Utility Methods
    
    /// Executes an animation block with specified parameters.
    private func animateView(
        duration: TimeInterval,
        delay: TimeInterval,
        completion: (() -> Void)? = nil,
        animations: @escaping () -> Void
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseOut,
            animations: animations,
            completion: { _ in
                completion?()
            }
        )
    }
}
