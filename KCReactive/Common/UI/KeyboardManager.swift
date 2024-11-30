import UIKit

// MARK: - KeyboardManager
// Manages the adjustment of a constraint when the keyboard is shown or hidden.

class KeyboardManager {
    // The constraint to adjust based on the keyboard's height.
    private var constraintToAdjust: NSLayoutConstraint?
    private weak var view: UIView? // The view to be updated during changes.

    // Initializes the manager with the given constraint and view.
    init(constraint: NSLayoutConstraint, view: UIView) {
        self.constraintToAdjust = constraint
        self.view = view
        registerKeyboardNotifications()
    }

    // Cleans up notifications when the instance is deallocated.
    deinit {
        unregisterKeyboardNotifications()
    }

    // MARK: - Keyboard Notifications
    // Registers keyboard notifications.
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // Unregisters keyboard notifications.
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Notification Handlers
    // Adjusts the constraint when the keyboard is shown.
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        // Adjusts the constraint constant based on the keyboard's height.
        constraintToAdjust?.constant = -keyboardFrame.height / 3
        animateLayoutChange()
    }

    // Resets the constraint when the keyboard is hidden.
    @objc private func keyboardWillHide(notification: Notification) {
        constraintToAdjust?.constant = 0
        animateLayoutChange()
    }

    // MARK: - Helper Methods
    // Animates layout updates for the view.
    private func animateLayoutChange() {
        UIView.animate(withDuration: 0.3) {
            self.view?.layoutIfNeeded()
        }
    }
}
