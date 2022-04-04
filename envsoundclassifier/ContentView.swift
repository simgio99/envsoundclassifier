//
//  ContentView.swift
//  soundclassify
//
//  Created by Simone Giordano on 28/03/22.
//

import SwiftUI
struct ContentView: View {
    
    @ObservedObject var observer: AudioStreamObserver
    @State var text: String = ""
    private var streamManager: AudioStreamManager
    
    init() {
        observer = AudioStreamObserver()
        streamManager = AudioStreamManager()
        streamManager.resultObservation(with: observer)
    }
    var body: some View {
        VStack {
            Spacer()
            Text(observer.currentSound)
                    .padding()
                ChartView(observer: observer)
        
            Spacer()
            ListenButton(streamManager: streamManager)
               
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
