import SwiftUI
import Foundation

/**
 Encapsulates logic for the game.
 */
class GameViewModel: ObservableObject {
  // MARK: - Wrapped Properties
  @Published private(set) var state = GameState.startMenu
  @Published private(set) var questionNumber = 1
  @Published var swipeDirection = SwipeDirection.none
  
  // MARK: - Properties
  /// All of the questions.
  private(set) var questions: [Question] = Question.list.shuffled()
  let questionCount = Question.list.count
  private(set) var skippedQuestionCount = 0
  private(set) var completedQuestionCount = 0
  let instructions = "Be vulnerable. Don't judge."

  // MARK: - Methods
  func startGame() {
    state = .startMenu
    questions = Question.list.shuffled()
    skippedQuestionCount = 0
    completedQuestionCount = 0
    questionNumber = 1
  }

  func dismissInstructionsCard() {
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
      self?.questions.removeFirst()
      self?.questionNumber += 1
    }

    if questionNumber == questionCount {
      state = .ended
    }
  }
}
