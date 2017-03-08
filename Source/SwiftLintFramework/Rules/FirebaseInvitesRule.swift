//
//  FirebaseInvitesRule.rule
//  SwiftLint
//
//  Created by Ibrahim Ulukaya on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseInvitesRule: ConfigurationProviderRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_invites",
        name: "Firebase Invites",
        description: "Firebase Invites should be handled.",
        nonTriggeringExamples: [
            "func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {\n FIRInvites.handle(url, sourceApplication:sourceApplication, annotation:annotation) \n return true \n }"
        ],
        triggeringExamples: [
            "func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {\n return true \n }"
        ]
    )

    public func validate(file: File) -> [StyleViolation] {
        return file.match(pattern: "application: UIApplication, open url: URL(.|\n)*\\}", excludingSyntaxKinds: [], excludingPattern: "FIRInvites\\.handle\\(").map {
            StyleViolation(ruleDescription: type(of: self).description,
                           severity: configuration.severity,
                           location: Location(file: file, characterOffset: $0.location))
        }
    }
}
