//
//  RTSoundClassifier.swift
//  soundclassify
//
//  Created by Simone Giordano on 28/03/22.
//

import Foundation
import CoreML


class RTSoundClassifier {
    private var model: EnvSoundClassifier?
    init() {
        // Try to load the environment sound classifier
        model = try? EnvSoundClassifier()
    }
    
    
}
