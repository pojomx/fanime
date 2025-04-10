//
//  CustomList.swift
//  FANime
//
//  Created by Alan Milke on 09/04/25.
//

import SwiftUI

struct CustomListRowView: View {

    @State var rowContent: String
    @State var rowContent2: String? = nil
    @State var rowURL: String? = nil
    @State var rowLabel: String
    @State var rowIcon: String
    @State var rowTintColor: Color

    var body: some View {
        LabeledContent {
            VStack (alignment: .trailing) {
                if let rowURL {
                    Link(rowContent, destination: URL(string: rowURL)!)
                        .tint(.pink)
                        .fontWeight(.medium)
                    
                } else {
                    Text(rowContent)
                        .tint(.primary)
                        .fontWeight(.medium)
                }
                if let rowContent2 = rowContent2 {
                    Text(rowContent2)
                        .tint(.pink)
                        .fontWeight(.light)
                        .font(.caption)
                }
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
        CustomListRowView(rowContent: "pojomx", rowLabel: "test", rowIcon: "cloud", rowTintColor: .red)
        CustomListRowView(rowContent: "pojomx", rowURL: "http://pojoclan.com", rowLabel: "URL", rowIcon: "link", rowTintColor: .blue)
        
        CustomListRowView(rowContent: "pojomx", rowContent2: "Test", rowURL: "http://pojoclan.com", rowLabel: "URL", rowIcon: "link", rowTintColor: .blue)

    }
}
