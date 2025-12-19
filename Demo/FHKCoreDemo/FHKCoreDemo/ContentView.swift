//
//  ContentView.swift
//  FHKCoreDemo
//
//  Created by Fredy Leon on 15/11/25.
//

import SwiftUI
import FHKCore

public enum AuthRoute: String, NavigationDestination {
    case splash
    case login
    case register
    case forgotPassword
    case detail
    
    public var title: String? {
        switch self {
        case .splash:
            return "Content"
        case .login:
            return "Iniciar Sesión"
        case .register:
            return "Registrarse"
        case .forgotPassword:
            return "Recuperar Contraseña"
        case .detail:
            return "Detail"
        }
    }
    
    public var hidesNavigationBar: Bool {
        switch self {
        case .splash:
            return true
        default:
            return false
        }
    }
    
    public var id: String {
        return self.rawValue
    }
    
    @MainActor @ViewBuilder
    public func view() -> some View {
        switch self {
            
        case .splash:
            SplashView()
            
        case .login:
            LoginView()
            
        case .register:
            RegisterView()
            
        case .forgotPassword:
            ForgotPasswordView()
            
        case .detail:
            DetailView()
        }
    }
}

public struct ContentView: View {
    @NavigationRouterWrapper<AuthRoute> private var router
    
    public init() {}
    
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("ContentView") {
                router.navigate(to: .splash)
            }
            .padding()
        }
        .padding()
    }
}

public struct SplashView: View {
    @NavigationRouterWrapper<AuthRoute> private var router
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "sparkles")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
            
            Text("Bienvenido")
                .font(.largeTitle)
                .bold()
            
            Text("Mi App")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Button("Comenzar") {
                router.navigate(to: .login)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}


public struct LoginView: View {
    @NavigationRouterWrapper<AuthRoute> private var router
    @State private var email = ""
    @State private var password = ""
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("Iniciar Sesión")
                .font(.title)
                .bold()
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("Contraseña", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            Button("Iniciar Sesión") {
                print("Login: \(email)")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(email.isEmpty || password.isEmpty)
            
            Button("¿Olvidaste tu contraseña?") {
                router.navigate(to: .forgotPassword, style: .fullScreenCover)
            }
            .foregroundStyle(.blue)
            
            Spacer()
            
            HStack {
                Text("¿No tienes cuenta?")
                    .foregroundStyle(.secondary)
                
                Button("Regístrate") {
                    router.navigate(to: .register)
                }
                .foregroundStyle(.blue)
            }
        }
        .padding()
        .onAppear {
            router.setNavigationBarItems([
                NavigationBarItem(icon: "gear", placement: .trailing) {
                    print("Settings")
                }
            ])
        }
        .onDisappear {
            router.clearNavigationBarItems()
        }
    }
}


public struct RegisterView: View {
    @NavigationRouterWrapper<AuthRoute> private var router
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Crear Cuenta")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                VStack(spacing: 15) {
                    TextField("Nombre", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Confirmar", text: $confirmPassword)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                Button("Crear Cuenta") {
                    router.navigate(to: .detail)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                //.disabled(!isValid)
                
                Text("Al registrarte aceptas los términos")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && !email.isEmpty &&
        !password.isEmpty && password == confirmPassword
    }
}


public struct ForgotPasswordView: View {
    @NavigationRouterWrapper<AuthRoute> private var router
    @State private var email = ""
    @State private var showAlert = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "lock.rotation")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            
            Text("Recuperar Contraseña")
                .font(.title2)
                .bold()
            
            Text("Ingresa tu email")
                .foregroundStyle(.secondary)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
            
            Button("Enviar") {
                showAlert = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(email.isEmpty)
            
            Spacer()
        }
        .padding()
        .alert("Enviado", isPresented: $showAlert) {
            Button("OK") {
                router.pop()
            }
        } message: {
            Text("Revisa tu email")
        }
    }
}


public struct DetailView: View {
    @NavigationRouterWrapper<AuthRoute> private var router
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "lock.rotation")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            
            Text("Detail")
                .font(.title2)
                .bold()
            
            
            Button("Volver a Login") {
                router.popTo(.login)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
