//
//  HomeViewController.swift
//  DataExample
//
//  Created by Paul Calnan on 9/19/18.
//  Copyright © 2018 Bose Corporation. All rights reserved.
//

import BoseWearable
import UIKit

class HomeViewController: UITableViewController {

    private var activityIndicator: ActivityIndicator?

    @IBOutlet var autoselectSwitch: UISwitch!

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
                self.showDeviceInfo(for: session)

            case .failure(let error):
                self.show(error)

            case .cancelled:
                break
            }

            self.activityIndicator?.removeFromSuperview()
        }
    }

    @IBAction func useSimulatedDeviceTapped(_ sender: Any) {
        showDeviceInfo(for: BoseWearable.shared.createSimulatedWearableDeviceSession())
    }

    private func showDeviceInfo(for session: WearableDeviceSession) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceTableViewController") as? DeviceTableViewController else {
            fatalError("Cannot instantiate view controller")
        }

        vc.session = session
        show(vc, sender: self)
    }
}
