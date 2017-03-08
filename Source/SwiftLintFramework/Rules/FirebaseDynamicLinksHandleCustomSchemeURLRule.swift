//
//  Copyright (c) Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SourceKittenFramework

public struct FirebaseDynamicLinksHandleCustomSchemeURLRule: ConfigurationProviderRule {

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
