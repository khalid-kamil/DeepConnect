import SwiftUI
import Foundation

/**
 Encapsulates logic for the game.
 */
class GameViewModel: ObservableObject {
  // MARK: - Wrapped Properties
  @Published private(set) var state = GameState.notStarted
  @Published private(set) var questionNumber = 1
  // MARK: - Properties
  /// All of the questions.
  private(set) var questions: [Question] = Question.list.shuffled()
  private(set) var skippedQuestionCount = 0
  private(set) var completedQuestionCount = 0

  // MARK: - Methods
  func startGame() {
    state = .started
  }

  func nextCard(with direction: SwipeDirection) {
    switch direction {
    case .left:
      skippedQuestionCount += 1
    case .right:
      completedQuestionCount += 1
    case .none:
      return
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      if self?.questionNumber == self?.questions.count {
        self?.state = .ended
      } else {
        self?.questionNumber += 1
      }
    }
  }
}
