//
//  HeroTableViewCellTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class HeroTableViewCellTests: XCTestCase {
    
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
}
