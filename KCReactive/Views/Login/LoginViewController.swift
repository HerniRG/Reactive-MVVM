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
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackViewConstraintY: NSLayoutConstraint!
    
    // MARK: - Properties
    private var user: String = ""
    private var password: String = ""
    private let vm = LoginViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        registerKeyboardNotifications()
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
    
    // MARK: - Setup Methods
    private func configureUI() {
        setupInitialUIState()
        observeTextFields()
    }
    
    private func setupInitialUIState() {
        loginButton.isHidden = true
        userTextField.isHidden = true
        passwordTextField.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    private func observeTextFields() {
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
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        bindState()
        bindToastMessage()
        observeLoginButtonTap()
    }
    
    private func bindState() {
        vm.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &subscriptions)
    }
    
    private func bindToastMessage() {
        vm.$toastMessage
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
    
    // MARK: - UI Updates
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
    }
    
    private func showToast(message: String, isError: Bool) {
        let toast = ToastView()
        let backgroundColor: UIColor = isError ? .darkRed : .darkGreen
        toast.configure(message: message, backgroundColor: backgroundColor)
        toast.show(in: view)
    }
    
    private func updateLoginButtonState() {
        loginButton.isEnabled = !user.isEmpty && !password.isEmpty
    }
    
    private func navigateToHeroes() {
        let herosVC = HeroTableViewController(nibName: "HeroTableViewController", bundle: nil)
        
        guard let navigationController = navigationController else {
            print("NavigationController no disponible")
            return
        }
        
        // Reemplazar la pila de vistas para evitar el botón "Back"
        navigationController.setViewControllers([herosVC], animated: true)
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Ajustar el desplazamiento
        let keyboardHeight = keyboardFrame.height
        stackViewConstraintY.constant = -keyboardHeight / 3 // Mueve el stackView hacia arriba (ajusta el divisor según necesidad)

        // Animación para hacer el cambio suave
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        // Restaurar la posición original del stackView
        stackViewConstraintY.constant = 0
        
        // Animación para hacer el cambio suave
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    private func handleLogin() async {
        await vm.login(user: user, password: password)
    }
}
