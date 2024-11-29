import UIKit
import Combine
import Kingfisher

class HeroTableViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel = HeroesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(viewModel: HeroesViewModel = HeroesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroTableViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
}

// MARK: - UI Setup
private extension HeroTableViewController {
    func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        title = LocalizedStrings.Heroes.title
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "HeroTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 160
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Bindings
private extension HeroTableViewController {
    func setupBindings() {
        viewModel.$heroes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.animateTableView()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingIndicator.isHidden = !isLoading
                self?.tableView.isHidden = isLoading
                if isLoading {
                    self?.errorLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                self?.errorLabel.isHidden = !showError
                self?.errorLabel.text = LocalizedStrings.Heroes.heroesError
                self?.tableView.isHidden = showError
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
private extension HeroTableViewController {
    @objc func logoutTapped() {
        viewModel.logout()
        navigateToLogin()
    }
    
    func navigateToLogin() {
        navigationController?.setViewControllers([LoginViewController()], animated: true)
    }
}

// MARK: - Animations
private extension HeroTableViewController {
    func animateTableView() {
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        for (index, cell) in cells.enumerated() {
            let delay = Double(index) * 0.05
            cell.animateFromBottomWithBounce(yOffset: tableHeight, delay: delay)
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
    
    // HeroTableViewController.swift
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HeroTableViewCell else {
            return UITableViewCell()
        }
        
        // Reset the cell's state
        cell.photo.image = UIImage(named: "person")
        cell.title.text = nil
        
        let hero = viewModel.heroes[indexPath.row]
        cell.title.text = hero.name
        
        if let url = URL(string: hero.photo) {
            cell.photo.accessibilityIdentifier = hero.id.uuidString
            cell.photo.kf.setImage(
                with: url,
                placeholder: UIImage(named: "person"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HeroTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.animatePress {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    let selectedHero = self.viewModel.heroes[indexPath.row]
                    let detailViewModel = DetailsViewModel(hero: selectedHero)
                    let detailViewController = DetailsViewController(viewModel: detailViewModel)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                    tableView.isUserInteractionEnabled = true
                }
            }
        }
    }
}
