import OSLog
import SwordRPC

extension RichPresenceManager: SwordRPCDelegate {
    func rpcDidConnect(_ rpc: SwordRPC) {
        self.isConnected = true
        logger.info("Connected to Discord")
    }

    func rpcDidDisconnect(_ rpc: SwordRPC, code: Int?, message: String?) {
        guard let code, let message else { return }
        self.isConnected = false
        logger.info(
            "Disconnected from Discord (\(code) \(message))"
        )
    }

    func rpcDidReceiveError(_ rpc: SwordRPC, code: Int, message: String) {
        logger.error("RPC error \(code): \(message)")
    }
}
