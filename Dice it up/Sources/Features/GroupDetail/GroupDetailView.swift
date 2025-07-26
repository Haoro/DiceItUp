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
                                viewStore.send(.selectPlayer(player.id))
                            }) {
                                HStack {
                                    Text(player.name)
                                        .font(.system(size: 25, weight: .bold))
                                        .lineLimit(1)
                                    Spacer() // Pushes content to left and right
                                }
                                .padding() // Inner padding for the button
                                .padding(.horizontal)
                                .padding(.vertical, 4) // Espacement entre les cellules
                                .cornerRadius(10) // Rounded corners for softer UI
                            }
                        }
                        .listRowSeparator(.hidden)
                        .background(Color(.systemGray6)) // Fond clair distinct
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    }
                    .navigationTitle("Players")
                    .scrollContentBackground(.hidden)
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
                //viewStore.send(.loadMockPlayers)
            }
        }
        .navigationDestination(
          store: store.scope(
            state: \.$destination,
            action: GroupDetail.Action.destination
          )
        ) { playerDetailStore in
          PlayerDetailView(store: playerDetailStore)
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
