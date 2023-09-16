import SwiftUI

struct SwipeableCardView<Content: View>: View {
  let backgroundColor: Color
  @Binding var direction: SwipeDirection
  @ViewBuilder let content: Content
  let completion: (SwipeDirection) -> Void

  @State private var dragAmount = CGSize.zero

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(backgroundColor)
        .shadow(radius: 5)
      content
    }
    .padding(32)
    .aspectRatio(1.0, contentMode: .fit)
    .offset(x: dragAmount.width, y: dragAmount.height * 0.3)
    .rotationEffect(.degrees(Double(dragAmount.width / 40)))
    .gesture(
      DragGesture()
        .onChanged {
          dragAmount = $0.translation
          highlight(width: dragAmount.width)
        }
        .onEnded({ _ in
          swipeCard(width: dragAmount.width)
          direction = .none
        })
    )
    .animation(.spring(), value: dragAmount)
  }

  func highlight(width: CGFloat) {
    switch width {
    case -500...(-100):
      direction = .left
      return
    case 100...500:
      direction = .right
      return
    default:
      direction = .none
      return
    }
  }

  func swipeCard(width: CGFloat) {
    switch width {
    case -500...(-150):
      dragAmount = CGSize(width: -500, height: 0)
      completion(SwipeDirection.left)
    case 150...500:
      dragAmount = CGSize(width: 500, height: 0)
      completion(SwipeDirection.right)
    default:
      dragAmount = .zero
    }
  }
}

struct SwipeableCardView_Previews: PreviewProvider {
  static var previews: some View {
    SwipeableCardView(backgroundColor: .yellow, direction: .constant(SwipeDirection.none)) { Text("Content") } completion: {_ in
      print("Card Dismissed")
    }
    .previewDisplayName("Swipeable Card")
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
