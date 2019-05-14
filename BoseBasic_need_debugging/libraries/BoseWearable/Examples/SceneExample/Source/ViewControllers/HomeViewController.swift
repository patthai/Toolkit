//
//  HomeViewController.swift
//  SceneExample
//
//  Created by Paul Calnan on 7/16/18.
//  Copyright © 2018 Bose Corporation. All rights reserved.
//

import BoseWearable
import UIKit

/// This view controller is the initial screen in the example app. It provides buttons allowing the user to open a session with a device.
class HomeViewController: UITableViewController {

    @IBOutlet var rotationSource: UISegmentedControl!

    @IBOutlet var autoselectSwitch: UISwitch!

    private var activityIndicator: ActivityIndicator?

    @IBOutlet var versionLabel: UILabel!

    private var mode: DeviceSearchMode {
        return autoselectSwitch.isOn
            ? .automaticallySelectMostRecentlyConnectedDevice(timeout: 5)
            : .alwaysShowUI
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "BoseWearable \(BoseWearable.formattedVersion)"
    }

    @IBAction func searchTapped(_ sender: Any) {
        activityIndicator = ActivityIndicator.add(to: navigationController?.view)

        BoseWearable.shared.startDeviceSearch(mode: mode) { result in
            switch result {
            case .success(let session):
                self.showScene(with: session)

            case .failure(let error):
                self.show(error)

            case .cancelled:
                break
            }

            self.activityIndicator?.removeFromSuperview()
        }
    }

    @IBAction func useSimulatedAttitudeTapped(_ sender: Any) {
        showScene(with: BoseWearable.shared.createSimulatedWearableDeviceSession())
    }

    private func showScene(with session: WearableDeviceSession) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SceneViewController") as? SceneViewController else {
            fatalError("Cannot instantiate view controller")
        }

        switch rotationSource.selectedSegmentIndex {
        case 0:
            vc.rotationMode = .rotationVector
        case 1:
            vc.rotationMode = .gameRotationVector
        default:
            fatalError("Invalid rotation mode selected")
        }

        vc.session = session
        show(vc, sender: self)
    }
}
