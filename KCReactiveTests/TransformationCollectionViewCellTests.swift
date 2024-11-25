//
//  TransformationCollectionViewCellTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class TransformationCollectionViewCellTests: XCTestCase {

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
