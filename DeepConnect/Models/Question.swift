import Foundation

/**
  An object representing a question.

  Primarily displayed in ``GameView``.
*/
struct Question: Identifiable {
  // MARK: - Properties
  let id = UUID()
  let prompt: String
}

extension Question {
  static let list: [Question] = [
    Question(prompt: "What's a dream or aspiration you've held onto since childhood? How has it evolved over the years?"),
    Question(prompt: "Describe a time when you faced a significant challenge. How did you overcome it, and what did you learn from the experience?"),
    Question(prompt: "If you could travel anywhere in the world right now, where would you go and why?"),
    Question(prompt: "What's a book, movie, or song that has deeply impacted your life, and what lessons did you draw from it?"),
    Question(prompt: "If you could have dinner with any historical figure, who would it be, and what would you ask them?"),
    Question(prompt: "Share a personal achievement or moment of pride that you haven't talked about much."),
    Question(prompt: "What's a skill or hobby you've always wanted to pursue but haven't yet? What's holding you back?"),
    Question(prompt: "Describe a time when you felt truly connected to nature. What emotions and sensations did you experience?"),
    Question(prompt: "Think about a mistake or regret from your past. What did you learn from it, and how has it influenced your decisions since then?"),
    Question(prompt: "If you could change one thing about the world, what would it be, and how would you contribute to that change?")
  ]
}
