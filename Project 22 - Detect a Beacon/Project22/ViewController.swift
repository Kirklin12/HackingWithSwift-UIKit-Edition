//
//  ViewController.swift
//  Project22
//
//  Created by Mike on 2020-04-02.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    
    var locationManager: CLLocationManager?
    var uuidAlert: UUID!
    var regionFlag = false
    let circle = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //3
        circle.frame = CGRect(x: view.frame.size.width - 128, y: view.frame.size.height - 128, width: 256, height: 256)
        circle.layer.cornerRadius = 128
        circle.backgroundColor = .white
        circle.alpha = 0.7
        view.addSubview(circle)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        //2
        let beaconRegions = [
            CLBeaconRegion(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "MyBeacon1"),
            CLBeaconRegion(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, major: 123, minor: 456, identifier: "MyBeacon2"),
            CLBeaconRegion(uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!, major: 123, minor: 456, identifier: "MyBeacon3")
        ]
        
        beaconRegions.forEach { beacon in
            locationManager?.startMonitoring(for: beacon)
            locationManager?.startRangingBeacons(in: beacon)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
       regionFlag = false
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            //1
            if uuidAlert != beacon.uuid {
                uuidAlert = beacon.uuid
                let ac = UIAlertController(title: "A new beacon is found!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            
            beaconName.text = region.identifier //2
            update(distance: beacon.proximity)
            regionFlag = true

        } else if regionFlag == false {
            update(distance: .unknown)
            beaconName.text = "Unknown"
        }
    }
}
