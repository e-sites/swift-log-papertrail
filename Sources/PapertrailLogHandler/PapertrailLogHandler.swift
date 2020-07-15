import Foundation
import Logging

public struct PapertrailLogHandler: LogHandler {
    public var metadata = Logger.Metadata()
    public var logLevel = Logger.Level.trace
    public var label: String {
        didSet {
            self.queue.socketClient.senderName = label
        }
    }

    public var programName: String {
        didSet {
            self.queue.socketClient.programName = programName
        }
    }

    private let queue: Queue

    public init(label: String, host: String, port: UInt16, programName: String) {
        self.label = label
        self.programName = programName
        let socketClient = PapertrailSocketClient(host: host, port: port, senderName: label, programName: programName)
        self.queue = Queue(socketClient: socketClient)
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        let levelString: String
        switch level {
        case .critical:
            levelString = "CRI"
        case .error:
            levelString = "ERR"
        case .warning:
            levelString = "WAR"
        case .debug:
            levelString = "DEB"
        case .info:
            levelString = "INF"
        case .trace:
            levelString = "TRA"
        case .notice:
            levelString = "NOT"
        }
        var metadataString = ""
        let metadata = (metadata ?? [:]).merging(self.metadata) { current, _ in current }
        if !metadata.isEmpty, let string = prettify(metadata) {
            metadataString = " -- \(string)"
        }
        queue.add(message: "[\(levelString)] \(message.description)\(metadataString)")
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map { "\($0)=\($1)" }.sorted(by: <).joined(separator: ",")
    }
}
