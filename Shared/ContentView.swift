//
//  ContentView.swift
//  Shared
//
//  Created by martinhartl on 15.02.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var entryStore: EntryViewStore
    @EnvironmentObject var appStore: AppViewStore

    let listType: ListType

    var body: some View {
        HSplitView {
            EntriesListView(
                listType: listType
            )
            if appStore.isShowingListDetail {
                EntriesListDetailsView(listType: listType)
                    .frame(maxHeight: .infinity)
            }
        }
        .fileImporter(
            isPresented: appStore.binding(get: \.isOpeningFile, send: { .isShowingFileOpener($0) }),
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                entryStore.send(.load(fileURL: selectedFile))
            } catch {
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    appStore.send(.showAddView)
                } label: {
                    Label("Add", systemImage: "plus.circle.fill")
                }
            }
            ToolbarItem {
                Button {
                    appStore.send(.showFileOpener)
                } label: {
                    Label("Open", systemImage: "folder.badge.plus")
                }
            }
            ToolbarItem {
                Button {
                    appStore.send(.setShowListDetail(!appStore.isShowingListDetail))
                } label: {
                    Label("Show Edit Link", systemImage: "sidebar.right")
                }
            }
        }
        .sheet(
            isPresented: appStore.binding(get: \.isShowingAddView, send: { .setIsShowingAddView($0) })
        ) {
            AddEntryView()
                .environmentObject(
                    entryStore.scope(
                        state: { state in
                            return AddEntryState(availableCategories: state.categories)
                        }, action: { action in
                            return .addEntryAction(action)
                        }, scopedReducer: addEntryReducer
                    )
                )
        }
        .equatable(by: appStore.isShowingAddView)
    }
}

// TODO: Add preview mock data
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(listType: .all)
    }
}
