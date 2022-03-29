//
//  AudioStreamManager.swift
//  soundclassify
//
//  Created by Simone Giordano on 28/03/22.
//

import Foundation
import AVFoundation
import SoundAnalysis
class AudioStreamManager {
    
    private var engine: AVAudioEngine?
    private var inputBus: AVAudioNodeBus?
    private var micInputFormat: AVAudioFormat?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var classifyRequest: SNClassifySoundRequest?
    private var resultObserver = AudioStreamObserver()
    init() {
        engine = AVAudioEngine()
        
        //Getting the built-in microphone audio bus and saving its format
        inputBus = AVAudioNodeBus(0)
        guard let inputBus = inputBus else {
            fatalError()
        }
        
        micInputFormat = engine?.inputNode.inputFormat(forBus: inputBus)
        
        guard let micInputFormat = micInputFormat else {
            fatalError("Could not retrieve microphone input format")
        }
        startEngine()
        //Initialiting sound stream analyzer with the microphone audio format
        streamAnalyzer = SNAudioStreamAnalyzer(format: micInputFormat)
        //Setup the custom sound classifier
        classifierSetup()
        
       
        
    }
    public func resultObservation(with observer: SNResultsObserving) {
        //Adding the observer
        guard let classifyRequest = classifyRequest else {
            fatalError("Could not setup the classification request")
        }
        guard let streamAnalyzer = streamAnalyzer else {
            fatalError("Could not initializer stream analyzer")
        }
        
        do {
            try streamAnalyzer.add(classifyRequest, withObserver: observer)
        }
        catch {
            fatalError("Could not initializer observer for the sound classification results: \(error.localizedDescription)")
        }
        
    }
    private func classifierSetup() {
        let defaultConfig = MLModelConfiguration()
        let soundClassifier = try? EnvSoundClassifier(configuration: defaultConfig)
        
        guard let soundClassifier = soundClassifier else{
            fatalError("Could not instantiate sound classifier")
        }
        classifyRequest = try? SNClassifySoundRequest(mlModel: soundClassifier.model)
    }
    private func startEngine() {
        
        guard let engine = engine else {
            fatalError("Could not instantiate audio engine")
        }
        do {
            try engine.start()
        }
        catch {
            fatalError("Unable to start audio engine: \(error.localizedDescription)")
        }
        
    }
    public func installTap() {
        
        guard let engine = engine else {
            fatalError("Failed to retrieve audio engine")
        }
        guard let inputBus = inputBus else {
            fatalError("Failed to retrieve input bus")
        }
        guard let micInputFormat = micInputFormat else {
            fatalError("Failed to retrieve input format")
        }
        
        engine.inputNode.installTap(onBus: inputBus, bufferSize: 4000, format: micInputFormat, block: analyzeAudio(buffer:at:))
    }
    public func removeTap() {
        guard let engine = engine else {
            fatalError("Failed to retrieve audio engine")
        }
        guard let inputBus = inputBus else {
            fatalError("Failed to retrieve input bus")
        }
        engine.inputNode.removeTap(onBus: inputBus)
    }
    public func getStreamPublisher() -> Optional<SNAudioStreamAnalyzer>.Publisher {
        return self.streamAnalyzer.publisher
    }
    public func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            self.streamAnalyzer!.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
            
    }
}
