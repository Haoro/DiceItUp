import ComposableArchitecture
import Foundation

struct GroupDetail: Reducer {
    struct State: Equatable {
        let group: Group
        var diceLogs: [DiceLogItem] = []
        var isLoading: Bool = false
    }

    enum Action: Equatable {
        //case onAppear
        case loadDiceLogs
        case diceLogsResponse(TaskResult<[DiceLogItem]>)
    }

    @Dependency(\.diceLogClient) var diceLogClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .loadDiceLogs:
            state.isLoading = true
            return .run { [group = state.group] send in
                await send(.diceLogsResponse(
                    TaskResult {
                        try await diceLogClient.fetchLogs(group.urlPart)
                    }
                ))
            }

        case let .diceLogsResponse(.success(logs)):
            state.isLoading = false
            state.diceLogs = logs
            return .none

        case let .diceLogsResponse(.failure(error)):
            state.isLoading = false
            // Tu peux ajouter un champ `errorMessage` dans le state si tu veux l’afficher
            print("Error fetching dice logs: \(error)")
            return .none
        }
    }
}
