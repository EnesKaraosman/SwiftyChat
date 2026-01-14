//
//  ChatListView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        NavigationView {
            List {
                // Featured Section
                Section {
                    NavigationLink {
                        InteractiveChatView()
                    } label: {
                        DemoRow(
                            icon: "bubble.left.and.bubble.right.fill",
                            iconColor: .blue,
                            title: "Interactive Demo",
                            subtitle: "Experience a guided conversation"
                        )
                    }
                } header: {
                    Text("Featured")
                }
                
                // Explore Section
                Section {
                    NavigationLink {
                        ThemeShowcaseView()
                    } label: {
                        DemoRow(
                            icon: "paintpalette.fill",
                            iconColor: .purple,
                            title: "Theme Showcase",
                            subtitle: "Explore different visual themes"
                        )
                    }
                    
                    NavigationLink {
                        MessageTypesGalleryView()
                    } label: {
                        DemoRow(
                            icon: "square.grid.2x2.fill",
                            iconColor: .orange,
                            title: "Message Types",
                            subtitle: "All supported message formats"
                        )
                    }
                } header: {
                    Text("Explore Features")
                }
                
                // Examples Section
                Section {
                    NavigationLink {
                        BasicExampleView()
                    } label: {
                        DemoRow(
                            icon: "text.bubble",
                            iconColor: .green,
                            title: "Basic Example",
                            subtitle: "Simple text chat implementation"
                        )
                    }
                    
                    NavigationLink {
                        AdvancedExampleView()
                    } label: {
                        DemoRow(
                            icon: "star.fill",
                            iconColor: .yellow,
                            title: "Advanced Example",
                            subtitle: "All message types and features"
                        )
                    }
                } header: {
                    Text("Code Examples")
                }
                
                // About Section
                Section {
                    Link(destination: URL(string: "https://github.com/EnesKaraosman/SwiftyChat")!) {
                        DemoRow(
                            icon: "link",
                            iconColor: .gray,
                            title: "GitHub Repository",
                            subtitle: "View source code and documentation"
                        )
                    }
                } header: {
                    Text("Resources")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SwiftyChat")
        }
    }
}

// MARK: - Demo Row
struct DemoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(iconColor)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
