import Foundation

struct HeroService {
    
    /// Obtiene la lista de héroes con un filtro opcional.
    func getHeroes(filter: String) async throws -> [Hero] {
        let urlString = "\(server)\(Endpoints.heroesList.rawValue)"
        
        // Crear la solicitud usando BaseNetwork
        guard let request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            body: HeroFilter(name: filter)
        ) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Decodificar la respuesta
            let heroes = try JSONDecoder().decode([Hero].self, from: data)
            return heroes
        } catch {
            throw error // Propagar errores encontrados
        }
    }
    
    /// Obtiene las transformaciones de un héroe por su ID.
    func getTransformations(id: String) async throws -> [Transformation] {
        let urlString = "\(server)\(Endpoints.transformationsList.rawValue)"
        
        // Crear la solicitud usando BaseNetwork
        guard let request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            body: TransformationFilter(id: id)
        ) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // Decodificar la respuesta
            let transformations = try JSONDecoder().decode([Transformation].self, from: data)
            return transformations
        } catch {
            throw error // Propagar errores encontrados
        }
    }
}
