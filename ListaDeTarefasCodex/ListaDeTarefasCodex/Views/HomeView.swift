//
//  HomeView.swift
//  TaskMaster
//
//  Lista de tarefas com filtros, exclusão e marcação de concluído.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: TaskMasterViewModel
    @State private var selectedFilter: TaskCategoryFilter = .all

    private var filteredTasks: [TaskItem] {
        viewModel.tasks(for: selectedFilter)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Categoria", selection: $selectedFilter) {
                    ForEach(TaskCategoryFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top)
                .padding(.horizontal)

                if filteredTasks.isEmpty {
                    emptyState
                } else {
                    taskList
                }
            }
            .navigationTitle("Minhas Tarefas")
            .toolbar { toolbarContent }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Nenhuma tarefa por aqui")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Use a aba \"Nova\" para adicionar uma tarefa e organizá-la por categoria.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var taskList: some View {
        List {
            ForEach(filteredTasks) { task in
                Button {
                    viewModel.toggleCompletion(for: task)
                } label: {
                    taskRow(for: task)
                }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteTask(task)
                    } label: {
                        Label("Excluir", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .animation(.easeInOut, value: filteredTasks)
    }

    private func taskRow(for task: TaskItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isCompleted ? .green : .primary)
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                    Spacer()
                    Text(task.dueDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(dueDateColor(for: task))
                }

                HStack(spacing: 8) {
                    Label(task.category.rawValue, systemImage: task.category.systemImageName)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Criada em \(task.createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                if !task.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(task.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .opacity(task.isCompleted ? 0.6 : 1)
    }

    private func dueDateColor(for task: TaskItem) -> Color {
        if task.isCompleted { return .secondary }
        return task.dueDate < Date() ? .red : .blue
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.hasTasks {
                Text("\(viewModel.tasks.count) tarefas")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(TaskMasterViewModel())
}
