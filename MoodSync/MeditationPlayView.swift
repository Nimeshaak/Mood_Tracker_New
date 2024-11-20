import SwiftUI
import AVFoundation

struct MeditationPlayView: View {
    @State private var timerValue: Int = 60 // Timer duration in seconds
    @State private var timeRemaining: Int = 60
    @State private var isTimerRunning = false
    @State private var showCompletionMessage = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            Spacer()

            // Title
            Text("Relax and Breathe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            // Timer Display
            Text("\(timeFormatted(timeRemaining))")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.blue)
                .padding(.bottom, 40)

            // Play Button
            if !isTimerRunning {
                Button(action: {
                    startMeditation()
                }) {
                    Text("Start Meditation")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            setupAudioPlayer()
        }
        .alert(isPresented: $showCompletionMessage) {
            Alert(
                title: Text("Meditation Completed"),
                message: Text("You’ve successfully completed your session. Well done!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // Format Time
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Start Meditation
    private func startMeditation() {
        isTimerRunning = true
        playMusic()
        startTimer()
    }

    // Start Timer
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                isTimerRunning = false
                stopMusic()
                showCompletionMessage = true
            }
        }
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
