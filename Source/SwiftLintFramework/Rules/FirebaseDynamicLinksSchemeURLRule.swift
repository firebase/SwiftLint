//
//  FirebaseDynamicLinksSchemeURLRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseDynamicLinksSchemeURLRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_dynamiclinks_schemeURL",
        name: "Firebase DynamicLinks SchemeURL",
        description: "Firebase DynamicLinks schemeURL should be set.",
        nonTriggeringExamples: [
            "func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {\n FIROptions.default().deepLinkURLScheme = self.customURLScheme \n return true \n }"
        ],
        triggeringExamples: [
            "func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {\n return true \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "didFinishLaunchingWithOptions(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "\\.deepLinkURLScheme =").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity: configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
