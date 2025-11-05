//
//  TaskMasterViewModel.swift
//  TaskMaster
//
//  Responsável por toda a lógica de negócios, filtros e persistência em UserDefaults.
//

import Foundation
import SwiftUI
import Combine

/// Filtros disponíveis para a lista principal de tarefas.
enum TaskCategoryFilter: String, CaseIterable, Identifiable {
    case all = "Todas"
    case personal = "Pessoal"
    case work = "Trabalho"
    case study = "Estudo"

    var id: String { rawValue }

    /// Categoria equivalente ao filtro. `nil` representa todas as categorias.
    var category: TaskCategory? {
        switch self {
        case .all:
            return nil
        case .personal:
            return .personal
        case .work:
            return .work
        case .study:
            return .study
        }
    }
}

/// ViewModel compartilhado entre todas as telas através do Environment Object.
final class TaskMasterViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var tasks: [TaskItem] = []
    @Published var isDarkModeEnabled: Bool {
        didSet { saveThemePreference() }
    }

    // MARK: - Private Properties

    private let tasksKey = "taskmaster_tasks_storage_key"
    private let themeKey = "taskmaster_theme_preference_key"
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.isDarkModeEnabled = userDefaults.object(forKey: themeKey) as? Bool ?? false
        loadTasks()
    }

    // MARK: - Public API

    /// Lista de tarefas de acordo com o filtro escolhido pelo usuário.
    func tasks(for filter: TaskCategoryFilter) -> [TaskItem] {
        guard let category = filter.category else {
            return tasks.sorted(by: sortPredicate)
        }
        return tasks
            .filter { $0.category == category }
            .sorted(by: sortPredicate)
    }

    /// Adiciona uma nova tarefa e persiste o resultado.
    func addTask(title: String, category: TaskCategory, dueDate: Date, notes: String) {
        let normalizedDueDate = max(dueDate, Date())
        let newTask = TaskItem(title: title.trimmingCharacters(in: .whitespacesAndNewlines), category: category, dueDate: normalizedDueDate, notes: notes)
        withAnimation {
            tasks.append(newTask)
        }
        persistTasks()
    }

    /// Marca ou desmarca a conclusão da tarefa informada.
    func toggleCompletion(for task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        withAnimation {
            tasks[index].isCompleted.toggle()
        }
        persistTasks()
    }

    /// Remove uma tarefa específica do armazenamento.
    func deleteTask(_ task: TaskItem) {
        guard let index = tasks.firstIndex(of: task) else { return }
        withAnimation {
            tasks.remove(at: index)
        }
        persistTasks()
    }

    /// Remove todas as tarefas e atualiza a persistência.
    func clearAllTasks() {
        withAnimation {
            tasks.removeAll()
        }
        persistTasks()
    }

    /// Verifica se existe pelo menos uma tarefa salva.
    var hasTasks: Bool {
        !tasks.isEmpty
    }

    // MARK: - Private Helpers

    private func loadTasks() {
        guard let data = userDefaults.data(forKey: tasksKey) else { return }
        do {
            tasks = try decoder.decode([TaskItem].self, from: data)
        } catch {
            print("Falha ao decodificar tarefas: \(error.localizedDescription)")
            tasks = []
        }
    }

    private func persistTasks() {
        do {
            let data = try encoder.encode(tasks)
            userDefaults.set(data, forKey: tasksKey)
        } catch {
            print("Falha ao codificar tarefas: \(error.localizedDescription)")
        }
    }

    private func saveThemePreference() {
        userDefaults.set(isDarkModeEnabled, forKey: themeKey)
    }

    private func sortPredicate(_ lhs: TaskItem, _ rhs: TaskItem) -> Bool {
        if lhs.isCompleted != rhs.isCompleted {
            return !lhs.isCompleted
        }
        return lhs.dueDate < rhs.dueDate
    }
}
