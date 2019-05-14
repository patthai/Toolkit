//
//  DeviceStatusTableViewController.swift
//  DataExample
//
//  Created by Paul Calnan on 2/12/19.
//  Copyright © 2019 Bose Corporation. All rights reserved.
//

import BoseWearable
import UIKit

class DeviceStatusTableViewController: UITableViewController {

    var device: WearableDevice!

    var token: ListenerToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        token = device.addEventListener(queue: .main) { [weak self] event in
            self?.wearableDeviceEvent(event)
        }
    }

    @IBAction func refresh(_ sender: Any) {
        device.refreshWearableDeviceInformation()
    }

    private func wearableDeviceEvent(_ event: WearableDeviceEvent) {
        guard case .didUpdateWearableDeviceInformation = event else {
            return
        }
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let values = self.values(forRow: indexPath.row)

        cell.textLabel?.text = values?.0
        cell.accessoryType = (values?.1 ?? false) ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 0 else {
            return nil
        }

        return "Each cell corresponds to a bit in the device status bit field. A checkmark appears on the right of the cell if that bit is set."
    }

    /// Convenience accessor to get current device status
    var deviceStatus: DeviceStatus? {
        return device.wearableDeviceInformation?.deviceStatus
    }

    /// Values for the cell at the specified row
    func values(forRow row: Int) -> (String, Bool)? {
        switch row {
        case 0:
            return ("Pairing enabled", deviceStatus?.contains(.pairingEnabled) ?? false)

        case 1:
            return ("Secure BLE pairing required", deviceStatus?.contains(.secureBLEPairingRequired) ?? false)

        case 2:
            return ("Already paired to client", deviceStatus?.contains(.alreadyPairedToClient) ?? false)

        case 3:
            return ("Wearable sensors service suspended", deviceStatus?.contains(.wearableSensorsServiceSuspended) ?? false)

        default:
            return nil
        }
    }
}
