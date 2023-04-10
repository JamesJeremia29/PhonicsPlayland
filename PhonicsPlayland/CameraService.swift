//
//  CameraService.swift
//  PhonicsPlayland
//
//  Created by James Jeremia on 08/04/23.
//

import Foundation
import AVFoundation

class CameraService{
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    var connection: AVCaptureConnection?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()){
        self.delegate = delegate
    }
    
    private func checkPermissions (completion: @escaping (Error?) -> ()){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ [weak self]granted in
                guard granted else{return}
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
                
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()){
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                session.beginConfiguration()
                
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                session.sessionPreset = AVCaptureSession.Preset.low
                connection = AVCaptureConnection(inputPorts: input.ports, output: output)
                session.commitConfiguration()
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
                
            } catch  {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings : AVCapturePhotoSettings = AVCapturePhotoSettings()){
        output.capturePhoto(with: settings, delegate: delegate!)
    }

    
}
