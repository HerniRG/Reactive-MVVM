import UIKit
import Combine

class HeroTableViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel = HeroesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
        setupErrorLabel()
    }
    
    private func setupNavigationBar() {
        // Configuración del título
        title = "Héroes"
        
        // Configuración del botón de cerrar sesión
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "HeroTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 160 // Establecer altura de fila
        
        // Remover separadores de líneas vacías
        tableView.tableFooterView = UIView()
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
    }
    
    private func setupBindings() {
        // Observar cambios en `heroes`
        viewModel.$heroes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.animateTableView()
            }
            .store(in: &cancellables)
        
        // Observar cambios en `isLoading`
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingIndicator.isHidden = !isLoading
                self?.tableView.isHidden = isLoading
                if isLoading {
                    self?.errorLabel.isHidden = true // Ocultar el errorLabel solo durante la carga
                }
            }
            .store(in: &cancellables)
        
        // Observar cambios en `showError`
        viewModel.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                self?.errorLabel.isHidden = !showError
                self?.errorLabel.text = "No se han cargado los héroes correctamente."
                self?.tableView.isHidden = showError
            }
            .store(in: &cancellables)
    }
    
    @objc private func logoutTapped() {
        // Borrar el token y volver al login
        viewModel.logout()
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        // Descartar el controlador actual y volver al login
        navigationController?.setViewControllers([LoginViewController()], animated: true)
    }
    
    private func animateTableView() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        
        // Mueve las celdas fuera de la pantalla
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        // Animar la entrada de las celdas
        var delayCounter = 0
        for cell in cells {
            UIView.animate(
                withDuration: 1.0,
                delay: Double(delayCounter) * 0.05,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
}

    // MARK: - UITableViewDataSource
extension HeroTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HeroTableViewCell else {
            return UITableViewCell()
        }
        
        let hero = viewModel.heroes[indexPath.row]
        cell.title.text = hero.name
        if let url = URL(string: hero.photo) {
            cell.photo.loadImageRemote(url: url)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

    // MARK: - UITableViewDelegate
extension HeroTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = viewModel.heroes[indexPath.row]
        let detailViewModel = DetailsViewModel(hero: selectedHero)
        let detailViewController = DetailsViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
