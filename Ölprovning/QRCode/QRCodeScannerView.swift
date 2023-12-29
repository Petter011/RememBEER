//
//  QRCodeScannerView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-15.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        
        init(parent: QRCodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if !parent.shouldScan {
                // Stop scanning if the flag is false
                return
            }
            
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                // Process the scanned QR code value (in this case, the beer data)
                DispatchQueue.main.async {
                    self.parent.didFindCode(stringValue)
                }
            }
        }
    }
    
    var didFindCode: (String) -> Void
    @Binding var shouldScan: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let scanner = AVCaptureSession()
        
        DispatchQueue.global(qos: .background).async {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (scanner.canAddInput(videoInput)) {
                scanner.addInput(videoInput)
            } else {
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (scanner.canAddOutput(metadataOutput)) {
                scanner.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.global(qos: .background))
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                return
            }
            
            // Ensure UI updates on the main thread
            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: scanner)
                previewLayer.frame = uiViewController.view.layer.bounds
                previewLayer.videoGravity = .resizeAspectFill
                
                // Set the video orientation based on the device orientation
                if let connection = previewLayer.connection {
                    let currentDevice: UIDevice = UIDevice.current
                    let orientation: UIDeviceOrientation = currentDevice.orientation
                    let previewLayerConnection: AVCaptureConnection = connection
                    
                    if previewLayerConnection.isVideoOrientationSupported {
                        switch orientation {
                        case .portrait:
                            previewLayerConnection.videoOrientation = .portrait
                        case .landscapeRight:
                            previewLayerConnection.videoOrientation = .landscapeLeft
                        case .landscapeLeft:
                            previewLayerConnection.videoOrientation = .landscapeRight
                        case .portraitUpsideDown:
                            previewLayerConnection.videoOrientation = .portraitUpsideDown
                        default:
                            previewLayerConnection.videoOrientation = .portrait
                        }
                    }
                }
                
                uiViewController.view.layer.addSublayer(previewLayer)
                
                // Start running on the background thread
                DispatchQueue.global(qos: .background).async {
                    scanner.startRunning()
                }
            }
        }
    }

}






