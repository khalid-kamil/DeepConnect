import SwiftUI

struct GameView: View {
  @StateObject var game = GameViewModel()
  @State var swipeDirection = SwipeDirection.none

  var body: some View {
    NavigationStack {
      ZStack {
        background
        gameOverCard
        questionCards
      }
      .onAppear {
        game.startGame()
      }
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarTrailing) {
          Text("\(game.questionNumber) of \(game.questionCount)")
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
  var background: some View {
    Color.brown
      .ignoresSafeArea()
  }
}

extension GameView {
  var questionCards: some View {
    ZStack {
      ForEach(game.questions) { question in
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
  }
}

extension GameView {
  var gameOverCard: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.lead)
        .shadow(radius: 5)

      VStack {
        Spacer()
        Text("Finished!".uppercased())
          .font(.largeTitle)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
        Spacer()
        Text("Skipped: \(game.skippedQuestionCount)")
          .font(.title3)
          .fontWeight(.semibold)
          .multilineTextAlignment(.center)
        Text("Completed: \(game.completedQuestionCount)")
          .font(.title3)
          .fontWeight(.semibold)
          .multilineTextAlignment(.center)
        Spacer()
        Spacer()
        Button {
          game.startGame()
        } label: {
          Text("Tap to play again".uppercased())
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.deepRed)
            .multilineTextAlignment(.center)
        }

        // TODO: Add animation to play again
        Spacer()
      }
      .foregroundColor(.white)
      .padding(40)
    }
    .padding(32)
    .aspectRatio(1.0, contentMode: .fit)
  }
}
