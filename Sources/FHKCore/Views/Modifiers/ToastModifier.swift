//
//  ToastModifier.swift
//  FHKCore
//
//  Created by Fredy Leon on 2/3/26.
//

import SwiftUI
import FHKDesignSystem
import FHKDomain

public extension View {
    func setToastStyle(isVisible: Binding<Bool>, info: FHKToastInfo) -> some View {
        modifier(ToastModifier(isVisible: isVisible, info: info))
    }
}

@MainActor
public protocol ToastAppareanceProtocol {
    var borderColor: Color { get }
    var fontText: Font { get }
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var shadow: CGFloat { get }
}

public extension ToastAppareanceProtocol {
    var borderColor: Color {
        return FHKColor.gray
    }
    
    @MainActor
    var fontText: Font {
        return .PangramSans.medium(FHKSize.size20)
    }
    
    var cornerRadius: CGFloat {
        return CGFloat(FHKSize.size20)
    }
    
    var borderWidth: CGFloat {
        return CGFloat(1)
    }
    
    var shadow: CGFloat {
        return CGFloat(FHKSize.size04)
    }
}


fileprivate struct ToastModifier: ViewModifier, ToastAppareanceProtocol {
    @Binding var isVisible: Bool
    let info: FHKToastInfo
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
 
            if isVisible {
                content
                .font(fontText)
                .foregroundColor(getTextColor())
                .padding(.horizontal, FHKSize.size16)
                .background(getBackgroundColor())
                .cornerRadius(cornerRadius)
                .shadow(radius: shadow)
                .padding(.top, safeAreaPadding())
                .transition(.move(edge: .top))
                .offset(y: isVisible ? paddingOffset() : -UIScreen.main.bounds.height)
                .animation(.easeInOut(duration: 2), value: isVisible)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isVisible = false
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    
    private func getBackgroundColor() -> Color {
        switch info.type {
        case .success:
            return FHKColor.success
        case .error:
            return FHKColor.error
        case .warning:
            return FHKColor.warning
        case .notification:
            return FHKColor.basicBlack
        }
    }
    
    private func getTextColor() -> Color {
        switch info.type {
        case .success, .error, .notification:
            return FHKColor.basicWhite
        case .warning:
            return FHKColor.basicBlack
        }
    }
    
    private func paddingOffset() -> CGFloat {
        let valuePadding: CGFloat = -100
        print(valuePadding)
        return valuePadding
    }
    
    private func safeAreaPadding() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        let topPadding = keyWindow?.safeAreaInsets.top ?? 0
        let finalTopPadding = topPadding >= 20 ? topPadding : 0
        return finalTopPadding
    }
}
