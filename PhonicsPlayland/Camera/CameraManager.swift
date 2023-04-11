//
//  CameraManager.swift
//  PhonicsPlayland
//
//  Created by James Jeremia on 10/04/23.
//

import AVFoundation
// 1
class CameraManager: ObservableObject {
    // 1
    @Published var error: CameraError?
    // 2
    let session = AVCaptureSession()
    // 3
    private let sessionQueue = DispatchQueue(label: "phonics")
    // 4
    private let videoOutput = AVCaptureVideoDataOutput()
    // 5
    private var status = Status.unconfigured
    
//    private var photoOutput = AVCapturePhotoOutput()
    
    // 2
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    // 3
    static let shared = CameraManager()
    // 4
    private init() {
        configure()
    }
    // 5
    private func configure() {
        checkPermissions()
        sessionQueue.async {
          self.configureCaptureSession()
          self.session.startRunning()
        }

    }
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    private func checkPermissions() {
        // 1
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 2
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                // 3
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
            // 4
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
            // 5
        case .authorized:
            break
            // 6
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        do {
          // 1
          let cameraInput = try AVCaptureDeviceInput(device: camera)
          // 2
          if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
          } else {
            // 3
            set(error: .cannotAddInput)
            status = .failed
            return
          }
        } catch {
          // 4
          set(error: .createCaptureInput(error))
          status = .failed
          return
        }
        // 1
        if session.canAddOutput(videoOutput) {
          session.addOutput(videoOutput)
          // 2
          videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
          // 3
          let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation =  .portrait
        } else {
          // 4
          set(error: .cannotAddOutput)
          status = .failed
          return

        }
        
//        if session.canAddOutput(photoOutput) {
//          session.addOutput(photoOutput)
//          // 2
//        } else {
//          // 4
//          set(error: .cannotAddOutput)
//          status = .failed
//          return
//
//        }


        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        status = .configured
    }
    
//    @objc private func handleTakePhoto(){
//        let photoSettings = AVCapturePhotoSettings()
//        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first{
//            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
//            photoOutput.capturePhoto(with: photoSettings, delegate: self)
//        }
//    }

    func set(
      _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
      queue: DispatchQueue
    ) {
      sessionQueue.async {
        self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
      }
    }
    

}
