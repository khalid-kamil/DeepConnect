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
      .overlay(nextOverlay)
      .overlay(skipOverlay)
      .onAppear {
        game.startGame()
      }
      .toolbar(content: toolbarContent)
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

extension GameView {
  var skipOverlay: some View {
    HStack {
      ZStack(alignment: .leading) {
        Text("Skip")
          .font(.title)
          .fontWeight(.semibold)
          .foregroundColor(.gray)
          .padding(.leading, 12)
        Rectangle()
          .fill(RadialGradient(gradient: Gradient(colors: [.gray, .clear]), center: UnitPoint(x: -1, y: 0.5), startRadius: 1, endRadius: 360))
          .opacity(0.8)
          .frame(width: 200, height: 800)
      }

      Spacer()
    }
    .opacity(swipeDirection == .left ? 1 : 0)
    .frame(width: UIScreen.main.bounds.width)
  }

  var nextOverlay: some View {
    HStack {
      Spacer()
      ZStack(alignment: .trailing) {
        Text("Next")
          .font(.title)
          .fontWeight(.semibold)
          .foregroundColor(.green)
          .padding(.trailing, 12)
        Rectangle()
          .fill(RadialGradient(gradient: Gradient(colors: [.green, .clear]), center: UnitPoint(x: 2, y: 0.5), startRadius: 1, endRadius: 360))
          .opacity(0.8)
          .frame(width: 200, height: 800)
      }
    }
    .opacity(swipeDirection == .right ? 1 : 0)
    .frame(width: UIScreen.main.bounds.width)
  }
}

extension GameView {
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
      ToolbarItem(placement: .navigationBarTrailing) {
        Text("\(game.questionNumber) of \(game.questionCount)")
          .opacity(game.state == .ended ? 0 : 1)
          .animation(
            .spring(), value: game.state == .ended)
      }
  }
}
