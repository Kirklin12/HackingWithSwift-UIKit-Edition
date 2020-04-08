//
//  ViewController.swift
//  Project16
//
//  Created by Mike on 2019-10-30.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")
        let washington = Capital(title: "Washington, D.C.", coordinate: CLLocationCoordinate2D(latitude: 39.895111, longitude: -77.036667), info: "Named after George himself")
        
//        mapView.addAnnotation(london)
//        mapView.addAnnotation(oslo)
//        mapView.addAnnotation(paris)
//        mapView.addAnnotation(rome)
//        mapView.addAnnotation(washington)
        
        // More convenient way:
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        //2
        let ac = UIAlertController(title: "Choose map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: mapTypeSwitch))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: mapTypeSwitch))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: mapTypeSwitch))
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView //1. typecasting the return value

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .purple //1. changed color property

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn

        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    // default callout button
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        guard let capital = view.annotation as? Capital else { return }
//
//        let placeName = capital.title
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//    }
    
    //3
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        if let vc = storyboard?.instantiateViewController(withIdentifier: "Wiki") as? WebViewController {
            vc.placeName = capital.title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //2
    func mapTypeSwitch(action: UIAlertAction) {
        guard let type = action.title else { return }

        switch type {
        case "Standard":
            mapView.mapType = MKMapType.standard
        case "Satellite":
            mapView.mapType = MKMapType.satellite
        case "Hybrid":
             mapView.mapType = MKMapType.hybrid
        default:
            mapView.mapType = MKMapType.standard
        }
    }
}
