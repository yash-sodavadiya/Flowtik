//
//  ProfileView.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//


import SwiftUI

struct ProfileView: View {
    
    @StateObject var profileViewModel = ProfileViewModel()
    @AppStorage("isLoggedIn") var isLogin: Bool = true 
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // MARK: - Profile Header
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.green).frame(width: 110, height: 110))
                            .shadow(radius: 6)
                        
                        Text(profileViewModel.profile?.userName ?? "demo")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("iOS Developer")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    // MARK: - Stats Cards
                    HStack(spacing: 20) {
                        ProfileStatCard(
                            title: "Attendance",
                            value: "95%",
                            icon: "calendar.badge.clock",
                            color: .blue
                        )
                        
                        ProfileStatCard(
                            title: "Tasks Done",
                            value: "124",
                            icon: "checkmark.seal.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Options List
                    VStack(spacing: 16) {
                                            // Logout Button
                                            Button {
                                                // ✅ Logout Action
                                                isLogin = false
                                                UserDefaults.standard.removeObject(forKey: "userId")
                                                UserDefaults.standard.removeObject(forKey: "authToken")
                                            } label: {
                                                ProfileOptionRow(
                                                    icon: "arrow.uturn.left.circle",
                                                    title: "Logout",
                                                    iconColor: .red
                                                )
                                            }
                                        }
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                                        .padding(.horizontal)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .task {
                    await profileViewModel.loadUser()
                }
        }
    }
        
}

// MARK: - Stat Card View
struct ProfileStatCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(color))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(.white))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Option Row View
struct ProfileOptionRow: View {
    var icon: String
    var title: String
    var iconColor: Color = .blue
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
                .background(Circle().fill(iconColor.opacity(0.1)))
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ProfileView()
}


