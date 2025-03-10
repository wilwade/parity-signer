//
//  Camera.swift
//  NativeSigner
//
//  Created by Alexander Slesarev on 20.7.2021.
//

/// This contains standard Apple boilerplate to generate basic camera preview

import AVFoundation
import Combine
import Foundation

final class CameraViewModel: ObservableObject {
    private let service = CameraService()

    @Published var payload: String?
    @Published var captured: Int?
    @Published var total: Int?

    @Published var showAlertError = false

    var isFlashOn = false

    var session: AVCaptureSession

    private var subscriptions = Set<AnyCancellable>()

    init() {
        session = service.session

        service.$payload.sink { [weak self] payload in
            guard let value = payload else { return }
            self?.payload = value
        }
        .store(in: &subscriptions)

        service.$captured.sink { [weak self] captured in
            guard let value = captured else { return }
            self?.captured = value
        }
        .store(in: &subscriptions)

        service.$total.sink { [weak self] total in
            guard let value = total else { return }
            self?.total = value
        }
        .store(in: &subscriptions)
    }

    func configure() {
        service.checkForPermissions()
        service.configure()
    }

    func shutdown() {
        print(payload ?? "No payload catpured by camera")
        service.stop()
    }

    /// Clears recorded frames and starts anew
    func reset() {
        service.emptyBucket()
        captured = nil
        total = nil
    }
}
