//
//  SearchResultView.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 12/10/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import SwiftUI
import Combine

struct SearchResultView: View {
    
    let searchItemViewModel: SearchItemViewModel
    
    @State var url: URL?
    @State var image = Image("placeholder")
    @State var imageSubscriber: AnyCancellable?
    
    init(_ searchItemViewModel: SearchItemViewModel)
    {
        self.searchItemViewModel = searchItemViewModel
    }
    
    func loadImage()
    {
        guard let url = searchItemViewModel.thumbnailURL else { return }
        
        imageSubscriber = URLSession.shared.fetchImage(for: url, placeholder: #imageLiteral(resourceName: "placeholder"))
            .receive(on: DispatchQueue.main)
            .sink { dlimage in
                self.image = Image(uiImage: dlimage ?? UIImage(named: "placeholder")!)
            }
    }
    
    var body: some View {
        HStack {
            self.image
                .resizable()
                .frame(width: 60, height: 45, alignment: .leading)
            VStack {
                Text(searchItemViewModel.title)
                    .lineLimit(1)
                Text(searchItemViewModel.description)
                    .lineLimit(2)
            }
        }.onAppear(perform: loadImage)
            .onDisappear { self.imageSubscriber?.cancel() }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(SearchItemViewModel())
    }
}
