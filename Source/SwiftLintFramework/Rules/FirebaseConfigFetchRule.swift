//
//  FirebaseConfigFetchRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseConfigFetchRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_config_fetch",
        name: "Firebase Config Fetch",
        description: "Firebase Config fetch should be called.",
        nonTriggeringExamples: [
            "override func viewDidLoad() {\n super.viewDidLoad() \n remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in \n } \n }"
        ],
        triggeringExamples: [
            "override func viewDidLoad() {\n super.viewDidLoad() \n  \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "viewDidLoad\\(\\)(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "\\.fetch\\(withExpirationDuration:").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity:
                configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
