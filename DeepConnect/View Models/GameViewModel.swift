import SwiftUI
import Foundation

/**
 Encapsulates logic for the game.
 */
class GameViewModel: ObservableObject {
  // MARK: - Wrapped Properties

  // MARK: - Properties
  /// All of the questions.
  let questions: [Question] = Question.list

  // MARK: - Methods

}
