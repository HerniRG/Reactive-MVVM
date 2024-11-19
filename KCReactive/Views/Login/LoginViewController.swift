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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var password: String = ""
    private var user: String = ""
    private let vm = LoginViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    private func configureUI() {
        setupInitialUIState()
        observeTextFields()
    }
    
    private func setupInitialUIState() {
        errorLabel.text = ""
        errorLabel.isHidden = true
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
        bindStatus()
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
    
    private func bindStatus() {
        vm.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] statusString in
                self?.updateErrorLabel(with: statusString)
            }
            .store(in: &subscriptions)
    }
    
    private func observeLoginButtonTap() {
        loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleLogin()
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
        errorLabel.isHidden = true
    }
    
    private func showLoginUI() {
        loadingIndicator.stopAnimating()
        userTextField.isHidden = false
        passwordTextField.isHidden = false
        loginButton.isHidden = false
    }
    
    private func updateLoginButtonState() {
        loginButton.isEnabled = !user.isEmpty && !password.isEmpty
    }
    
    private func updateErrorLabel(with message: String) {
        errorLabel.text = message
        errorLabel.isHidden = message.isEmpty
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
    
    // MARK: - Actions
    private func handleLogin() {
        vm.login(user: user, password: password)
    }
}
