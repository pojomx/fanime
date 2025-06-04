//
//  AnimeListSeasonNavigatorView.swift
//  FANime
//
//  Created by Alan Milke on 04/06/25.
//

import SwiftUI

struct AnimeListSeasonNavigatorView: View {
    
    @StateObject
    var viewModel: AnimeListViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.btnPreviousSeason()
            } label: {
                Text(" < prev")
            }
            Spacer()
            VStack {
                Text(String(viewModel.queryYear))
                    .font(.caption)
                HStack {
                    Text("winter")
                        .font(.caption2)
                        .foregroundStyle(viewModel.querySeason == .winter ? .primary : .secondary)
                    Text("spring")
                        .font(.caption2)
                        .foregroundStyle(viewModel.querySeason == .spring ? .primary : .secondary)
                    Text("summer")
                        .font(.caption2)
                        .foregroundStyle(viewModel.querySeason == .summer ? .primary : .secondary)
                    Text("fall")
                        .font(.caption2)
                        .foregroundStyle(viewModel.querySeason == .fall ? .primary : .secondary)
                    Text("others")
                        .font(.caption2)
                        .foregroundStyle(viewModel.querySeason == .na ? .primary : .secondary)
                }
            }
            Spacer()
            Button {
                viewModel.btnNextSeason()
            } label: {
                Text("next >")
            }
        }
    }
}

#Preview {
    AnimeListSeasonNavigatorView(viewModel: AnimeListViewModel())
}
