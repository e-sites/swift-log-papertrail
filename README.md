# swift-log-papertrail

![Swift](https://img.shields.io/badge/Swift-5.2-orange.svg)

This package implements a handler for [swift-log](https://github.com/apple/swift-log) which will send log messages to the [Papertrail's](https://www.papertrail.com) Log Management service.

## Usage

###  Add Package
Integrate the `PapertrailLogHandler` package as a dependency with Swift Package Manager. Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/e-sites/swift-log-papertrail.git", from: "1.0.0")
```

Add `PapertrailLogHandler` to your target dependencies:

```swift
.product(name: "PapertrailLogHandler", package: "swift-log-papertrail")
```

### Configure

Configure the logger by bootstrapping a `PapertrailLogHandler` instance.

```swift
import PapertrailLogHandler
import Logging

LoggingSystem.bootstrap { label in
	return PapertrailLogHandler(label: label,
	                            host: "logs9.papertrailapp.com",
	                            port: 1234,
	                            programName: UUID().uuidString)
	                            
	// Or use `MultiplexLogHandler` to use multiple LogHandlers
}
```

### Logging

To send logs to Papertrail, initialize a `Logger` instance and send a message with optional additional metadata:

```swift
import Loggingx

let logger = Logger(label: "com.swift-log.awesome-app")
logger.error("unfortunate error", metadata: ["request-id": "abc-123"])
```