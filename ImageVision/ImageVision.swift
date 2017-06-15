//
//  ImageVision.swift
//  vision-test
//
//  Created by Alan Chu on 6/7/17.
//  Copyright © 2017 Alan Chu. All rights reserved.
//

import Vision
import UIKit

/// `classification`, `confidence`
public typealias ImageVisionObservationResults = (String, Double)

public enum ImageVisionConfidence {
    case low
    case medium
    case high
    case none

    public init(vnConfidence confidence: VNConfidence) {
        if confidence < 0.1 {
            self = .low
        } else if confidence > 0.6 {
            self = .high
        } else {
            self = .medium
        }
    }
}

public protocol ImageVisionProtocol: class {
    func handleNewClassification(_ results: ImageVisionObservationResults)
}

public class ImageVision {
    weak public var delegate: ImageVisionProtocol?
    internal let vnImageRequestHandler: VNImageRequestHandler

    public init(withImage image: UIImage) {
        guard let cgImage = image.cgImage else {
            fatalError("Unable to cast UIImage to CGImage")
        }
        self.vnImageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
    }

    public func runModel(withMLModels models: [MLModel]) {
        var classificationRequests: [VNCoreMLRequest] = []
        for model in models {
            do {
                let coreModel = try VNCoreMLModel(for: model)
                classificationRequests.append(VNCoreMLRequest(model: coreModel, completionHandler: self.handleClassification))
            } catch {
                fatalError("can't load Vision ML model: \(error)")
            }
        }

        // Run the Core ML MNIST classifier -- results in classificationRequests method
        do {
            try vnImageRequestHandler.perform(classificationRequests)
        } catch {
            print(error)
        }
    }

    func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation]
            else { fatalError("unexpected result type from VNCoreMLRequest") }

        for observation in observations {
            DispatchQueue.main.async {
                let results = ImageVisionObservationResults(observation.identifier, Double(observation.confidence))
                self.delegate?.handleNewClassification(results)
            }
        }
    }
}

