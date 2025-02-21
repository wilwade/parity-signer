//
//  SeedMenu.swift
//  NativeSigner
//
//  Created by Alexander Slesarev on 10.12.2021.
//

import SwiftUI

struct SeedMenu: View {
    @State private var removeConfirm = false
    let content: MSeedMenu
    let alert: Bool
    let alertShow: () -> Void
    let removeSeed: (String) -> Void
    let navigationRequest: NavigationRequest
    var body: some View {
        MenuStack {
            HeaderBar(line1: Localizable.seedMenu.key, line2: Localizable.selectAction.key).padding(.top, 10)
            MenuButtonsStack {
                BigButton(
                    text: Localizable.backup.key,
                    action: {
                        navigationRequest(.init(action: .backupSeed))
                    }
                )
                BigButton(
                    text: Localizable.deriveNewKey.key,
                    isShaded: true,
                    isCrypto: true,
                    action: {
                        if alert { alertShow() } else {
                            navigationRequest(.init(action: .newKey))
                        }
                    }
                )
                BigButton(
                    text: Localizable.forgetThisSeedForever.key,
                    isShaded: true,
                    isDangerous: true,
                    action: {
                        removeConfirm = true
                    }
                )
            }
        }
        .alert(isPresented: $removeConfirm, content: {
            Alert(
                title: Localizable.forgetThisSeed.text,
                message: Localizable.ThisSeedWillBeRemovedForAllNetworks.ThisIsNotReversible.areYouSure.text,
                primaryButton: .cancel(Localizable.cancel.text),
                secondaryButton: .destructive(
                    Localizable.removeSeed.text,
                    action: { removeSeed(content.seed) }
                )
            )
        })
    }
}

// struct SeedMenu_Previews: PreviewProvider {
// static var previews: some View {
// SeedMenu()
// }
// }
