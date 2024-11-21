import SwiftUI
import AVFoundation

struct MeditationPlayView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the screen
    @State private var timerValue: Int = 60 // Timer duration in seconds
    @State private var timeRemaining: Int = 60
    @State private var isTimerRunning = false
    @State private var showCompletionMessage = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var breathingInstruction: String = "Breathe In" // Default first instruction
    @State private var breathCycle: Int = 0 // Keeps track of the breath cycle
    @State private var isFading = false // Controls fading animation
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Background image
            Image("IMG2") // Replace with your image asset name
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Overlay content
            VStack {
                // Title and description
                VStack(alignment: .center, spacing: 8) {
                    Text("Relax and Breathe")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("A guided breathing exercise to help you relax.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)

                Spacer()

                // Breathing Instructions with fading effect
                VStack {
                    Text(breathingInstruction)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(isFading ? 0 : 1)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isFading)
                        .onAppear {
                            isFading.toggle()
                        }
                }

                Spacer()

                // Countdown timer
                Text(formatTime(timeRemaining))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                            updateBreathingCycle()
                        } else {
                            stopMusic()
                            showCompletionMessage = true
                        }
                    }
            }
            .padding()

            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .alert(isPresented: $showCompletionMessage) {
            Alert(
                title: Text("Meditation Completed"),
                message: Text("You’ve successfully completed your session. Well done!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            startMeditation() // Start meditation as soon as the view appears
        }
    }

    // Format Time
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Start Meditation
    private func startMeditation() {
        isTimerRunning = true
        setupAudioPlayer()
        playMusic()
    }

    // Update Breathing Instructions
    private func updateBreathingCycle() {
        if breathCycle == 0 {
            breathingInstruction = "Breathe In"
        } else if breathCycle == 1 {
            breathingInstruction = "Breathe Out"
        }

        // Cycle breathing instructions
        breathCycle = (breathCycle + 1) % 2
    }

    // Setup Audio Player
    private func setupAudioPlayer() {
        guard let path = Bundle.main.path(forResource: "Thoughtful", ofType: "mp3") else {
            print("Error: Audio file not found")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }

    // Play Music
    private func playMusic() {
        audioPlayer?.play()
    }

    // Stop Music
    private func stopMusic() {
        audioPlayer?.stop()
    }
}

struct MeditationPlayView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationPlayView()
            .previewDevice("iPhone 14 Pro")
    }
}
