import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var navigateToDashboard = false
    @State private var showAlert = false
    @State private var loginFailed = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    Text("Welcome to Flowtik")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    VStack(spacing: 20) {
                        TextField("Email", text: $viewModel.username)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 2)

                        ZStack(alignment: .trailing) {
                            Group {
                                if viewModel.isSecure {
                                    SecureField("Password", text: $viewModel.password)
                                } else {
                                    TextField("Password", text: $viewModel.password)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 2)

                            Button(action: {
                                viewModel.isSecure.toggle()
                            }) {
                                Image(systemName: viewModel.isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                    .padding(.horizontal, 30)

                    HStack {
                        Spacer()
                        Button(action: {
                            // Forgot password action
                        }) {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.trailing, 30)
                    }

                    // NavigationLink is triggered by state
                    NavigationLink(destination: DashboardView(), isActive: $navigateToDashboard) {
                        EmptyView()
                    }

                    Button(action: {
                        if viewModel.login() {
                            navigateToDashboard = true
                        } else {
                            loginFailed = true
                            showAlert = true
                        }
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 30)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Login Failed"),
                            message: Text("Invalid username or password."),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    Spacer()
                }
                .padding(.top, 40)
            }
        }
    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
