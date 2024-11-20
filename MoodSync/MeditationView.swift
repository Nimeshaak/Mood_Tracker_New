import SwiftUI

struct DeepBreathingView: View {
    var body: some View {
        ZStack {
            // Background Image
            Image("backgroundImage") // Replace with your image asset name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.3))
                .blur(radius: 10)

            // Content
            VStack {
                Spacer()

                Text("Deep Breathing")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)

                Text("A simple technique to calm your mind. Inhale deeply through your nose and exhale slowly.")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 20)

                NavigationLink(destination: MeditationPlayView()) {
                    Text("Start")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.bottom, 40)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(false) // Ensure the back button shows if you're navigating from here
    }
}

struct DeepBreathingView_Previews: PreviewProvider {
    static var previews: some View {
        DeepBreathingView()
            .previewDevice("iPhone 14 Pro")
    }
}
