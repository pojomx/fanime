//
//  SettingsHistoryView.swift
//  FANime
//
//  Created by Alan Milke on 02/05/25.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

struct SettingsHistoryView: View {
    
    @ObservedObject
    var viewModel = SettingsHistoryViewModel()
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                CustomContentUnavailableView(
                    icon: "icloud.and.arrow.down",
                    title: "Downloading",
                    description: "\(viewModel.message)")
            } else {
                List(viewModel.jikanList) { item in
                    HStack {
                        Text(item.id)
                        Spacer()
                        Text("\(item.date)")
                            .font(.caption2)
                    }                    
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation{
                                viewModel.deleteItem(item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .tint(.secondary)
                        }
                    }
                }
                Button {
                    viewModel.downloadAllData()
                } label: {
                    Text("Regenerar base de datos...")
                }
                .disabled(viewModel.isDownloading)
            }
        }
        .onAppear() {
            viewModel.modelContext = modelContext
            viewModel.updateData()
        }
    }
}

#Preview {
    SettingsHistoryView()
}
