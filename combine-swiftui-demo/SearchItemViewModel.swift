//
//  SearchItemViewModel.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 30/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import Foundation
import Combine

class SearchItemListViewModel: ObservableObject
{
    let searchItemList: [SearchItemViewModel]
    
    init(_ items: [SearchItem])
    {
        searchItemList = items.map{ SearchItemViewModel($0) }
    }
}

extension SearchItemListViewModel
{
    func item(at index: Int) -> SearchItemViewModel
    {
        return searchItemList[index]
    }
}

struct SearchItemViewModel: Identifiable
{
    let id: String // Unique id required by SwiftUI List.
    let searchItem: SearchItem
}

extension SearchItemViewModel
{
    init(_ item: SearchItem)
    {
        id = UUID().uuidString
        searchItem = item
    }
    
    var title: String {
        return searchItem.title ?? ""
    }
    
//    var title: AnyPublisher<String?, Never> {
//        return Just(searchItem.title).eraseToAnyPublisher()
//    }
//
//    var description: AnyPublisher<String?, Never> {
//        return Just(searchItem.description).eraseToAnyPublisher()
//    }
//
//    var thumbnailURL: AnyPublisher<URL?, Never> {
//        return Just(searchItem.thumbnailURL).eraseToAnyPublisher()
//    }
}
