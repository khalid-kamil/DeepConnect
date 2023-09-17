import SwiftUI

struct GameView: View {
  @StateObject var game = GameViewModel()
  @State private var offset = 0.0

  var body: some View {
    NavigationStack {
      ZStack {
        background
        gameOverCard
        questionCards
        if game.state == .startMenu {
          instructionsCard
          welcomeCard
        }
      }
      .overlay(nextOverlay)
      .overlay(skipOverlay)
      .toolbar(content: toolbarContent)
      .navigationTitle("Deep Connect")
      .navigationBarTitleDisplayMode(.inline)
      .preferredColorScheme(.light)
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
    Image("polkadots")
      .resizable()
      .scaledToFill()
      .ignoresSafeArea()
      .blur(radius: 8)
  }
}

extension GameView {
  var questionCards: some View {
    ZStack {
      ForEach(game.questions.reversed()) { question in
        SwipeableCardView(backgroundColor: .white, direction: $game.swipeDirection) {
          Text(question.prompt.uppercased())
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
            .padding(40)
            .blur(radius: game.swipeDirection != .none ? 4 : 0)
        } completion: { swipeDirection in
          game.nextCard(with: swipeDirection)
        }
      }
    }
    .frame(width: UIScreen.main.bounds.width)
    .offset(x: 8, y: 8)
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
        Spacer()
      }
      .foregroundColor(.white)
      .padding(40)
    }
    .padding(32)
    .shadow(radius: 6)
    .aspectRatio(1.0, contentMode: .fit)
    .frame(width: UIScreen.main.bounds.width)
    .offset(x: 12, y: 12)
  }
}

extension GameView {
  var instructionsCard: some View {
    SwipeableCardView(backgroundColor: Color("Lead"), direction: $game.swipeDirection) {
      VStack {
        Spacer()
        Text("How to play".uppercased())
          .font(.title3)
          .fontWeight(.heavy)
          .padding(.bottom, 24)
        Text(game.instructions.uppercased())
        Spacer()
        HStack {
          Group {
            Image(systemName: "arrow.left")
            Text("Skip")
          }
          .foregroundColor(.gray)
          Spacer()
          Image(systemName: "hand.point.up.left")
            .font(.title)
            .fontWeight(.semibold)
          Spacer()
          Group {
            Text("Next")
            Image(systemName: "arrow.right")
          }
          .foregroundColor(.green)
        }
      }
      .font(.headline)
      .multilineTextAlignment(.center)
      .foregroundColor(.white)
      .padding(40)
    } completion: { _ in
      game.dismissInstructionsCard()
    }
    .frame(width: UIScreen.main.bounds.width)
    .offset(x: 4, y: 4)
    .shadow(radius: 6)
  }
}

extension GameView {
  var welcomeCard: some View {
    SwipeableCardView(backgroundColor: .lead, direction: .constant(.none)) {
      VStack {
        Spacer()
        Image("DCLogo-white")
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 100)

        Text("Conversation Card Game".uppercased())
          .font(.footnote)
          .fontWeight(.regular)
          .multilineTextAlignment(.center)
        Spacer()
        HStack {
          Image(systemName: "hand.point.up.left")
          Image(systemName: "arrow.right")
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.deepRed)
        Text("Swipe to open up".uppercased())
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(.deepRed)
          .multilineTextAlignment(.center)
        Spacer()
      }
      .foregroundColor(.white)
      .padding(40)
    } completion: { _ in }
      .frame(width: UIScreen.main.bounds.width)
      .shadow(radius: 6)
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
    .opacity(game.swipeDirection == .left ? 1 : 0)
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
    .opacity(game.swipeDirection == .right ? 1 : 0)
    .frame(width: UIScreen.main.bounds.width)
  }
}

extension GameView {
  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Label("Restart", systemImage: "gobackward")
        .fontWeight(.semibold)
        .labelStyle(.iconOnly)
        .foregroundColor(.deepRed)
        .opacity(game.state == .started ? 1 : 0)
        .animation(.spring(), value: game.state == .started)
        .onTapGesture {
          game.startGame()
        }
    }

    ToolbarItem(placement: .navigationBarTrailing) {
      Text("\(game.questionNumber) of \(game.questionCount)")
        .font(.headline)
        .foregroundColor(.deepRed)
        .opacity(game.state == .started ? 1 : 0)
        .animation(
          .spring(), value: game.state == .started)
    }
  }
}
