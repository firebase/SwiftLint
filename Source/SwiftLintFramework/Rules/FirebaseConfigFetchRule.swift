//
//  FirebaseConfigFetchRule.swift
//  SwiftLint
//
//  Created by Ibrahim Ulukaya (Google Inc.) on 3/8/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import SourceKittenFramework

public struct FirebaseConfigFetchRule: ASTRule, RecursiveRule, OptInRule {

    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "firebase_config_fetch",
        name: "Firebase Config Fetch",
        description: "Firebase Config fetch should be called in viewDidLoad().",
        nonTriggeringExamples: [
            "class ViewController: UIViewController {\n" +
            "  override func viewDidLoad() {\n" +
            "    super.viewDidLoad() \n" +
            "    remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) {" +
            "        (status, error) -> Void in \n" +
            "    }\n" +
            "  }\n" +
            "}"
        ],
        triggeringExamples: [
            "class ViewController: UIViewController {\n" +
            "  override func viewDidLoad() {\n" +
            "    super.viewDidLoad() \n" +
            "  }\n" +
            "  func fetch {\n " +
            "    remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) {" +
            "        (status, error) -> Void in \n" +
            "    }\n" +
            "  }\n" +
            "}"
        ]
    )

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation] {
        guard SwiftExpressionKind.call == kind else {
            return []
        }

        guard let name = dictionary.name, name.hasSuffix(".fetch") else {
            return []
        }

        guard let param = dictionary.substructure.first, param.name == "withExpirationDuration" else {
            return []
        }

        guard let first = file.structure.dictionary.substructure.first else {
            return []
        }

        guard first.inheritedTypes.contains("UIViewController")  else {
            return []
        }

        for method in first.substructure where
            SwiftDeclarationKind.functionMethodInstance.rawValue == method.kind &&
                method.name == "viewDidLoad()" {
                    return validateRecursive(file: file, dictionary: method)
        }
        return [StyleViolation(ruleDescription: type(of: self).description,
                               severity: configuration.severity,
                               location: Location(file: file, byteOffset: first.offset ?? 0))]
    }

    public func validateBaseCase(dictionary: [String : SourceKitRepresentable]) -> Bool {
        if let kindString = dictionary.kind, SwiftExpressionKind(rawValue: kindString) == .call,
            let name = dictionary.name, name.hasSuffix(".fetch"),
                let param = dictionary.substructure.first, param.name == "withExpirationDuration" {
            return true
        }
        return false
    }
}
