import SwiftUI
import Foundation

/**
  Encapsulates logic for the game.
*/
class GameViewModel: ObservableObject {
  // MARK: - Wrapped Properties
  @Published private(set) var state = GameState.notStarted
  @Published private(set) var questionNumber = 0
  // MARK: - Properties
  /// All of the questions.
  private(set) var questions: [Question] = Question.list.shuffled()

  // MARK: - Methods

}

enum GameState {
  case notStarted
  case instructions
  case started
  case ended
}
