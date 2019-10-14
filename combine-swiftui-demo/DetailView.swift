//
//  DetailView.swift
//  combine-swiftui-demo
//
//  Created by Niels Nørskov on 14/10/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let searchItem: SearchItemViewModel
    var body: some View {
        Text("Hello Search Item")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(searchItem: SearchItemViewModel())
    }
}
