//
//  EisenMatrixWidget.swift
//  EisenMatrixWidget
//
//  Created by 준우의 MacBook 16 on 4/25/24.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct EisenMatrixWidgetEntryView: View {
    var entry: Provider.Entry

    static var taskDescriptor: FetchDescriptor<Task> {
        let calendar = Calendar.current

        let startOfDate = calendar.startOfDay(for: Date.now)

        let predicate = #Predicate<Task> {
            return $0.isCompleted != true && $0.creationDate >= startOfDate
        }

        let sort = [SortDescriptor(\Task.creationDate, order: .forward)]

        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 2
        return descriptor
    }

    /// Query that will fetch only three active todo at a time
    @Query(taskDescriptor, animation: .snappy) private var activeTaskList: [Task]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today Task")
                .bold()

            ForEach(self.activeTaskList) { task in
                HStack(spacing: 5) {
                    Button(intent: ToggleButton(id: task.taskTitle)) {
                        Image(systemName: "circle.fill")
                    }

                    .tint(Matrix.allCases.filter { $0.info == task.taskType }.first?.color)
                    .buttonBorderShape(.circle)

                    Text(task.taskTitle)
                        .font(.callout)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    Text(task.creationDate.format("MM-dd a hh:mm"))
                        .font(.caption)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if self.activeTaskList.isEmpty {
                Text("No Tasks 😂")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
}

struct EisenMatrixWidget: Widget {
    let kind: String = "EisenMatrixWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EisenMatrixWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                /// Setting up SwiftData Container
                .modelContainer(for: Task.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is an Eisen Matrix.")
    }
}

#Preview(as: .systemSmall) {
    EisenMatrixWidget()
} timeline: {
    SimpleEntry(date: .now)
}

// MARK: - Button Intent Which Will Update the todo status

struct ToggleButton: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Task State")

    @Parameter(title: "Task ID")
    var id: String

    init() {}

    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        /// Updating Task Status
        let context = try ModelContext(.init(for: Task.self))
        /// Retreiving Respective Task
        let descriptor = FetchDescriptor(predicate: #Predicate<Task> { $0.taskTitle == id })

        do {
            if let task = try context.fetch(descriptor).first {
                task.isCompleted = true
                /// Saving Context
                try context.save()
            }
        } catch {
            print("#### ㅅㅂ 에러남: \(error.localizedDescription)")
        }

        return .result()
    }
}
