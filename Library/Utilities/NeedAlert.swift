//
//  NeedAlert.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

protocol Alertable {
    
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    var showAlertCancel: Bool { get set }
    var showAlertAdd: Bool { get set }
   
    func showAlert(title: String, message: String, alertAdd : Bool)
}

//extension Alertable {
//    mutating func showAlert(title: String, message: String, alertAdd : Bool) {
//        alertTitle = title
//        alertMessage = message
//        if alertAdd {
//            showAlertAdd = true
//        }
//        else {
//            showAlertCancel = true
//        }
//    }
//}
