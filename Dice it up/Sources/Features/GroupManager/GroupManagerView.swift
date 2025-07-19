//
//  GroupManagerView.swift
//  Dice it up
//
//  Created by Haoro on 19/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct GroupManagerView: View {
    let store: StoreOf<GroupManager>

        var body: some View {
            WithViewStore(store, observe: { $0 }) { viewStore in
                NavigationView {
                    Form {
                        Section(header: Text("Group's Name")) {
                            TextField("Nom", text: viewStore.binding(
                                get: \.groupName,
                                send: GroupManager.Action.groupNameChanged
                            ))
                            .autocapitalization(.none)
                        }

                        Section(header: Text("Group's URL")) {
                            TextField("groupe_1", text: viewStore.binding(
                                get: \.urlPart,
                                send: GroupManager.Action.urlPartChanged
                            ))
                            .autocapitalization(.none)
                        }

                        Section {
                            Button("Add") {
                                viewStore.send(.confirmTapped)
                            }
                            .disabled(viewStore.groupName.isEmpty || viewStore.urlPart.isEmpty)

                            Button("Cancel") {
                                viewStore.send(.cancelTapped)
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .navigationTitle("Nouveau groupe")
                }
            }
        }
}
