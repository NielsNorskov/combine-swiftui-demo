//
//  DetailView.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 14/10/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import SwiftUI
import Combine

struct DetailView: View {
    
    let searchItemViewModel: SearchItemViewModel
    
    @State var imageSubscriber: AnyCancellable?
    @State var thumbnail = UIImage(systemName: "photo")!
    
    var body: some View {
        VStack {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFit()
            Text(searchItemViewModel.title)
            Text(searchItemViewModel.description)
            Spacer()
        }.onAppear() {
            self.loadImage()
        }
    }
    
    private func loadImage() {
        
        guard let url = searchItemViewModel.thumbnailURL else { return }
        
        imageSubscriber = URLSession.shared.fetchImage(for: url)
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.thumbnail, on: self)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(searchItemViewModel: SearchItemViewModel())
    }
}
