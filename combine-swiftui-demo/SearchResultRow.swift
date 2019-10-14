//
//  SearchResultView.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 12/10/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import SwiftUI
import Combine

struct SearchResultRow: View {
    
    let searchItemViewModel: SearchItemViewModel
    
    @State var imageSubscriber: AnyCancellable?
    @State var image = Image("placeholder")
   
    init(_ searchItemViewModel: SearchItemViewModel)
    {
        self.searchItemViewModel = searchItemViewModel
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
        }
        .onAppear {self.loadImage()}
        .onDisappear {self.imageSubscriber?.cancel()}
    }
    
    private func loadImage() {
        
        guard let url = searchItemViewModel.thumbnailURL else { return }
        
        imageSubscriber = URLSession.shared.fetchImage(for: url)
            .receive(on: DispatchQueue.main)
            .compactMap {$0}
            .map {Image(uiImage: $0)}
            .assign(to: \.image, on: self)
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultRow(SearchItemViewModel())
    }
}
