import UIKit
import Combine

class HeroTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var vm = HeroesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        configUI()
    }
    
    private func setupNavigationBar() {
        // Configuración del título
        self.title = "Héroes"
        
        // Configuración del botón de cerrar sesión
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), // Icono de cerrar sesión
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func logoutTapped() {
        // Borrar el token y volver al login
        vm.logout()
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        // Descartar el controlador actual y volver al login
        self.navigationController?.setViewControllers([LoginViewController()], animated: true)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "HeroTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configUI() {
        // Observar cambios en `heroes`
        vm.$heroes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Observar cambios en `isLoading`
        vm.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingIndicator.isHidden = !isLoading
                self?.tableView.isHidden = isLoading
                self?.errorLabel.isHidden = true // Ocultar mensaje de error durante la carga
            }
            .store(in: &cancellables)
        
        // Observar cambios en `showError`
        vm.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                self?.errorLabel.isHidden = !showError
                self?.errorLabel.text = "No se han cargado los héroes correctamente."
                self?.tableView.isHidden = showError
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell
        
        let hero = vm.heroes[indexPath.row]
        cell.title.text = hero.name
        if let url = URL(string: hero.photo) {
            cell.photo.loadImageRemote(url: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = vm.heroes[indexPath.row]
        let detailViewModel = DetailsViewModel(heroe: selectedHero)
        let detailViewController = DetailsViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
