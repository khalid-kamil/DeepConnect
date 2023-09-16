import Foundation

/**
 An object representing a question.

 Primarily displayed in ``CardView``.
 */
struct Question: Identifiable {
  // MARK: - Properties
  let id = UUID()
  let prompt: String
}
