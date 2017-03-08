//
//  FirebaseConfigActivateRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseConfigActivateRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_config_activate",
        name: "Firebase Config Activate",
        description: "Firebase Config should be activated.",
        nonTriggeringExamples: [
            "remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in \n self.remoteConfig.activateFetched() \n }"
        ],
        triggeringExamples: [
            "remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "\\.fetch\\(withExpirationDuration:(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "\\.activateFetched\\(\\)").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity:
                configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
