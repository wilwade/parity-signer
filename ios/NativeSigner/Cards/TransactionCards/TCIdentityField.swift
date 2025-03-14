//
//  TCIdentityField.swift
//  NativeSigner
//
//  Created by Alexander Slesarev on 7.1.2022.
//

import SwiftUI

struct TCIdentityField: View {
    let content: String
    var body: some View {
        TCNameValueTemplate(name: Localizable.TCName.identityField.string, value: content)
    }
}

// struct TCIdentityField_Previews: PreviewProvider {
//    static var previews: some View {
//        TCIdentityField()
//    }
// }
