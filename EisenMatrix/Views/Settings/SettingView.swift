//
//  SettingView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftData
import SwiftUI

struct SettingView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateState>

    @State private var settings: [Setting] = Setting.items
    @State private var fileURL: URL?
    @State private var openFile = false

    var body: some View {
        NavigationView {
            List {
                ForEach($settings, id: \.id) { $setting in
                    SettingRowView(setting: $setting)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Setting")
        }

        .onAppear(perform: {
            taskContainer.intent.fetchAllTask(context: context)
        })
    }

    @ViewBuilder
    func SettingRowView(setting: Binding<Setting>) -> some View {
        HStack(alignment: .center, spacing: 12, content: {
            Image(systemName: setting.symbolName.wrappedValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .padding()
                .background(.blue)
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: 4, content: {
                Text(setting.title.wrappedValue)
                    .font(.system(size: 20))
                    .font(.headline)
                    .bold()

                Text(setting.description.wrappedValue)
                    .font(.system(size: 16))
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.systemGray))
            })

            Button(action: {
                setting.isShow.wrappedValue.toggle()
            }, label: {
                Text(setting.title.wrappedValue)
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color(setting.color.wrappedValue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            .hSpacing(.trailing)

        })
        .alert(isPresented: setting.isShow) {
            Alert(title: Text("Do you really want to \(setting.title.wrappedValue)?"), message: Text(setting.description.wrappedValue), primaryButton: .default(Text("Confirm"), action: {
                if setting.title.wrappedValue == settings[0].title {
                    taskContainer.intent.deleteAllSwiftDatasInContainer(context: context)
                } else if setting.title.wrappedValue == settings[1].title {
                    // JSON -> Task Import
                    openFile.toggle()
                    guard let url = fileURL else { return }
                    guard let json = FileManageService.shared.findAndReadJSON(fileURL: url) else { return }
                    taskContainer.intent.decodeJSONToTask(json: json, context: context)
                } else {
                    // Task -> JSON Export
                    taskContainer.intent.encodeTaskToJSON(tasks: taskContainer.model.allTasks)
                }
            }), secondaryButton:
            .destructive(
                Text("Cancel")
                    .bold()
                    .foregroundStyle(Color(UIColor.systemRed))
            ))
        }

        .fileImporter(isPresented: $openFile, allowedContentTypes: [.data]) { result in
            do {
                let fileURL = try result.get()
                self.fileURL = fileURL
                print("#### \(fileURL)")

            } catch {
                print("#### \(error.localizedDescription)")
            }
        }
    }
}
