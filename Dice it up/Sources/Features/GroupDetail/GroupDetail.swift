import ComposableArchitecture
import Foundation

struct GroupDetail: Reducer {
    
    struct State: Equatable {
        let group: Group
        var players: [Player] = []
        var diceLogs: [DiceLogItem] = []
        var isLoading: Bool = false
    }

    enum Action: Equatable {
        //case onAppear
        case loadDiceLogs
        case diceLogsResponse(TaskResult<[DiceLogItem]>)
        case diceLogsParsed([Player])
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

        case let .diceLogsResponse(.success(diceLogs)):
            state.isLoading = false
            state.diceLogs = diceLogs

            // Transform raw logs into a list of Player.
            let players = Self.mapLogsToPlayers(diceLogs)
            return .send(.diceLogsParsed(players))

        case let .diceLogsResponse(.failure(error)):
            state.isLoading = false
            // TODO: Handle errors.
            print("Error fetching dice logs: \(error)")
            return .none
            
        case let .diceLogsParsed(players):
            state.players = players
            return .none
        }
    }
    
    ///
    static func mapLogsToPlayers(_ diceLogs: [DiceLogItem]) -> [Player] {
        /// Handles creating correctly all the Player only once.
        var playerDict: [String: Player] = [:]

        // For each log, add rolls to corresponding
        for diceLog in diceLogs {
            // Unwrap all the variables.
            guard let name = diceLog.from,
                  let input = diceLog.input,
                  let result = diceLog.result,
                  let time = diceLog.time else { continue }
            let tags = diceLog.tags?.map(\.k) ?? []
            
            // Create a new DiceRoll.
            let diceRoll = DiceRoll(
                input: input,
                result: result,
                comment: diceLog.comment,
                tags: tags,
                timestamp: time
            )

            // Check if a Player already rolled before and already exist.
            if var existingPlayer = playerDict[name] {
                // If roll's Player exist, simply append the roll.
                existingPlayer.rolls.append(diceRoll)
                // Replace current Player in dict with same Player with the new roll.
                playerDict[name] = existingPlayer
            } else {
                // If roll's Player doesn't exist, create a new Player with the roll.
                playerDict[name] = Player(name: name, rolls: [diceRoll])
            }
        }

        // Return an Array of all the Players.
        return Array(playerDict.values)
    }
}
