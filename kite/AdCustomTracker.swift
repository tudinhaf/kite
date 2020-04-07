//
//  AdCustomTracker.swift
//  kite
//
//  Created by Tú Đình on 4/5/20.
//  Copyright © 2020 Tú Đình. All rights reserved.
//

import Foundation
import AppsFlyerLib

class AdCustomTracker: NSObject, AppsFlyerTrackerDelegate {
    
    //Handle Conversion Data (Deferred Deep Link)
     func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
         print("\(data)")
         if let status = data["af_status"] as? String{
             if(status == "Non-organic"){
                 if let sourceID = data["media_source"] , let campaign = data["campaign"]{
                     print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                 }
             } else {
                 print("This is an organic install.")
             }
             if let is_first_launch = data["is_first_launch"] , let launch_code = is_first_launch as? Int {
                 if(launch_code == 1){
                     print("First Launch")
                 } else {
                     print("Not First Launch")
                 }
             }
         }
     }
     func onConversionDataFail(_ error: Error) {
        print("\(error)")
     }
     
     //Handle Direct Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
         //Handle Deep Link Data
         print("onAppOpenAttribution data:")
         for (key, value) in attributionData {
             print(key, ":",value)
         }
     }
     func onAppOpenAttributionFailure(_ error: Error) {
         print("\(error)")
     }
    
    
}
