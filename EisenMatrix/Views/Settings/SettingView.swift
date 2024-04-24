//
//  SettingView.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/18/24.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct SettingView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var taskContainer: TaskContainer<TaskIntent, TaskState>
    @EnvironmentObject private var dateContainer: DateContainer<DateIntent, DateState>

    @StateObject private var settingContainer: SettingContainer<SettingState> = {
        let settingModel = SettingState()
        let settingContainer = SettingContainer(model: settingModel, modelChangePublisher: settingModel.objectWillChange)
        return settingContainer
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach($settingContainer.model.settings, id: \.id) { setting in
                    SettingRowView(setting: setting)
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
            Image(systemName: setting.wrappedValue.symbolName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .padding()
                .background(.blue)
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: 4, content: {
                Text(setting.wrappedValue.title)
                    .font(.system(size: 20))
                    .font(.headline)
                    .bold()

                Text(setting.wrappedValue.description)
                    .font(.system(size: 16))
                    .font(.caption)
                    .foregroundStyle(Color(UIColor.systemGray))
            })

            Button(action: {
                setting.isShow.wrappedValue.toggle()
                print("#### QWER:: \(setting.isShow.wrappedValue)")
            }, label: {
                Text(setting.wrappedValue.title)
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color(setting.wrappedValue.color))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            .hSpacing(.trailing)

        })

        .alert(isPresented: setting.isShow, content: {
            Alert(title: Text("Do you really want to \(setting.title.wrappedValue)?"), message: Text(setting.description.wrappedValue), primaryButton: .default(Text("Confirm"), action: {
                if setting.title.wrappedValue == Setting.items[0].title {
                    taskContainer.intent.deleteAllSwiftDatasInContainer(context: context)
                } else if setting.title.wrappedValue == Setting.items[1].title {
                    // JSON -> Task Import
                    settingContainer.model.openFile.toggle()
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
        })

        .fileImporter(isPresented: $settingContainer.model.openFile, allowedContentTypes: [.data]) { result in
            do {
                let fileURL = try result.get()
                settingContainer.model.fileURL = fileURL

                guard let url = settingContainer.model.fileURL else { return }
                guard let json = FileManageService.shared.findAndReadJSON(fileURL: url) else { return }

                taskContainer.intent.decodeJSONToTask(json: json, context: context)

            } catch {
                print("#### \(error.localizedDescription)")
            }
        }
    }
}
