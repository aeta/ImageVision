//
//  ImageVision+Faces.swift
//  vision-test
//
//  Created by Alan Chu on 6/9/17.
//  Copyright © 2017 Alan Chu. All rights reserved.
//

import Vision

extension ImageVision {
    public func findFaces() -> Int {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        do {
            try vnImageRequestHandler.perform([faceDetectionRequest])
        } catch {
            return 0
        }
        guard let results = faceDetectionRequest.results as? [VNFaceObservation] else { return 0 }
        return results.count
    }

    @available(*, deprecated: 1.0)
    public func extractFaces() -> String {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        do {
            try vnImageRequestHandler.perform([faceDetectionRequest])
        } catch {
            print(error)
            return VoiceoverFaceObservationsCannotFindFaces
        }

        guard let results = faceDetectionRequest.results as? [VNFaceObservation] else { return VoiceoverFaceObservationsCannotFindFaces }
        return buildVoiceoverString(fromFaceObservations: results)
    }

    @available(*, deprecated: 1.0)
    private func buildVoiceoverString(fromFaceObservations faceObservations: [VNFaceObservation]?) -> String {
        guard let observations = faceObservations else { return VoiceoverFaceObservationsCannotFindFaces }

        switch observations.count {
        case 0:
            return VoiceoverFaceObservationsCannotFindFaces
        case 1:
            return VoiceoverFaceObservationsSingleFace
        default:
            return "I found \(observations.count) faces."
        }
    }
}

// MARK: - Tempoary area for storing localization strings
fileprivate let VoiceoverFaceObservationsCannotFindFaces = "I couldn't find any faces in this image."
fileprivate let VoiceoverFaceObservationsSingleFace = "I found 1 face."
