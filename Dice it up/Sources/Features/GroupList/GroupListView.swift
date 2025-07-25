//
//  GroupListView.swift
//  Dice it up
//
//  Created by Haoro on 16/07/2025.
//

import SwiftUI
import ComposableArchitecture

/// Displays all the DM's groups.
/// Groups can be added, managed and deleted.
/// View displaying the list of player groups.
struct GroupListView: View {
    
    let store: StoreOf<GroupList>
    
    var body: some View {
        NavigationStack {
            // `WithViewStore` allows observing and interacting with the State and Actions
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack(spacing: 16) { // Vertical stack with 16 pts spacing
                    
                    // Main title of the view
                    Text("Select a group")
                        .font(.title)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    // Action to show sheet for adding a group
                                    viewStore.send(.openGroupCreation)
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    
                    List {
                        // Loop through all groups in the state
                        ForEach(viewStore.groups) { group in
                            
                            // Each group is clickable
                            Button(action: {
                                // Send the `selectGroup` action with the group's ID
                                viewStore.send(.selectGroup(group.id))
                            }) {
                                HStack {
                                        VStack(alignment: .leading) {
                                            Text(group.name)
                                                .font(.system(size: 25, weight: .bold))
                                                .lineLimit(1)
                                            Text(group.urlPart)
                                                .font(.system(size: 20))
                                                .lineLimit(1)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .padding(.horizontal)
                                    .padding(.vertical, 4) // Espacement entre les cellules
                            }
                        }
                        .onDelete { indexSet in
                            viewStore.send(.deleteGroup(indexSet))
                        }
                        .listRowSeparator(.hidden)
                        .background(Color(.systemGray6)) // Fond clair distinct
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    }
                    .scrollContentBackground(.hidden)
                    
                
                }
                Spacer()
            }
            // GroupManager sheet presentation
            .sheet(
                store: store.scope(
                    state: \.$groupManager,
                    action: GroupList.Action.groupManager
                )
            ) { groupManagerStore in
                GroupManagerView(store: groupManagerStore)
            }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination,
                    action: GroupList.Action.destination
                )
            ) { groupDetailStore in
                GroupDetailView(store: groupDetailStore)
            }
        }
    }
}

#Preview {
    GroupListView(
        store: Store(
            initialState: GroupList.State(
                groups: [
                    Group(id: UUID(), name: "Group 1", urlPart: "group1"),
                    Group(id: UUID(), name: "Group 2", urlPart: "group2")
                ],
                selectedGroupId: nil
            ),
            reducer: {
                GroupList()
            }
        )
    )
}
