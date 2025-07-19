//
//  GroupList.swift
//  Dice it up
//
//  Created by The Real Itto on 19/07/2025.
//

import ComposableArchitecture
import Foundation
import CasePaths

/// Group logic (reduces actions into a new state).
struct GroupList: Reducer {
    
    /// Describes the state of the group selection screen.
    struct State: Equatable {
        /// List of existing groups.
        var groups: [Group] = []
        
        /// ID of the currently selected group.
        var selectedGroupId: UUID?
        
        /// Optional state for the group manager (shown in a modal sheet).
        @PresentationState var groupManager: GroupManager.State? = nil
    }

    /// Available actions in the GroupList screen.
    enum Action: Equatable {
        /// Selection of an existing group.
        case selectGroup(UUID)
        
        /// Open the group creation manager.
        case openGroupCreation
        
        /// Internal actions related to the group manager (modal).
        case groupManager(PresentationAction<GroupManager.Action>)
    }

    var body: some ReducerOf<Self> {
        // Reduces actions into a new state.
        Reduce { state, action in
            switch action {
                
            // When a group is selected, update the selected ID.
            case let .selectGroup(id):
                state.selectedGroupId = id
                return .none
                
            // When "Add a group" is tapped, initialize the modal state.
            case .openGroupCreation:
                state.groupManager = GroupManager.State()
                return .none
                
            // When the "Add" button in the modal is confirmed, add the new Group to the list.
            case .groupManager(.presented(.confirmTapped)):
                let newGroup = Group(
                    id: UUID(),
                    name: state.groupManager?.groupName ?? "",
                    urlPart: state.groupManager?.urlPart ?? ""
                )
                state.groups.append(newGroup)
                // Closes the sheet.
                state.groupManager = nil
                return .none
                
            // When the sheet is dismissed (manually closed or "Cancel" button).
            case .groupManager(.presented(.cancelTapped)), .groupManager(.dismiss):
                state.groupManager = nil
                return .none
                
            // Other internal modal actions: no state change here.
            case .groupManager:
                return .none
            }
        }
        // Allows delegating the actions and state of the `GroupManager` modal.
        .ifLet(\.$groupManager, action: /Action.groupManager) {
            GroupManager()
        }
    }
}
