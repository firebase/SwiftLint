//
//  FirebaseConfigDefaultsRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseConfigDefaultsRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_config_defaults",
        name: "Firebase Config Defaults",
        description: "Firebase Config defaults should be set.",
        nonTriggeringExamples: [
            "override func viewDidLoad() {\n super.viewDidLoad() \n  remoteConfig.setDefaultsFromPlistFileName(\"RemoteConfigDefaults\")\n }"
        ],
        triggeringExamples: [
            "override func viewDidLoad() {\n super.viewDidLoad() \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "viewDidLoad\\(\\)(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "\\.setDefaults").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity:
                configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
