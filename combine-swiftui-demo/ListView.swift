//
//  ListView.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 12/10/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import SwiftUI
import Combine

struct ListView: View {
    
    @State var searchWord = ""
    @State var searchItemListVM = SearchItemListViewModel([])
    @State var fetchJSONSubscriber: AnyCancellable?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search term", text: $searchWord)
                    Button(action: {
                        self.performSearch(for: self.searchWord)
                    }) {
                        Text("Search")
                    }
                }.padding(.horizontal, 25)
                List(searchItemListVM.searchItemList) { item in
                    NavigationLink(destination: DetailView(searchItemViewModel: item)) {
                        SearchResultRow(item)
                    }
                }
            }.navigationTitle("Search NASA")
                
        }
    }
    
    // MARK: - Private methods
    
    private func performSearch(for keyword: String)
    {
        guard let baseURL = URL( string: "https://images-api.nasa.gov" ), let request = URLRequest(for: "search", httpMethod: .GET, query: ["q" : keyword], baseURL: baseURL ) else { return }
        
        let resource = Resource<SearchResult>(request: request)
        
        fetchJSONSubscriber?.cancel() // Cancel previous activity.
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
        ListView()
    }
}
