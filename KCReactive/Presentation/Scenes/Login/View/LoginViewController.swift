//
//  LoginViewController.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 14/11/24.
//

import UIKit
import Combine
import CombineCocoa

final class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stackViewConstraintY: NSLayoutConstraint!

    // MARK: - Properties
    private var user: String = ""
    private var password: String = ""
    private let passwordToggleButton = UIButton(type: .custom)
    private let viewModel = LoginViewModel()
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        registerKeyboardNotifications()
    }

    deinit {
        unregisterKeyboardNotifications()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        setupInitialUIState()
        setupLoginButton()
        configurePasswordToggleButton()
    }

    private func setupInitialUIState() {
        userTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
        loadingIndicator.startAnimating()
    }

    private func setupLoginButton() {
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 8
    }
    private func configurePasswordToggleButton() {
        let eyeImage = UIImage(systemName: "eye.slash.fill")
        passwordToggleButton.setImage(eyeImage, for: .normal)
        passwordToggleButton.tintColor = .gray
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        passwordToggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightViewContainer.addSubview(passwordToggleButton)

        passwordTextField.rightView = rightViewContainer
        passwordTextField.rightViewMode = .always
    }

    // MARK: - Bindings
    private func setupBindings() {
        bindTextFields()
        bindViewModelState()
        bindToastMessage()
        observeLoginButtonTap()
    }

    private func bindTextFields() {
        userTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user ?? ""
                self?.updateLoginButtonState()
            }
            .store(in: &subscriptions)

        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] password in
                self?.password = password ?? ""
                self?.updateLoginButtonState()
            }
            .store(in: &subscriptions)
    }

    private func bindViewModelState() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &subscriptions)
    }

    private func bindToastMessage() {
        viewModel.$userMessage
            .compactMap { $0 } // Ignorar valores nulos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] toastMessage in
                self?.showToast(message: toastMessage.message, isError: toastMessage.isError)
            }
            .store(in: &subscriptions)
    }

    private func observeLoginButtonTap() {
        loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task {
                    await self?.handleLogin()
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - Actions
    private func handleLogin() async {
        await viewModel.login(user: user, password: password)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeImageName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        let eyeImage = UIImage(systemName: eyeImageName)
        passwordToggleButton.setImage(eyeImage, for: .normal)

        if let existingText = passwordTextField.text, passwordTextField.isFirstResponder {
            passwordTextField.text = ""
            passwordTextField.insertText(existingText)
        }
    }

    // MARK: - State Handling
    private func handleStateChange(_ state: State) {
        switch state {
        case .loading:
            showLoading()
        case .showLogin:
            showLoginUI()
        case .navigateToHeroes:
            navigateToHeroes()
        }
    }

    // MARK: - UI Updates
    private func showLoading() {
        loadingIndicator.startAnimating()
        userTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
    }

    private func showLoginUI() {
        loadingIndicator.stopAnimating()
        userTextField.isHidden = false
        passwordTextField.isHidden = false
        loginButton.isHidden = false
        animateLoginUI()
    }

    private func updateLoginButtonState() {
        loginButton.isEnabled = !user.isEmpty && !password.isEmpty
    }

    private func showToast(message: String, isError: Bool) {
        let toast = ToastView()
        let backgroundColor: UIColor = isError ? .darkRed : .darkGreen
        toast.configure(message: message, backgroundColor: backgroundColor)
        toast.show(in: view)
    }

    private func navigateToHeroes() {
        let heroesVC = HeroTableViewController(nibName: "HeroTableViewController", bundle: nil)
        guard let navigationController = navigationController else {
            print("NavigationController no disponible")
            return
        }
        navigationController.setViewControllers([heroesVC], animated: true)
    }

    // MARK: - Animations
    private func animateLoginUI() {
        userTextField.alpha = 0
        passwordTextField.alpha = 0
        loginButton.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            self.userTextField.alpha = 1
            self.passwordTextField.alpha = 1
            self.loginButton.alpha = 1
        })
    }

    // MARK: - Keyboard Handling
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
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        stackViewConstraintY.constant = -keyboardHeight / 3

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        stackViewConstraintY.constant = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
