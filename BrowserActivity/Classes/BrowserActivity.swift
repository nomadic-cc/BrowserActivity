//
//  BrowserActivity.swift
//  The Tech Time
//
//  Created by Rakshit Majithiya on 1/11/17.
//
//

import Foundation

public class BrowserActivity: UIActivity {
    var urlToOpen: URL?
    var foundURL: URL? {
        didSet {
            urlToOpen = foundURL
        }
    }
    var canOpen: (Any) -> Bool = { item in
        return item is URL && UIApplication.shared.canOpenURL(item as! URL)
    }

    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return activityItems.contains(where: canOpen)
    }

    public override func prepare(withActivityItems activityItems: [Any]) {
        foundURL = activityItems.first(where: canOpen) as? URL
    }

    public override func perform() {
        guard let url = urlToOpen else {
            activityDidFinish(false)
            return
        }
        activityDidFinish(UIApplication.shared.openURL(url))
    }

    public static var compatibleActivities: [BrowserActivity] {
        var activities: [BrowserActivity] = [SafariActivity()]

        if GoogleChromeActivity.isChromeInstalled {
            activities.append(GoogleChromeActivity())
        }

        return activities
    }
}
