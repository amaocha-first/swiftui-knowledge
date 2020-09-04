//
//  EnvironmentView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/01.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

final class Object: ObservableObject {
    @Published var username = "Test"
    @Published var id = "12345"
}

struct EnvironmentView: View {
    @EnvironmentObject var object: Object
    @State var showOtherView = false
    
    var body: some View {
        VStack {
            Text(object.username)
                .onTapGesture {
                    self.object.username = "aaaaaaaa"    //objectの中身を変更
                    self.showOtherView.toggle()
                    
            }.sheet(isPresented: $showOtherView) {
                OtherView().environmentObject(self.object)
            }
        }
    }
}

struct OtherView: View {
    @EnvironmentObject var object: Object

    var body: some View {
        Text(object.username).onTapGesture {
            self.object.username = "bbbbbbb"
        }
    }
}

struct EnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentView().environmentObject(Object())
    }
}
