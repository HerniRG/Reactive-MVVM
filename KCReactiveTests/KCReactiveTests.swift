//
//  KCReactiveTests.swift
//  KCReactiveTests
//
//  Created by Hernán Rodríguez on 14/11/24.
//

import XCTest
import Combine
import CombineCocoa
import UIKit
@testable import KCReactive

final class KCReactiveTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testKeyChainLibrary() throws {
        let tokenManager = TokenManager()
        
        // Verificar que el objeto se crea correctamente
        XCTAssertNotNil(tokenManager)
        
        // Guardar un token y verificar que se guardó correctamente
        tokenManager.saveToken("123")
        let savedToken = tokenManager.loadToken()
        XCTAssertNotNil(savedToken, "El token debería haberse guardado correctamente")
        XCTAssertEqual(savedToken, "123", "El token recuperado no coincide con el guardado")
        
        // Eliminar el token y verificar que se eliminó correctamente
        tokenManager.deleteToken()
        let deletedToken = tokenManager.loadToken()
        XCTAssertNil(deletedToken, "El token debería haberse eliminado correctamente")
    }
    
    func testLoginFake() async throws {
        let KC = TokenManager()
        XCTAssertNotNil(KC)
        
        // Crear instancia del caso de uso simulado
        let obj = LoginUseCaseFake()
        XCTAssertNotNil(obj)
        
        // Validar token antes del login
        let initialTokenState = KC.loadToken()
        XCTAssertNil(initialTokenState, "El token no debería existir antes del login")
        
        // Verificar si hay un token válido (simulado)
        let tokenCheck = obj.checkToken()
        XCTAssertEqual(tokenCheck, true, "checkToken() debería devolver true en el caso simulado")
        
        // Realizar login
        let loginResult = try await obj.loginApp(user: "fakeUser", password: "fakePassword")
        XCTAssertEqual(loginResult, true, "El login debería ser exitoso en el caso simulado")
        
        // Validar que el token fue guardado
        let jwt = KC.loadToken()
        XCTAssertNotNil(jwt, "El token debería haberse guardado después del login")
        XCTAssertEqual(jwt, "LoginFakeSuccess", "El token guardado debería ser 'LoginFakeSuccess'")
        
        // Cerrar sesión simulada (implementar eliminación de token en TokenManager)
        KC.deleteToken()
        let afterLogoutToken = KC.loadToken()
        XCTAssertNil(afterLogoutToken, "El token debería haberse eliminado después del logout")
    }
    
    func testLoginReal() async throws {
        // Instancia de KeyChain
        let KC = TokenManager()
        XCTAssertNotNil(KC, "TokenManager debería ser inicializable")
        
        // Reiniciar el token antes de comenzar la prueba
        KC.deleteToken()
        let initialToken = KC.loadToken()
        XCTAssertNil(initialToken, "El token debería ser nil después del reinicio")
        
        // Configurar las dependencias
        let network = NetworkLoginFake(scenario: .success)
        let repo = LoginRepositoryFake(network: network)
        let userCase = LoginUseCase(repo: repo)
        XCTAssertNotNil(userCase, "LoginUseCase debería ser inicializable")
        
        // Validación inicial de token
        let tokenValidation = userCase.checkToken()
        XCTAssertEqual(tokenValidation, false, "El token debería ser inválido al inicio")
        
        // Simular login
        let loginResult = try await userCase.loginApp(user: "testUser", password: "testPassword")
        XCTAssertEqual(loginResult, true, "El login debería ser exitoso en el caso simulado")
        
        // Verificar que el token se guardó correctamente
        var jwt = KC.loadToken()
        XCTAssertNotNil(jwt, "El token debería haberse guardado después del login")
        XCTAssertEqual(jwt, "LoginFakeSuccess", "El token guardado debería ser 'LoginFakeSuccess'")
        
        // Cerrar sesión
        KC.deleteToken()
        jwt = KC.loadToken()
        XCTAssertNil(jwt, "El token debería ser nil después del logout")
    }
    
    @MainActor
    func testLoginAutoLoginAsincrono() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = self.expectation(description: "Estado de login automático")
        
        let viewModel = LoginViewModel(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(viewModel)
        
        var didFulfill = false
        
        viewModel.$state
            .sink { state in
                print("Estado actual: \(state)")
                if state == .navigateToHeroes, !didFulfill {
                    didFulfill = true
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.triggerAutoLogin()
        
        waitForExpectations(timeout: 10)
    }
    
    @MainActor
    func testUIErrorView() async throws {
        // Crear una instancia de LoginUseCaseFake
        let loginUseCaseFake = LoginUseCaseFake()
        XCTAssertNotNil(loginUseCaseFake, "LoginUseCaseFake debería ser inicializable")
        
        // Crear una instancia de LoginViewModel usando el caso de uso falso
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        XCTAssertNotNil(loginViewModel, "LoginViewModel debería ser inicializable")
        
        // Simular un estado de error y mensaje en el ViewModel
        loginViewModel.userMessage = (message: "Error Testing", isError: true)
        
        // Crear el LoginViewController con el ViewModel simulado
        let loginViewController = LoginViewController()
        XCTAssertNotNil(loginViewController, "LoginViewController debería ser inicializable")
        
        // Cargar la vista del controlador
        loginViewController.loadViewIfNeeded()
        
        // Verificar que el mensaje de error se muestra correctamente
        if let userMessage = loginViewModel.userMessage {
            XCTAssertEqual(userMessage.message, "Error Testing", "El mensaje de error debería coincidir con el esperado")
            XCTAssertTrue(userMessage.isError, "El mensaje debería marcarse como error")
        } else {
            XCTFail("No se configuró el mensaje de error en el ViewModel")
        }
    }
    
    @MainActor
    func testUILoginViewInitialization() {
        // Crear instancia del LoginViewController
        let loginViewController = LoginViewController()
        XCTAssertNotNil(loginViewController, "El LoginViewController debería ser inicializable")
        
        // Cargar la vista del controlador
        loginViewController.loadViewIfNeeded()
        
        // Verificar que los elementos de la interfaz existen
        let userTextField = loginViewController.value(forKey: "userTextField") as? UITextField
        let passwordTextField = loginViewController.value(forKey: "passwordTextField") as? UITextField
        let loginButton = loginViewController.value(forKey: "loginButton") as? UIButton
        
        XCTAssertNotNil(userTextField, "El campo de texto de usuario debería existir")
        XCTAssertNotNil(passwordTextField, "El campo de texto de contraseña debería existir")
        XCTAssertNotNil(loginButton, "El botón de login debería existir")
        
        // Verificar el estado inicial
        XCTAssertTrue(userTextField?.isHidden ?? false, "El campo de usuario debería estar oculto inicialmente")
        XCTAssertTrue(passwordTextField?.isHidden ?? false, "El campo de contraseña debería estar oculto inicialmente")
        XCTAssertTrue(loginButton?.isHidden ?? false, "El botón de login debería estar oculto inicialmente")
    }
    
    // MARK: - Tests para HeroesViewModel
    @MainActor
    func testHeroViewModel() async throws {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "El HeroesViewModel debería ser inicializable")
        
        await viewModel.loadHeroes()
        XCTAssertEqual(viewModel.heroes.count, 2, "Debería haber 2 héroes en el caso simulado")
    }
    
    // MARK: - Tests para HeroUseCase
    
    func testHeroUseCase() async throws {
        let heroUseCase = HeroUseCase(heroRepo: HeroRepositoryFake(heroService: HeroServiceFake(scenario: .success) ))
        XCTAssertNotNil(heroUseCase, "HeroUseCase debería ser inicializable")
        
        let heroes = try await heroUseCase.getHeroes(filter: "")
        XCTAssertNotNil(heroes, "La respuesta de héroes no debería ser nil")
        XCTAssertEqual(heroes.count, 3, "Debería haber 3 héroes en el caso simulado")
    }
    
    // MARK: - Tests para Combine y HeroesViewModel
    
    @MainActor
    func testHeroesCombine() async throws {
        // Crear un Set para los suscriptores de Combine
        var subscriptions = Set<AnyCancellable>()
        
        // Crear una instancia del ViewModel
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "El HeroesViewModel debería ser inicializable")
        
        // Configurar una expectativa para esperar el resultado
        let expectation = XCTestExpectation(description: "Héroes obtenidos con Combine")
        
        // Suscribirse al publisher de héroes en el ViewModel
        viewModel.$heroes
            .sink { heroes in
                if heroes.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        // Simular la carga de héroes
        await viewModel.loadHeroes()
        
        // Esperar a que la expectativa se cumpla
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    // MARK: - Tests para HeroRepository
    
    func testHeroRepository() async throws {
        let networkFake = HeroServiceFake(scenario: .success)
        let heroRepository = DefaultHeroRepository(heroService: networkFake)
        XCTAssertNotNil(heroRepository, "HeroRepository debería ser inicializable")
        
        let heroes = try await heroRepository.getHeroes(filter: "")
        XCTAssertNotNil(heroes, "La respuesta de héroes no debería ser nil")
        XCTAssertEqual(heroes.count, 3, "Debería haber 3 héroes en el caso simulado")
    }
    
    // MARK: - Tests para modelos de dominio
    
    func testHeroDomainModel() {
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "url", favorite: true, transformations: nil)
        XCTAssertNotNil(hero, "El modelo de Hero debería ser inicializable")
        XCTAssertEqual(hero.name, "Goku", "El nombre del héroe debería ser 'Goku'")
        XCTAssertTrue((hero.favorite != nil), "El héroe debería estar marcado como favorito")
        
        let requestModel = HeroFilter(name: "Goku")
        XCTAssertNotNil(requestModel, "El modelo de filtro debería ser inicializable")
        XCTAssertEqual(requestModel.name, "Goku", "El filtro debería coincidir con el nombre proporcionado")
    }
    
    // MARK: - Tests para la presentación de HeroTableViewController
    
    @MainActor
    func testViewModelInitialization() async throws {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel debería ser inicializable")
        
        await viewModel.loadHeroes()
        XCTAssertEqual(viewModel.heroes.count, 2, "Debería haber 2 héroes simulados")
    }
    
    @MainActor
    func testViewModelEmptyHeroes() async throws {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel debería ser inicializable")
        
        await viewModel.loadHeroes(filter: "No existe")
        XCTAssertEqual(viewModel.heroes.count, 0, "No debería haber héroes con un filtro que no coincide")
    }
    
    @MainActor
    func testViewModelLogout() {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel debería ser inicializable")
        
        viewModel.logout()
        XCTAssertNil(TokenManager.shared.loadToken(), "El token debería eliminarse tras el logout")
    }
    
    // MARK: - Tests para DetailsViewModel
    @MainActor
    func testDetailsViewModelInitialization() async throws {
        // Crear un héroe simulado
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "https://example.com/goku.jpg", favorite: true, transformations: nil)
        
        // Crear un caso de uso simulado
        let useCase = TransformationUseCaseFake()
        
        // Inicializar el ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        XCTAssertNotNil(viewModel, "DetailsViewModel debería ser inicializable")
        XCTAssertEqual(viewModel.hero.name, "Goku", "El héroe debería ser 'Goku'")
        
        // Cargar las transformaciones
        await viewModel.loadTransformations()
        XCTAssertNotNil(viewModel.transformations, "Las transformaciones deberían haberse cargado")
        XCTAssertEqual(viewModel.transformations?.count, 2, "Debería haber 2 transformaciones simuladas")
    }
    
    
    // MARK: - Tests para DetailsViewController
    @MainActor
    func testDetailsViewControllerInitialization() throws {
        // Crear un héroe simulado
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "https://example.com/goku.jpg", favorite: true, transformations: nil)
        
        // Crear un caso de uso simulado
        let useCase = TransformationUseCaseFake()
        
        // Crear el ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        
        // Inicializar el ViewController
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        XCTAssertNotNil(detailsViewController, "DetailsViewController debería ser inicializable")
        
        // Cargar la vista
        detailsViewController.loadViewIfNeeded()
        
        // Verificar que los outlets existen
        XCTAssertNotNil(detailsViewController.value(forKey: "imageView") as? UIImageView, "El UIImageView debería existir")
        XCTAssertNotNil(detailsViewController.value(forKey: "descriptionLabel") as? UILabel, "El UILabel debería existir")
        XCTAssertNotNil(detailsViewController.value(forKey: "transformationsCollectionView") as? UICollectionView, "El UICollectionView debería existir")
    }
    
    @MainActor
    func testDetailsViewControllerBindings() async throws {
        // Crear un héroe simulado
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "https://example.com/goku.jpg", favorite: true, transformations: nil)
        
        // Crear un caso de uso simulado
        let useCase = TransformationUseCaseFake()
        
        // Crear el ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        
        // Inicializar el ViewController
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        detailsViewController.loadViewIfNeeded()
        
        // Verificar que los datos se actualizan correctamente
        await viewModel.loadTransformations()
        let collectionView = detailsViewController.value(forKey: "transformationsCollectionView") as? UICollectionView
        XCTAssertNotNil(collectionView, "El UICollectionView debería existir")
        XCTAssertEqual(collectionView?.numberOfItems(inSection: 0), 2, "El UICollectionView debería mostrar 2 transformaciones")
    }
    
    func testCellInitialization() {
        // Cargar el nib del HeroTableViewCell
        let nib = UINib(nibName: "HeroTableViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? HeroTableViewCell
        
        // Verificar que la celda se inicializa correctamente
        XCTAssertNotNil(cell, "HeroTableViewCell debería ser inicializable desde el nib")
    }
    
    func testCellOutletsConnection() {
        // Cargar el nib del HeroTableViewCell
        let nib = UINib(nibName: "HeroTableViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? HeroTableViewCell
        
        // Verificar que los outlets están conectados
        XCTAssertNotNil(cell?.title, "El UILabel para el título debería estar conectado")
        XCTAssertNotNil(cell?.photo, "El UIImageView para la foto debería estar conectado")
        XCTAssertNotNil(cell?.containerView, "El UIView del contenedor debería estar conectado")
    }
    
    func testUIConfiguration() {
        // Cargar el nib del HeroTableViewCell
        let nib = UINib(nibName: "HeroTableViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? HeroTableViewCell
        
        // Forzar la inicialización de la interfaz
        cell?.awakeFromNib()
        
        // Verificar configuraciones específicas del contenedor
        XCTAssertEqual(cell?.containerView.layer.cornerRadius, 12, "El contenedor debería tener bordes redondeados con radio de 12")
        XCTAssertTrue(cell?.containerView.layer.masksToBounds ?? false, "El contenedor debería recortar las subcapas a los bordes")
        XCTAssertEqual(cell?.containerView.backgroundColor, UIColor.systemGray6, "El contenedor debería tener fondo gris claro")
        
        // Verificar configuraciones específicas de la sombra
        XCTAssertEqual(cell?.layer.shadowColor, UIColor.black.cgColor, "La sombra debería ser negra")
        XCTAssertEqual(cell?.layer.shadowOpacity, 0.2, "La opacidad de la sombra debería ser 0.2")
        XCTAssertEqual(cell?.layer.shadowOffset, CGSize(width: 0, height: 4), "El desplazamiento de la sombra debería ser (0, 4)")
        XCTAssertEqual(cell?.layer.shadowRadius, 6, "El radio de la sombra debería ser 6")
        XCTAssertFalse(cell?.layer.masksToBounds ?? true, "La capa principal no debería recortar las sombras")
        
        // Verificar configuraciones específicas del título
        XCTAssertEqual(cell?.title.textColor, UIColor.systemGray, "El color del texto del título debería ser gris")
    }
    
    // MARK: - Tests de inicialización
    func testCollectionViewCellInitialization() {
        // Cargar el nib de TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Verificar que la celda se inicializa correctamente
        XCTAssertNotNil(cell, "TransformationCollectionViewCell debería ser inicializable desde el nib")
    }
    
    // MARK: - Tests de conexiones de outlets
    func testCollectionViewCellOutletsConnection() {
        // Cargar el nib de TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Verificar que los outlets están conectados
        XCTAssertNotNil(cell?.transformationImageView, "El UIImageView para la transformación debería estar conectado")
        XCTAssertNotNil(cell?.transformationLabel, "El UILabel para el nombre de la transformación debería estar conectado")
        XCTAssertNotNil(cell?.containerView, "El UIView del contenedor debería estar conectado")
    }
    
    // MARK: - Tests de configuración de la interfaz
    func testCollectionViewCellUIConfiguration() {
        // Cargar el nib de TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Forzar la inicialización de la interfaz
        cell?.awakeFromNib()
        
        // Verificar configuraciones específicas del contenedor
        XCTAssertEqual(cell?.containerView.layer.cornerRadius, 12, "El contenedor debería tener bordes redondeados con radio de 12")
        XCTAssertTrue(cell?.containerView.layer.masksToBounds ?? false, "El contenedor debería recortar las subcapas a los bordes")
        XCTAssertEqual(cell?.containerView.backgroundColor, UIColor.systemGray6, "El contenedor debería tener fondo gris claro")
        
        // Verificar configuraciones específicas de la sombra
        XCTAssertEqual(cell?.layer.shadowColor, UIColor.black.cgColor, "La sombra debería ser negra")
        XCTAssertEqual(cell?.layer.shadowOpacity, 0.1, "La opacidad de la sombra debería ser 0.1")
        XCTAssertEqual(cell?.layer.shadowOffset, CGSize(width: 0, height: 2), "El desplazamiento de la sombra debería ser (0, 2)")
        XCTAssertEqual(cell?.layer.shadowRadius, 4, "El radio de la sombra debería ser 4")
        XCTAssertFalse(cell?.layer.masksToBounds ?? true, "La capa principal no debería recortar las sombras")
        
        // Verificar configuraciones específicas de la imagen
        XCTAssertTrue(cell?.transformationImageView.clipsToBounds ?? false, "La imagen debería recortar contenido fuera de los bordes")
    }
    
    // MARK: - Tests de configuración de datos (para UICollectionView)
    func testCollectionViewCellConfigurationWithTransformation() {
        // Crear una transformación simulada
        let transformation = Transformation(
            id: UUID(),
            name: "Super Saiyan",
            description: "Primera transformación Saiyan.",
            photo: "https://example.com/super_saiyan.jpg"
        )
        
        // Cargar el nib de TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Configurar la celda con la transformación simulada
        cell?.configure(with: transformation)
        
        // Verificar que la celda muestra los datos correctamente
        XCTAssertEqual(cell?.transformationLabel.text, "Super Saiyan", "El label debería mostrar el nombre de la transformación")
    }
}
