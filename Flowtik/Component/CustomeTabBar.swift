import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: MainTabbar.Tab

    var body: some View {
        HStack {
            ForEach(MainTabbar.Tab.allCases, id: \.self) { tab in
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = tab
                    }
                }) {
                    VStack {
                        Image(systemName: icon(for: tab))
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == tab ? .white : .gray)
                            .padding(10)
                            .background(selectedTab == tab ? Color.green : Color.clear)
                            .clipShape(Circle())
                            .shadow(color: selectedTab == tab ? .black.opacity(0.2) : .clear, radius: 5, x: 0, y: 5)

                        Text(tab.rawValue)
                            .font(.caption)
                            .foregroundColor(selectedTab == tab ? .green : .gray)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        )
        //.padding(.horizontal)
        //.padding(.bottom, 20)
    }

    private func icon(for tab: MainTabbar.Tab) -> String {
        switch tab {
        case .tasks: return "list.bullet.rectangle"
//        case .attendance: return "calendar.badge.clock"
        case .profile: return "person.crop.circle"
        }
    }
}
