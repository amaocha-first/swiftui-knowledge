//
//  ObservedObjectView.swift
//  swiftui-knowledge
//
//  Created by shota-nishizawa on 2020/09/01.
//  Copyright © 2020 cybozu. All rights reserved.
//

import SwiftUI

struct ObservedObjectView: View {
    @ObservedObject private var loginParam = ObservedLoginParam()
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("username", text: self.$loginParam.username)
            TextField("password", text: self.$loginParam.password)
        }
    }
}

final class ObservedLoginParam: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
}

struct ObservedObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObservedObjectView()
    }
}
