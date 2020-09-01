//
//  BindingView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/01.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

struct BindingView: View {
    @State private var text = "before"
    
    var body: some View {
        VStack {
            CustomText(text: $text)
            
            Button(action: {
                self.text = "after"
            }) {
                Text("change label")
            }
        }
    }
}

struct CustomText: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.heavy)
                .foregroundColor(.purple)
                .shadow(radius: 1.0)
                .onTapGesture {
                    self.text = "changed in child view."
            }
        }
    }
}

struct BindingView_Previews: PreviewProvider {
    static var previews: some View {
        BindingView()
    }
}
