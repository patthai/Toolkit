//
//  SettingsViewController.swift
//  SceneExample
//
//  Created by George Persiantsev on 8/23/18.
//  Copyright © 2018 Bose Corporation. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var orientationSwitch: UISwitch!
    @IBOutlet weak var mirrorPitchSwitch: UISwitch!
    @IBOutlet weak var mirrorRollSwitch: UISwitch!
    @IBOutlet weak var mirrorYawSwitch: UISwitch!

    var sceneView: SceneViewController?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        orientationSwitch.isOn = Preferences.shared.get(.correctForBaseReading)
        mirrorPitchSwitch.isOn = Preferences.shared.get(.mirrorPitch)
        mirrorRollSwitch.isOn = Preferences.shared.get(.mirrorRoll)
        mirrorYawSwitch.isOn = Preferences.shared.get(.mirrorYaw)
    }

    @IBAction func resetOrientation(_ sender: UIButton) {
        sceneView?.resetOrientation()
    }

    @IBAction func settingChanged(_ sender: UISwitch) {
        let key: Preferences.Key

        switch sender {
        case orientationSwitch:
            key = .correctForBaseReading
        case mirrorPitchSwitch:
            key = .mirrorPitch
        case mirrorRollSwitch:
            key = .mirrorRoll
        case mirrorYawSwitch:
            key = .mirrorYaw
        default:
            return
        }

        Preferences.shared.set(key, to: sender.isOn)
    }
}
