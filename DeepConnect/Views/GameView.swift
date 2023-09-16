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
      }
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarTrailing) {
          Text("\(game.questionNumber) of \(game.questions.count)")
            .opacity(game.state == .started ? 1 : 0)
            .animation(
              .interpolatingSpring(stiffness: 100, damping: 10), value: game.state == .started)
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
        } completion: { direction in
          print(direction)
        }
      }
    }
    .frame(width: UIScreen.main.bounds.width)
    .onAppear {
      game.startGame()
    }
  }
}
