//
//  AnimeFavoriteListViewModel.swift
//  FANime
//
//  Created by Alan Milke on 26/05/25.
//
import Foundation
import SwiftUI
import SwiftData

class AnimeFavoriteListViewModel: ObservableObject {
    
    var modelContext: ModelContext?
    var useDefaultNames: Bool = true
    
    var animes: [Anime] = [] {
        didSet {
            grouped = Dictionary(grouping: animes) {
                $0.broadcast_local?.day ?? $0.broadcast?.day ?? "N/A"
            }
            
            groupDays = grouped.keys.sorted()
        }
    }
    
    @Published var animesFinalizados: [Anime] = []
    @Published var animesProximos: [Anime] = []
    @Published var grouped: [String: [Anime]] = [:]
    @Published var groupDays: [String] = []

    let dias = Anime.BroadcastDays.allCases.map(\.rawValue)
        
    init() {
        self.useDefaultNames = UserDefaults.standard.bool(forKey: "useDefaultNames")
    }
    
    public func updateData() {
        guard let modelContext = self.modelContext else { return }
        
        let sort: SortDescriptor<Anime>
        if useDefaultNames {
            sort = SortDescriptor(\.titulo)
        } else {
            sort = SortDescriptor(\.titulo_default)
        }
        
        let descriptor = FetchDescriptor<Anime>(
            predicate: #Predicate<Anime> { $0.favorite && !$0.delete && $0.status != "Finished Airing" && $0.status != "Not yet aired" },
            sortBy: [sort])
        
        let descriptorFinalizados = FetchDescriptor<Anime>(
            predicate: #Predicate<Anime> { $0.favorite && !$0.delete && $0.status == "Finished Airing" },
            sortBy: [sort])
        
        let descriptorProximos = FetchDescriptor<Anime>(
            predicate: #Predicate<Anime> { $0.favorite && !$0.delete && $0.status == "Not yet aired" },
            sortBy: [sort])
        
        do {
            animes = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error)")
        }
        
        do {
            animesFinalizados = try modelContext.fetch(descriptorFinalizados)
        } catch {
            print("error: \(error)")
        }
        
        do {
            animesProximos = try modelContext.fetch(descriptorProximos)
        } catch {
            print("error: \(error)")
        }
        
    }
    
    static func makeContainerPreview(container: ModelContainer) -> some View {
        let context = ModelContext(container)
        
        Anime.getMockData(count: 10).forEach { item in
            context.insert(item)
        }

        return AnimeFavoriteListView()
            .modelContext(context)
    }
    
}
