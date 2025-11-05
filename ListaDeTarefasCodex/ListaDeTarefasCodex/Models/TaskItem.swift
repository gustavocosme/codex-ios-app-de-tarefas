//
//  TaskItem.swift
//  TaskMaster
//
//  Criado para representar uma tarefa dentro do aplicativo.
//

import Foundation

/// Categoria disponível para classificar as tarefas do usuário.
enum TaskCategory: String, CaseIterable, Codable, Identifiable {
    case personal = "Pessoal"
    case work = "Trabalho"
    case study = "Estudo"

    var id: String { rawValue }

    /// Ícone do SF Symbols associado a cada categoria para uso na interface.
    var systemImageName: String {
        switch self {
        case .personal:
            return "person.fill"
        case .work:
            return "briefcase.fill"
        case .study:
            return "book.fill"
        }
    }
}

/// Representa uma tarefa completa no aplicativo TaskMaster.
struct TaskItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var category: TaskCategory
    let createdAt: Date
    var dueDate: Date
    var notes: String

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        category: TaskCategory,
        createdAt: Date = Date(),
        dueDate: Date,
        notes: String
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.category = category
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.notes = notes
    }
}
