//
//  GroupListView.swift
//  Dice it up
//
//  Created by The Real Itto on 16/07/2025.
//

import SwiftUI
import ComposableArchitecture // TCA : permet d'utiliser Store, Reducer, etc.

/// Vue affichant la liste des groupes de joueurs.
struct GroupListView: View {
    
    // Le Store de TCA contenant l'état (`GroupListState`) et la logique (`GroupListReducer`)
    let store: StoreOf<GroupListReducer>
    
    var body: some View {
        // `WithViewStore` permet d’observer et d’interagir avec l’état (State) et les actions (Action)
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) { // Empilement vertical des éléments avec 16 pts de marge entre eux
                
                // Titre principal de la vue
                Text("Sélectionne un groupe")
                    .font(.title)
                
                // Boucle sur tous les groupes disponibles dans le state
                ForEach(viewStore.groups) { group in
                    
                    // Chaque groupe est un bouton cliquable
                    Button(action: {
                        // Lorsque le bouton est cliqué, on envoie l'action `selectGroup` avec l'identifiant du groupe
                        viewStore.send(.selectGroup(group.id))
                    }) {
                        HStack {
                            Text(group.name) // Nom du groupe
                            Spacer() // Pour pousser le contenu à gauche et à droite
                            
                            // Si ce groupe est sélectionné, on affiche une coche à droite
                            if viewStore.selectedGroupId == group.id {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding() // Padding interne au bouton
                        .background(Color.blue.opacity(0.1)) // Fond léger bleu
                        .cornerRadius(10) // Coins arrondis pour un style plus doux
                    }
                }
            }
            .padding()// Padding autour de tout le `VStack`
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .onAppear {
                // Quand la vue apparaît, on déclenche l'action `loadGroups`
                // Cela peut être intercepté par un `Effect` dans le reducer pour charger les données
#if !DEBUG
                viewStore.send(.loadGroups)
#endif
            }
            Spacer()
        }
    }
}

#Preview {
    GroupListView(
        store: Store(
            initialState: .mock,
            reducer: { GroupListReducer.mock }
        )
    )
}
