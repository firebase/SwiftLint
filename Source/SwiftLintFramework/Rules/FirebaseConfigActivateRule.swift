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

public struct FirebaseConfigActivateRule: ConfigurationProviderRule {

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
