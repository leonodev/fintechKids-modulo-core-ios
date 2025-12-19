//
//  ModalWrapper.swift
//  FHKCore
//
//  Created by Fredy Leon on 19/12/25.
//

import SwiftUI

// Sub-vista para las modales (Limpia el body del Container)
struct ModalWrapper<Destination: NavigationDestination>: View {
    let destination: Destination
    let router: NavigationRouter<Destination>
    
    var body: some View {
        NavigationStack {
            destination.view()
                .navigationTitle(destination.title ?? "")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { router.dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.primary)
                        }
                    }
                }
        }
    }
}
