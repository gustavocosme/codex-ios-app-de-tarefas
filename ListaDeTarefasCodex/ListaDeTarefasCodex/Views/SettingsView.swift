//
//  SettingsView.swift
//  TaskMaster
//
//  Configurações de aparência e manutenção de dados.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: TaskMasterViewModel
    @State private var showClearConfirmation = false

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (build \(build))"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Aparência") {
                    Toggle(isOn: $viewModel.isDarkModeEnabled) {
                        Label("Modo escuro", systemImage: viewModel.isDarkModeEnabled ? "moon.fill" : "sun.max.fill")
                    }
                    .tint(.accentColor)
                }

                Section("Tarefas") {
                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        Label("Limpar todas as tarefas", systemImage: "trash")
                    }
                    .disabled(!viewModel.hasTasks)

                    if !viewModel.hasTasks {
                        Text("Nenhuma tarefa para limpar.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Sobre") {
                    HStack {
                        Label("TaskMaster", systemImage: "info.circle")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Total de tarefas")
                        Spacer()
                        Text("\(viewModel.tasks.count)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Configurações")
            .confirmationDialog("Deseja remover todas as tarefas?", isPresented: $showClearConfirmation, titleVisibility: .visible) {
                Button("Remover tudo", role: .destructive) {
                    viewModel.clearAllTasks()
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Essa ação não pode ser desfeita. Todas as tarefas salvas em UserDefaults serão perdidas.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(TaskMasterViewModel())
}
