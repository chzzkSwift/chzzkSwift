import Foundation

public struct ChatBody: Codable {
    let bdy: Body
    let cmd: Int
    let tid: Int
    let cid: String
    let svcid: String
    let ver: String

    init(bdy: Body, cmd: Int, tid: Int, cid: String, svcid: String, ver: String) {
        self.bdy = bdy
        self.cmd = cmd
        self.tid = tid
        self.cid = cid
        self.svcid = svcid
        self.ver = ver
    }
}

struct Body: Codable {
    let accTkn: String
    let auth: String
    let devType: Int
    let uid: String
}
