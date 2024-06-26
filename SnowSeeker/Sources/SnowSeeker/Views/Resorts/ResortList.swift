//
//  ResortList.swift
//  SnowSeeker
//
//  Created by christian on 11/25/22.
//

import SwiftUI

struct ResortList: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    var sortedResorts: [Resort] {
        switch sortType {
        case .default:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { $0.name < $1.name }
        case .country:
            return filteredResorts.sorted { $0.country < $1.country }
        }
    }
 
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    
    enum SortType {
        case `default`, alphabetical, country
    }
    
    @State private var sortType = SortType.default
    @State private var showingSortOptions = false


    var body: some View {
        NavigationStack {
            List(sortedResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }

                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    showingSortOptions = true
                } label: {
                    Label("Change sort order", systemImage: "arrow.up.arrow.down.circle")
                }
            }
            .confirmationDialog("Sort order", isPresented: $showingSortOptions) {
                Button("Default") { sortType = .default }
                Button("Alphabetical") { sortType = .alphabetical }
                Button("By Country") { sortType = .country }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
//
//            WelcomeView()
        }
        
        .environmentObject(favorites)
    }
    

    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct ResortList_Previews: PreviewProvider {
    static var previews: some View {
        ResortList()
    }
}
