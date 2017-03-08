//
//  FirebaseDynamicLinksHandleUniversalLinkRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseDynamicLinksHandleUniversalLinkRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_dynamiclinks_universallink",
        name: "Firebase DynamicLinks Handle UniversalLink",
        description: "Firebase DynamicLinks should handle univerasl links.",
        nonTriggeringExamples: [
            "func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {\n let dynamicLink = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in { \n } \n return true \n }"
        ],
        triggeringExamples: [
            "func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {\n return true \n }"
        ]
    )

    // TODO: Handle the existence of application: UIApplication, continue userActivity:
    // function in AppDelegate
    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "application: UIApplication, continue userActivity: NSUserActivity(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "\\.handleUniversalLink\\(").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity: configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
