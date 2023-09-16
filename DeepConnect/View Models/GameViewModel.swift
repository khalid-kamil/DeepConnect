import SwiftUI
import Foundation

/**
  Encapsulates logic for the game.
*/
class GameViewModel: ObservableObject {
  // MARK: - Wrapped Properties
  @Published private(set) var state = State.notStarted
  @Published private(set) var questionNumber = 0
  // MARK: - Properties
  /// All of the questions.
  let questions: [Question] = Question.list

  // MARK: - Methods

}

enum State {
  case notStarted
  case instructions
  case started
  case ended
}
