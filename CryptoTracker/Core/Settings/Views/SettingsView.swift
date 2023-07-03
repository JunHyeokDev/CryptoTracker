//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/2/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Thank you for this amazing free contents! I've learned a lot!!!")
                }
                .sectionHeader(headerText: "Swiftfull Thinking", footerText: "Footer here")
                
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
        }
    }
}


struct SectionHeaderView: ViewModifier {
    let headerText: String
    let footerText: String
    func body(content: Content) -> some View {
        
        Section {
            content
        } header: {
            Text(headerText)
                .textCase(.none)
        } footer: {
            Text(footerText)
        }
    }
}





struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

