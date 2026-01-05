import OSLog
import SwordRPC

extension RichPresenceManager: SwordRPCDelegate {
    func rpcDidConnect(_ rpc: SwordRPC) {
        self.isConnected = true
        logger.info("Connected to Discord")
    }

    func rpcDidDisconnect(_ rpc: SwordRPC, code: Int?, message: String?) {
        self.isConnected = false
        logger.info(
            "Disconnected from Discord (\(code ?? 0) \(message ?? "<none>"))"
        )
    }

    func rpcDidReceiveError(_ rpc: SwordRPC, code: Int, message: String) {
        logger.error("RPC error \(code): \(message)")
    }
}
