import SwiftUI

struct GameView: View {
  @StateObject var game = GameViewModel()
  @State var swipeDirection = SwipeDirection.none

  var body: some View {
    NavigationStack {
      ZStack {
        Color.brown
          .ignoresSafeArea()
        cardDeck
        if game.state == .ended {
          VStack {
            Text("Game Over")
            Text("Skipped Questions: \(game.skippedQuestionCount)")
            Text("Completed Questions: \(game.completedQuestionCount)")
          }
        }
      }
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarTrailing) {
          Text("\(game.questionNumber) of \(game.questions.count)")
            .opacity(game.state == .ended ? 0 : 1)
            .animation(
              .spring(), value: game.state == .ended)
        }
      })
      .navigationTitle("Deep Connect")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
  }
}

extension GameView {
  var cardDeck: some View {
    ZStack {
      ForEach(game.questions.reversed()) { question in
        SwipeableCardView(backgroundColor: .white, direction: $swipeDirection) {
          Text(question.prompt.uppercased())
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
            .padding(40)
            .blur(radius: swipeDirection != .none ? 4 : 0)
        } completion: { swipeDirection in
          game.nextCard(with: swipeDirection)
        }
      }
    }
    .frame(width: UIScreen.main.bounds.width)
    .onAppear {
      game.startGame()
    }
  }
}
