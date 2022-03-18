//
//  AddEntryStore.swift
//  DETimeLog
//
//  Created by martinhartl on 17.03.22.
//

import Foundation
import ViewStore

struct AddEntryState {
    var availableCategories: [Category]
    var selectedCategory: Category?
}

enum AddEntryAction {
    case selectCategory(Category?)
}

let addEntryReducer: ReduceFunction<AddEntryState, AddEntryAction, EntryEnvironment> = { state, action, env in
    switch action {
    case let .selectCategory(category):
        state.selectedCategory = category
    }

    return .none
}

typealias AddEntryStore = ViewStore<AddEntryState, AddEntryAction, EntryEnvironment>


extension AddEntryStore {
#if DEBUG
    static let mock = AddEntryStore(
        state: AddEntryState(
            availableCategories: [
                Category(title: "Productivity")
            ]
        ),
        environment: .init(
            fileParser: FileParser(),
            colorStore: ColorStore(userDefaults: .standard)
        ),
        reduceFunction: addEntryReducer
    )
#endif
}
