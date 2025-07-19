//
//  GroupListView.swift
//  Dice it up
//
//  Created by The Real Itto on 16/07/2025.
//

import SwiftUI
import ComposableArchitecture

/// Displays all the DM's groups.
/// Groups can be added, managed and deleted.
/// View displaying the list of player groups.
struct GroupListView: View {
    
    let store: StoreOf<GroupList>
    
    var body: some View {
        // `WithViewStore` allows observing and interacting with the State and Actions
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) { // Vertical stack with 16 pts spacing
                
                // Main title of the view
                Text("Select a group")
                    .font(.title)
                
                // Loop through all groups in the state
                ForEach(viewStore.groups) { group in
                    
                    // Each group is clickable
                    Button(action: {
                        // Send the `selectGroup` action with the group's ID
                        viewStore.send(.selectGroup(group.id))
                    }) {
                        HStack {
                            Text(group.name)
                            Spacer() // Pushes content to left and right
                            
                            // Display a checkmark if this group is selected
                            if viewStore.selectedGroupId == group.id {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding() // Inner padding for the button
                        .background(Color.blue.opacity(0.1)) // Light blue background
                        .cornerRadius(10) // Rounded corners for softer UI
                    }
                }
                
                // Button to display the GroupManager sheet
                Button("Add a group") {
                    // Triggers a simple action to open the sheet
                    viewStore.send(.openGroupCreation)
                }
                .padding()
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
