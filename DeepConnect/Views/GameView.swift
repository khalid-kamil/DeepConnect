import SwiftUI

struct GameView: View {
  @StateObject var game = GameViewModel()

  var body: some View {
    NavigationStack {
      ZStack {
        Color.brown
          .ignoresSafeArea()
        //  cardDeck
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
