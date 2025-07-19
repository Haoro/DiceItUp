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
                Button("Charger les jets de dés") {
                    viewStore.send(.loadDiceLogs)
                }
            }
//            .onAppear {
//                viewStore.send(.onAppear)
//            }
            List(viewStore.diceLogs, id: \.time) { log in
                VStack(alignment: .leading) {
                    Text("\(log.from) → \(log.input)")
                    Text("Résultat : \(log.result)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
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
