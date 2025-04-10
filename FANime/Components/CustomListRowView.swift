//
//  CustomList.swift
//  FANime
//
//  Created by Alan Milke on 09/04/25.
//

import SwiftUI

struct CustomListRowView: View {

    @State var rowContent: String
    @State var rowLabel: String
    @State var rowIcon: String
    @State var rowTintColor: Color
    
    @State var rowURL: String? = nil
    

    var body: some View {
        LabeledContent {
            if let rowURL {
                Link(rowContent, destination: URL(string: rowURL)!)
                    .tint(.pink)
                    .fontWeight(.heavy)
                
            } else {
                Text(rowContent)
                    .tint(.primary)
                    .fontWeight(.heavy)
            }
            
        } label: {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 30, height: 30)
                        .foregroundColor(rowTintColor)
                    Image(systemName: rowIcon)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                Text(rowLabel)
            }
            
        }
    }
}

#Preview {
    List {
        CustomListRowView(rowContent: "pojomx", rowLabel: "test", rowIcon: "cloud", rowTintColor: .pink)
    }
}
