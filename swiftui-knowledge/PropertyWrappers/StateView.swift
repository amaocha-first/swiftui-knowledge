//
//  ContentView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/01.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

struct StateView: View {
    @State private var text = "before"
    var body: some View {
        VStack {
            Text(text)
            
            Button(action: {
                self.text = "after"
            }) {
                Text("change label")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
