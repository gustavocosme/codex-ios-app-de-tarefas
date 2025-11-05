//
//  TaskMasterApp.swift
//  TaskMaster
//
//  Ponto de entrada da aplicação com o ViewModel compartilhado.
//

import SwiftUI
import Combine

@main
struct TaskMasterApp: App {
    @StateObject private var viewModel = TaskMasterViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(viewModel.isDarkModeEnabled ? .dark : .light)
        }
    }
}
