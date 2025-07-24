import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var navigateToDashboard = false
    @State private var showAlert = false
    @State private var loginFailed = false
    @State private var showCustomAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertSuccess = false


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
                        TextField("Email", text: $viewModel.email)
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


                    Button(action: {
                        Task {
                            await viewModel.login()

                            if viewModel.isLoggedIn {
                                alertTitle = "Success"
                                alertMessage = "You have successfully logged in!"
                                alertSuccess = true
                                showCustomAlert = true

                                // Wait 2 seconds before redirecting to DashboardView
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    showCustomAlert = false
                                    // NO manual navigation needed — @AppStorage takes care of view switch
                                }

                            } else {
                                alertTitle = "Login Failed"
                                alertMessage = viewModel.errorMassege
                                alertSuccess = false
                                showCustomAlert = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    showCustomAlert = false
                                }
                            }
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
        .overlay(
            Group {
                if showCustomAlert {
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: alertSuccess ? "checkmark.circle.fill" : "xmark.octagon.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(alertSuccess ? .green : .red)
                            
                            Text(alertTitle)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(alertMessage)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                        }
                        .padding()
                        .frame(maxWidth: 300)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .padding(.bottom, 100)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: showCustomAlert)
                    }
                }
            }
        )

    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
