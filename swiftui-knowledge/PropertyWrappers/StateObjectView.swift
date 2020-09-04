//
//  StateObjectView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/04.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

final class Counter: ObservableObject {
    @Published var count: Int = 0
}

//親View
struct StateObjectView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("ContentView")
            Text("\(count)")
            ChildView() //ChildViewは下のself.count += 1を行うと初期化されてしまうので、ChildViewの中のcounterは0に戻ってしまう。
            Button("increment") {
                self.count += 1
            }
        }
        .padding()
        .background(Color.red)
    }
}

//子View
struct ChildView: View {
    @ObservedObject var counter = Counter()
    //iOS14.0以降ではStateObjectが使えるので、そちらを使う。
    
    var body: some View {
        VStack {
            Text("CounterView")
            Text("\(counter.count)")
            Button("increment") {
                self.counter.count += 1
            }
        }
        .padding()
        .background(Color.yellow)
    }
}

struct StateObjectView_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectView()
    }
}
