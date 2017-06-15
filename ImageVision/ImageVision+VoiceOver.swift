//
//  ImageVision+VoiceOver.swift
//  vision-test
//
//  Created by Alan Chu on 6/9/17.
//  Copyright © 2017 Alan Chu. All rights reserved.
//

import Vision

public enum ImageVisionObservationTypes {
    case object
    case scene
}

extension ImageVision {
    static public func constructVoiceoverString(fromObservationObjectResult objectResult: ImageVisionObservationResults, andObservationSceneResult sceneResult: ImageVisionObservationResults? = nil, withFaces faces: Int = 0) -> String {

        let objectFormatted = formattingObservationResults(objectResult, observationType: .object)
        var sceneFormatted: String?
        if let scene = sceneResult {
            sceneFormatted = formattingObservationResults(scene, observationType: .scene)
        }

        // Prepend the approprate phrase for number of faces, if there are no faces, `faces <= 0`, it will not prepend anything
        var facesExtension: String?
        if faces > 0 {
            // If there is only one face, use singular phrase, "a face", otherwise use plural phrase, "x faces"
            facesExtension = "There is \(faces == 1 ? "a face" : "\(faces) faces") and "
        }

        return "\(facesExtension ?? "")\(objectFormatted ?? "")\(sceneFormatted ?? "")"
    }

    /// If `result.confidence == .none`, this will return `nil`
    static fileprivate func formattingObservationResults(_ result: ImageVisionObservationResults, observationType: ImageVisionObservationTypes) -> String? {
        let classification = result.0
        let confidence = ImageVisionConfidence(vnConfidence: VNConfidence(result.1))

        guard confidence != .none else { return nil }

        // Start by processing classification identifier
        let vowels: [Character] = ["a","e","i","o","u"]
        let isObjectFirstLetterVowel = vowels.contains(classification.lowercased().characters.first ?? "z")       // Determines whether or not to use `a` or `an`

        // Some results use `underscroll` as a space, so replace any ocurrances it
        let fixedClassification = classification.replacingOccurrences(of: "_", with: " ")

        // Sort and use the first classification because it is considered the most confident answer
        let split = fixedClassification.split(separator: ",")
        guard let mostConfidentClassification = split.first else { fatalError("Couldn't get the first of a splitted string 😨") }
        var secondMostConfidentClassification: Substring?
        if split.count > 1 {
            secondMostConfidentClassification = split[1]
        }

        // If first letter is vowel, then use `an`, otherwise use `a`
        let sentenceExtension = isObjectFirstLetterVowel ? "an" : "a"
        
        return "\(confidence.toVoiceoverStringAsObject()) I see \(sentenceExtension) \(mostConfidentClassification) \(secondMostConfidentClassification != nil ? "or\(secondMostConfidentClassification!)" : "")"
//        switch observationType {
//        case .object:
//            return "\(confidence.toVoiceoverStringAsObject()) I see \(sentenceExtension) \(mostConfidentClassification) \(secondMostConfidentClassification != nil ? "or\(secondMostConfidentClassification)" : "")"
//        case .scene:
//            return "\(confidence.toVoiceoverStringAsScene()) \(sentenceExtension) \(mostConfidentClassification) "
//        }
    }
}

extension ImageVisionConfidence {
    public func toVoiceoverStringAsObject() -> String {
        switch self {
        case .high:
            return ImageVisionObjectConfidenceVoiceoverHigh
        case .medium:
            return ImageVisionObjectConfidenceVoiceoverMedium
        case .low:
            return ImageVisionObjectConfidenceVoiceoverLow
        case .none:
            return ImageVisionObjectConfidenceVoiceoverNone
        }
    }

    public func toVoiceoverStringAsScene() -> String {
        switch self {
        case .high:
            return ImageVisionSceneConfidenceVoiceoverHigh
        case .medium:
            return ImageVisionSceneConfidenceVoiceoverMedium
        case .low:
            return ImageVisionSceneConfidenceVoiceoverLow
        case .none:
            return ImageVisionSceneConfidenceVoiceoverNone
        }
    }
}

// MARK: - Tempoary area for storing localization strings
fileprivate let ImageVisionObjectConfidenceVoiceoverHigh = "I'm pretty sure"
fileprivate let ImageVisionObjectConfidenceVoiceoverMedium = "I think"
fileprivate let ImageVisionObjectConfidenceVoiceoverLow = "I'm unsure, but I think"
fileprivate let ImageVisionObjectConfidenceVoiceoverNone = "Sorry, I can't understand this image"

fileprivate let ImageVisionSceneConfidenceVoiceoverHigh = "in"
fileprivate let ImageVisionSceneConfidenceVoiceoverMedium = "in what might be"
fileprivate let ImageVisionSceneConfidenceVoiceoverLow = "in what seems to be"
fileprivate let ImageVisionSceneConfidenceVoiceoverNone = "ImageVisionSceneConfidenceVoiceoverNone"
