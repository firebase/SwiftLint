//
//  FirebaseDynamicLinksHandleCustomSchemeURLRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseDynamicLinksHandleCustomSchemeURLRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_dynamiclinks_handleURL",
        name: "Firebase DynamicLinks Handle Custom Scheme URL",
        description: "Firebase DynamicLinks should handle custom scheme URL.",
        nonTriggeringExamples: [
            "func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {\n let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) \n return true \n }"
        ],
        triggeringExamples: [
            "func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool { \n return true \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "application: UIApplication, open url: URL(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "\\.dynamicLink\\(fromCustomSchemeURL:").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity: configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
