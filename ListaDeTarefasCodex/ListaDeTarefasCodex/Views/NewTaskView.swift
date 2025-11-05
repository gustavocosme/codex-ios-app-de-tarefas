//
//  NewTaskView.swift
//  TaskMaster
//
//  Formulário completo para criação de novas tarefas.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject private var viewModel: TaskMasterViewModel
    @State private var title: String = ""
    @State private var selectedCategory: TaskCategory = .personal
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var notes: String = ""
    @State private var showSuccessAlert = false

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detalhes")) {
                    TextField("Título", text: $title)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.done)

                    Picker("Categoria", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.systemImageName)
                                .tag(category)
                        }
                    }
                }

                Section(header: Text("Datas")) {
                    DatePicker("Data limite", selection: $dueDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }

                Section(header: Text("Anotações")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                        .overlay(
                            Group {
                                if notes.isEmpty {
                                    Text("Digite anotações adicionais...")
                                        .foregroundStyle(.tertiary)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                }
                            }, alignment: .topLeading
                        )
                }

                Section {
                    Button {
                        addTask()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Adicionar Tarefa", systemImage: "plus")
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Nova Tarefa")
            .alert("Tarefa criada!", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Sua tarefa foi salva e estará disponível na aba Home.")
            }
        }
    }

    private func addTask() {
        guard isFormValid else { return }
        viewModel.addTask(title: title, category: selectedCategory, dueDate: dueDate, notes: notes)
        showSuccessAlert = true
        resetForm()
    }

    private func resetForm() {
        title = ""
        selectedCategory = .personal
        dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        notes = ""
    }
}

#Preview {
    NewTaskView()
        .environmentObject(TaskMasterViewModel())
}
