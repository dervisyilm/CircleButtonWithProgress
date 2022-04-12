//
//  ContentView.swift
//  CircleButtonWithProgress
//
//  Created by Dervis YILMAZ on 12.04.2022.
//

import SwiftUI


struct ProgressTrack: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 75, height: 75)
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 10)
        )
    }
}

struct ProgressBar: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 75, height: 75)
            .overlay(
                Circle().trim(from:0, to: progress())
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round,
                            lineJoin:.round
                        )
                )
                    .foregroundColor(
                        (completed() ? Color.green : Color.red)
                ).animation(
                    .easeInOut(duration: 0.2)
                )
        )
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
        
    }
}


struct ContentView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var recording = false
    var action: ((_ recording: Bool) -> Void)?
    
    @State var counter: Int = 0
    var countTo: Int = 60
    
//    @State var progressValue: Double
    
    var body: some View {
        
        
        ZStack{
            ProgressTrack()
            ProgressBar(counter: counter, countTo: countTo)
            
            Circle()
                .stroke(lineWidth: 6)
                .foregroundColor(.red)
                .frame(width: 65, height: 65)

            RoundedRectangle(cornerRadius: recording ? 8 : self.innerCircleWidth / 2)
                .foregroundColor(.red)
                .frame(width: self.innerCircleWidth, height: self.innerCircleWidth)

        }
        .onReceive(timer) { time in
            if(recording){
                
                startTimer()
                
                if (self.counter < self.countTo) {
                    self.counter += 1
                }
                
            }else{
                
                self.stopTimer()
            }
            
        }
        .padding(15)
        .onTapGesture {
            withAnimation {
                self.recording.toggle()
                self.action?(self.recording)
                
                if(recording){
                    
                    startTimer()
                    
                    if (self.counter < self.countTo) {
                        self.counter += 1
                    }
                    
                }else{
                    
                    self.stopTimer()
                }
            }
        }
        .background(Color.clear)
        
    }
    
    var innerCircleWidth: CGFloat {
        self.recording ? 32 : 55
    }
    
    
    func stopTimer() {
        print("stop timer")
        timer.upstream.connect().cancel()
        
    }
        
    func startTimer() {
        print("start timer")
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

