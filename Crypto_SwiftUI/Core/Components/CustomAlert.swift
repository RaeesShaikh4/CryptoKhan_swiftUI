
import SwiftUI

struct CustomAlert: View {
    enum AlertType {
        case success, failure
    }

    var type: AlertType
    var message: String
    var action: (() -> Void)?

    @State private var isPresented = true

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    VStack(spacing: 16) {
                        Image(systemName: type == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor( type == .success ? .green : .red )

                        Text(message)
                            .font(.title3)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)


                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.theme.accent.opacity(0.25),
                                    radius: 6,x: 0,y: 0)
                    )
                }
                .frame(width: min(geometry.size.width - 40, 270), height: 270)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 350) // for vertical position
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        dismissAlert()
                    }
                }

                Spacer()
            }
            .opacity(isPresented ? 1 : 0)
        }
    }

    private func dismissAlert() {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action?()
        }
    }
}

