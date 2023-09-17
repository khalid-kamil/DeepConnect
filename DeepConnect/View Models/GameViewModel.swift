import SwiftUI
import Foundation

/**
 Encapsulates logic for the game.
 */
class GameViewModel: ObservableObject {
  // MARK: - Wrapped Properties
  @Published private(set) var state = GameState.notStarted
  @Published private(set) var questionNumber = 1
  @Published var swipeDirection = SwipeDirection.none
  
  // MARK: - Properties
  /// All of the questions.
  private(set) var questions: [Question] = []
  let questionCount = Question.list.count
  private(set) var skippedQuestionCount = 0
  private(set) var completedQuestionCount = 0

  // MARK: - Methods
  func startGame() {
    state = .started
    questions = Question.list.shuffled()
    skippedQuestionCount = 0
    completedQuestionCount = 0
    questionNumber = 1
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
      self?.questions.removeFirst()
      self?.questionNumber += 1
    }

    if questionNumber == questionCount {
      state = .ended
    }
  }
}
