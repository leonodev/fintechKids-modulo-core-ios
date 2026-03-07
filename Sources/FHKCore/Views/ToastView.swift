//
//  ToastView.swift
//  FHKCore
//
//  Created by Fredy Leon on 2/3/26.
//

import Foundation
import SwiftUI
import FHKDesignSystem
import FHKDomain

public struct ToastView: View {
    @Binding public var isVisible: Bool
    public var info: FHKToastInfo
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    public init(isVisible: Binding<Bool>,info: FHKToastInfo) {
        self._isVisible = isVisible
        self.info = info
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            if info.hasIcon {
                Image(systemName: iconSystemName)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: FHKSize.size24, height: FHKSize.size24)
                    .foregroundColor(.white)
            }
            
            Text(info.message)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, FHKSize.size04)
        .padding(.vertical, FHKSize.size16)
        .frame(maxWidth: .infinity)
        .setToastStyle(isVisible: $isVisible, info: info)
    }
    
    private var iconSystemName: String {
        switch info.type {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.circle.fill"
        case .notification:
            return "wifi.exclamationmark.circle.fill"
        }
    }
}

#Preview {
    VStack {
        ToastView(isVisible: .constant(true),
                  info: FHKToastInfo(type: .success,
                                     message: "Prueba de notificacion si incluso a doble linea o mas ...",
                                     hasIcon: true))
    }
    .frame(width: .infinity)
}
