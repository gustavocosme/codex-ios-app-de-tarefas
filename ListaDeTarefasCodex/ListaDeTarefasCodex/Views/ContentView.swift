//
//  ContentView.swift
//  TaskMaster
//
//  Abre a aplicação com um TabView contendo as três telas principais.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: TaskMasterViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "checklist")
                }

            NewTaskView()
                .tabItem {
                    Label("Nova", systemImage: "plus.circle.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Config.", systemImage: "gearshape.fill")
                }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskMasterViewModel())
}
