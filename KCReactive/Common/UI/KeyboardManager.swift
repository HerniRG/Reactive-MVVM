//
//  KeyboardManager.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 24/11/24.
//

import UIKit

class KeyboardManager {
    private var constraintToAdjust: NSLayoutConstraint?
    private weak var view: UIView?

    init(constraint: NSLayoutConstraint, view: UIView) {
        self.constraintToAdjust = constraint
        self.view = view
        registerKeyboardNotifications()
    }

    deinit {
        unregisterKeyboardNotifications()
    }

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

    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        constraintToAdjust?.constant = -keyboardFrame.height / 3
        UIView.animate(withDuration: 0.3) {
            self.view?.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        constraintToAdjust?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view?.layoutIfNeeded()
        }
    }
}
