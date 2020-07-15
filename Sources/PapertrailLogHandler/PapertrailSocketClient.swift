import Foundation
import CocoaAsyncSocket

protocol PapertrailSocketClientDelegate: class {
    func didChangeConnectionStatus(client: PapertrailSocketClient, connectionStatus: PapertrailSocketClient.ConnectionStatus)
}

class PapertrailSocketClient: NSObject {

    enum ConnectionStatus: String {
        case disconnected
        case connecting
        case connected
    }

    lazy private var dateFormatter: DateFormatter = {
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return fm
    }()

    fileprivate var tcpSocket: GCDAsyncSocket!

    private(set) var host: String = ""
    private(set) var port: UInt16 = 0
    var senderName: String = ""
    var programName: String = "program"

    weak var delegate: PapertrailSocketClientDelegate?

    fileprivate(set) var connectionStatus: ConnectionStatus = .disconnected {
        didSet {
            delegate?.didChangeConnectionStatus(client: self, connectionStatus: connectionStatus)
        }
    }
    
    init(host: String, port: UInt16, senderName: String, programName: String) {
        super.init()
        tcpSocket = GCDAsyncSocket(
            delegate: self,
            delegateQueue: DispatchQueue(label: "nl.esites.swift-log.papertrail-delegate"),
            socketQueue: DispatchQueue(label: "nl.esites.swift-log.papertrail-socket"))
        self.host = host
        self.port = port
        self.senderName = senderName
        self.programName = programName

        connectTCPSocket()
    }


    private func connectTCPSocket() {
        do {
            try tcpSocket.connect(toHost: host, onPort: port, withTimeout: -1)
            connectionStatus = .connecting
        } catch {

        }
    }

    func send(message: String, date: Date = Date()) {
        if host == "" || port == 0 {
            return
        }

        if !tcpSocket.isConnected {
            if connectionStatus == .connecting {
                return
            }
            connectTCPSocket()
        }

        let dateString = dateFormatter.string(from: date)

        message.components(separatedBy: "\n")
            .map { "<22>1 \(dateString) \(senderName) \(programName) - - - \($0)\n" }
            .compactMap { $0.data(using: .utf8) }
            .forEach { tcpSocket.write($0, withTimeout: -1, tag: 1) }
    }
}

extension PapertrailSocketClient: GCDAsyncSocketDelegate {

    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        connectionStatus = .connected
    }

    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        connectionStatus = .disconnected
    }

    public func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        connectionStatus = .connected
    }

    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        tcpSocket = newSocket
    }
}
