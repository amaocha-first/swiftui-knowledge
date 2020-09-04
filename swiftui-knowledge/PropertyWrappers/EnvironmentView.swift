//
//  EnvironmentView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/01.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

final class UserEnvironment: ObservableObject {
    @Published var username = "Test"
    @Published var id = "12345"
}

struct EnvironmentView: View {
    @EnvironmentObject var userEnv: UserEnvironment
    @State var showOtherView = false
    
    var body: some View {
        VStack {
            Text(userEnv.username)
                .onTapGesture {
                    self.userEnv.username = "aaaaaaaa"    //objectの中身を変更
                    self.showOtherView.toggle()
                    
            }.sheet(isPresented: $showOtherView) {
                OtherView().environmentObject(self.userEnv)
            }
        }
    }
}

struct OtherView: View {
    @EnvironmentObject var userEnv: UserEnvironment

    var body: some View {
        Text(userEnv.username).onTapGesture {
            self.userEnv.username = "bbbbbbb"
        }
    }
}

struct EnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentView().environmentObject(UserEnvironment())
    }
}
