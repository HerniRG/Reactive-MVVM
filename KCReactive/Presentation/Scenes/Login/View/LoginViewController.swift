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
    private var keyboardManager: KeyboardManager?
    private var viewModel = LoginViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        keyboardManager = KeyboardManager(constraint: stackViewConstraintY, view: view)
    }
}

// MARK: - UI Setup
private extension LoginViewController {
    /// Sets up the initial UI configuration and elements.
    func setupUI() {
        setupInitialUIState()
        configurePasswordToggleButton()
    }

    /// Configures the initial UI state, including visibility and placeholders.
    func setupInitialUIState() {
        // Initial visibility setup
        userTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
        
        // Localized placeholders
        userTextField.placeholder = LocalizedStrings.Login.email
        passwordTextField.placeholder = LocalizedStrings.Login.password
        
        // Login button configuration
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 8
        loginButton.setTitle(LocalizedStrings.Login.loginButton, for: .normal)
        
        // Loading indicator setup
        loadingIndicator.startAnimating()
    }

    /// Configures the toggle button for password visibility.
    func configurePasswordToggleButton() {
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
}

// MARK: - Bindings
private extension LoginViewController {
    /// Sets up bindings between UI elements and the ViewModel.
    func setupBindings() {
        bindTextFields()
        bindViewModelState()
        bindToastMessage()
        observeLoginButtonTap()
    }
    
    /// Binds the text fields to update user and password variables.
    func bindTextFields() {
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
    
    /// Binds the ViewModel's state to the UI.
    func bindViewModelState() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &subscriptions)
    }
    
    /// Binds toast messages from the ViewModel to display in the UI.
    func bindToastMessage() {
        viewModel.$userMessage
            .compactMap { $0 } // Ignores nil values
            .receive(on: DispatchQueue.main)
            .sink { [weak self] toastMessage in
                self?.showToast(message: toastMessage.message, isError: toastMessage.isError)
            }
            .store(in: &subscriptions)
    }
    
    /// Observes taps on the login button and triggers login.
    func observeLoginButtonTap() {
        loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task {
                    await self?.handleLogin()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Actions
private extension LoginViewController {
    /// Handles the login action.
    func handleLogin() async {
        await viewModel.login(user: user, password: password)
    }
    
    /// Toggles password visibility for the password field.
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeImageName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        let eyeImage = UIImage(systemName: eyeImageName)
        passwordToggleButton.setImage(eyeImage, for: .normal)
        
        // Refreshes text to fix cursor position on visibility change
        if let existingText = passwordTextField.text, passwordTextField.isFirstResponder {
            passwordTextField.text = ""
            passwordTextField.insertText(existingText)
        }
    }
}

// MARK: - State Handling
private extension LoginViewController {
    /// Handles changes in the ViewModel's state.
    func handleStateChange(_ state: State) {
        switch state {
        case .loading:
            showLoading()
        case .showLogin:
            showLoginUI()
        case .navigateToHeroes:
            navigateToHeroes()
        }
    }
}

// MARK: - UI Updates
private extension LoginViewController {
    /// Updates the UI to display a loading state.
    func showLoading() {
        loadingIndicator.startAnimating()
        userTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
    }
    
    /// Updates the UI to display the login interface.
    func showLoginUI() {
        loadingIndicator.stopAnimating()
        userTextField.isHidden = false
        passwordTextField.isHidden = false
        loginButton.isHidden = false
        animateLoginUI()
    }
    
    /// Updates the login button state based on input validity.
    func updateLoginButtonState() {
        loginButton.isEnabled = !user.isEmpty && !password.isEmpty
    }
    
    /// Displays a toast message.
    func showToast(message: String, isError: Bool) {
        let toast = ToastView()
        let backgroundColor: UIColor = isError ? .darkRed : .darkGreen
        toast.configure(message: message, backgroundColor: backgroundColor)
        toast.show(in: view)
    }
    
    /// Navigates to the Heroes screen.
    func navigateToHeroes() {
        let heroesVC = HeroTableViewController()
        guard let navigationController = navigationController else {
            print("NavigationController not available")
            return
        }
        navigationController.setViewControllers([heroesVC], animated: true)
    }
    
    /// Animates the login UI elements with a fade-in effect.
    func animateLoginUI() {
        userTextField.fadeIn()
        passwordTextField.fadeIn()
        loginButton.fadeIn()
    }
}
