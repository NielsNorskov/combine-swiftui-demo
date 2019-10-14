//
//  ContentView.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 12/10/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var searchWord = ""
    @State var searchItemListVM = SearchItemListViewModel([])
    @State var fetchJSONSubscriber: AnyCancellable? // ???
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search NASA images", text: $searchWord)
                    Button(action: {
                        print("searching for \(self.searchWord)")
                        self.performSearch(for: self.searchWord)
                    }) {
                        Text("Search")
                    }
                }
                List(searchItemListVM.searchItemList) { item in
                    NavigationLink(destination: DetailView(searchItem: item)) {
                        SearchResultRow(item)
                    }
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func performSearch(for keyword: String)
    {
        guard let baseURL = URL( string: "https://images-api.nasa.gov" ), let request = URLRequest(for: "search", httpMethod: .GET, query: ["q" : keyword], baseURL: baseURL ) else { return }
        
        let resource = Resource<SearchResult>(request: request)
        
        fetchJSONSubscriber?.cancel() // Cancel the activity.
        fetchJSONSubscriber = URLSession.shared.fetchJSON(for: resource)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The publisher finished normally.")
                case .failure(let error):
                    print("An error occured: \(error).")
                }
            }, receiveValue: { result in
                let itemsWithImage = result.collection.items.filter { $0.thumbnailURL != nil }
                self.searchItemListVM = SearchItemListViewModel(itemsWithImage)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(searchWord: "")
    }
}
