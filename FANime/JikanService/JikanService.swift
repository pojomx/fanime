//
//  JikanService.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import Foundation
import Combine

protocol JikanServiceProtocol {
    //func getAnimeIdFull(id: Int) -> Future<JikanModel, Error>
    func getSeasonNow() -> Future<[JikanModel], Error>
}

class JikanService: ObservableObject {
    
    //Singleton
    static let shared = JikanService()
    private let baseURL = "https://api.jikan.moe/v4"
    
    @Published var anime: [JikanAnime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isComplete: Bool = false
    
    var has_next_page: Bool = true
    var currentPage: Int = 1
    var canRequest: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAnimeMockData() {
        let data = JikanModel.getMockData()
        self.errorMessage = "mock data"
        self.anime = [data!]
        self.has_next_page = false
        self.currentPage = 1
        self.canRequest = true
        self.isComplete = true
    }
    
    func getSeasonNow(page: Int = 1) -> Future<JikanModel, JikanServiceError> {
        return Future { promise in
            let urlString = "\(self.baseURL)/seasons/now?page=\(page)"
    
            //Validar URL
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    promise(.failure(.invalidUrl))
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(.unexpected(error)))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(.noData))
                    return
                }
                
                do {
                    print(String(data: data, encoding: .utf8) ?? "No data")
                    let decodeData = try JSONDecoder().decode(JikanModel.self, from: data)
                    promise(.success(decodeData))
                } catch {
                    print(error)
                    promise(.failure(.decodingError(error)))
                    return
                }
            }.resume()
        }
    }
    
    func fetchAnime() {
        //Previene ciclo infinito de peticiones
        guard !isLoading && has_next_page else { return }
        
        //Previene pedir demasiado rápido.
        guard canRequest else { return }
        
        isLoading = true
        isComplete = false
        
        if(!canRequest){
            return
        }
        
        JikanService.shared.getSeasonNow(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    switch(error) {
                    case .invalidUrl, .invalidResponse, .noData:
                        self.errorMessage = "Error"
                        break
                    case .decodingError(let error):
                        self.errorMessage = "Decoding Error: \(error.localizedDescription)"
                    case .urlSessionError(let error):
                        self.errorMessage = "urlSession Error. \(error.localizedDescription)"
                    case .unexpected(let error):
                        self.errorMessage = "Ocurrió un error inesperado. \(error.localizedDescription)"
                        break
                    }
                    break
                case .finished:
                    break
                }
                print(self.errorMessage ?? "")
            } receiveValue: { data in
                self.errorMessage = nil
                self.anime = data.data
                self.has_next_page = data.pagination?.has_next_page ?? false
                self.currentPage += 1
                self.canRequest = false
            
                if self.has_next_page {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.canRequest = true
                        // Request next page...
                        print("Aún hay anime por descargar...")
                        self.fetchAnime()
                        self.isComplete = false
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.canRequest = true
                        self.isComplete = true
                        print("Descarga completada...")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
