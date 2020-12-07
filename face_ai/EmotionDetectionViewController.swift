
//
//  FaceClassificationViewController.swift
//  face_ai
//
//  Created by M'haimdat omar on 01-03-2020.
//  Copyright © 2020 M'haimdat omar. All rights reserved.
//

import UIKit
import AVKit
import Vision
import VideoToolbox

class EmotionDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let label1: UILabel = {
        let label1 = UILabel()
        label1.backgroundColor = .clear
        label1.textAlignment = .right
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.textColor = .orange
        label1.font = UIFont(name: "Avenir-Heavy", size: 30)
        label1.text = "Natural"
        return label1
    }()
    
    let label2: UILabel = {
        let label2 = UILabel()
        label2.backgroundColor = .clear
        label2.textAlignment = .left
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textColor = .green
        label2.font = UIFont(name: "Avenir-Heavy", size: 30)
        label2.text = "0"
        return label2
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupCamera()
        setupLabel(label: label1)
        setupLabel(label: label2)
    }
    
    func setupTabBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Emotion Detection"
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.barTintColor = .lightText
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.backgroundColor = .white
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    fileprivate func setupLabel(label: UILabel) {
        view.addSubview(label)
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: EmotionDetection_2().model) else {
                    fatalError("Unable to load model")
                }
                
        let coreMlRequest = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else {
                    fatalError("Unexpected results")
            }

            DispatchQueue.main.async {[weak self] in
                self?.label1.text = topResult.identifier
                self?.label2.text = String(topResult.confidence)
            }
            
            print(topResult)
            print(topResult.identifier)
            
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([coreMlRequest])
            } catch {
                print(error)
            }
        }
        
    }
    
}
