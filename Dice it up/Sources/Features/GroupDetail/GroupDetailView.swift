//
//  GroupDetailView.swift
//  Dice it up
//
//  Created by Haoro on 19/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct GroupDetailView: View {
    let store: StoreOf<GroupDetail>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text(viewStore.group.name)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                if viewStore.isLoading {
                    ProgressView("Loading players…")
                        .padding()
                } else {
                    List {
                        ForEach(viewStore.players) { player in
                            Button(action: {
                                // Send the `selectGroup` action with the group's ID
                                // viewStore.send(.selectGroup(group.id))
                            }) {
                                HStack {
                                    Text(player.name)
                                    Spacer() // Pushes content to left and right
                                    
                                }
                                .padding() // Inner padding for the button
                                .background(Color.blue.opacity(0.1)) // Light blue background
                                .cornerRadius(10) // Rounded corners for softer UI
                            }
                        }
                    }
                    .navigationTitle("Players")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewStore.send(.loadDiceLogs)
                            } label: {
                                Label("Refresh", systemImage: "arrow.clockwise")
                            }
                        }
                    }
                    .refreshable {
                        viewStore.send(.loadDiceLogs)
                    }
                }
            }
            .onAppear {
                viewStore.send(.loadDiceLogs)
            }
            
        }
    }
}
#Preview {
    GroupDetailView(
        store: Store(
            initialState: GroupDetail.State(
                group:Group(id: UUID(), name: "Group Test", urlPart: "group_test")
            ),
            reducer: {
                GroupDetail()
            }
        )
    )
}
