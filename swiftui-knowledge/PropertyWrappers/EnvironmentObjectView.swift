//
//  EnvironmentView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/01.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var score = 0
}

struct EnvironmentObjectView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView {
            VStack {
                //Environmentのスコアに書き込む
                Button(action: {
                    self.settings.score += 1
                }) {
                    Text("Increase Score")
                }

                NavigationLink(destination: DetailView()) {
                    Text("Show Detail View")
                }
            }
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        //Environmentのスコアを表示
        Text("Score: \(settings.score)")
    }
}

struct EnvironmentObjectView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentObjectView().environmentObject(UserSettings())
    }
}
