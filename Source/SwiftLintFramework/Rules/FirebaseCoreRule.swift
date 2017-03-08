//
//  FirebaseCoreRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseCoreRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_core",
        name: "Firebase Core",
        description: "Firebase should be configured before use.",
        nonTriggeringExamples: [
            "func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {\n FIRApp.configure()\n return true \n }"
        ],
        triggeringExamples: [
            "func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {\n return true \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "didFinishLaunchingWithOptions(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "FIRApp\\.configure\\(\\)").map {
                        StyleViolation(ruleDescription: type(of: self).description,
                                       severity: configuration.severity,
                                       location: Location(file: file, characterOffset: $0.location))
        }
    }
}
