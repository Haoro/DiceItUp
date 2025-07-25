
import ComposableArchitecture
import Foundation


struct GroupDetail: Reducer {
    
    struct State: Equatable {
        /// The current Group from which the details are displayed.
        let group: Group
        /// All the player's of the selected group.
        var players: [Player] = []
        /// All the dice logs of the selected group.
        var diceLogs: [DiceLogItem] = []
        /// Indicate if the data are actually getting fetched.
        var isLoading: Bool = false
        
        /// ID of the currently selected player.
        var selectedPlayerId: UUID?
        /// Optional state for the player detail page.
        @PresentationState var destination: PlayerDetail.State? = nil
    }

    enum Action: Equatable {
        case loadDiceLogs
        case loadMockPlayers
        case diceLogsResponse(TaskResult<[DiceLogItem]>)
        case diceLogsParsed([Player])
        case selectPlayer(UUID)
        /// Navigate through the application.
        case destination(PresentationAction<PlayerDetail.Action>)
    }

    @Dependency(\.diceLogClient) var diceLogClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
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
                
            case .loadMockPlayers:
                state.players = [
                    Player(name: "Haoro", rolls: []),
                    Player(name: "Leykal", rolls: []),
                    Player(name: "Sanson", rolls: [])
                ]
                return .none
                
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
                
                
                // When a playert is selected, navigate to the player's details.
            case let .selectPlayer(id):
                state.selectedPlayerId = id
                // Init destination when a player is selected.
                if let player = state.players.first(where: { $0.id == id }) {
                    state.destination = PlayerDetail.State(player: player)
                }
                return .none
                
            case .destination:
                return .none
            }
        }
        // Handling navigation.
        .ifLet(\.$destination, action: /Action.destination) {
            PlayerDetail()
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
