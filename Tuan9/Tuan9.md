# BASIC NETWORKING

## 1. TCP/IP và OSI

* Cách một nút mạng được quản lý :
Phân chia nhiệm vụ cho các thành phần và tổ chức các chúng thành các tầng (layer)
Trong đó, mỗi tầng:
- Có thể thực hiện một hay nhiều chức năng khác nhau
- Mỗi dịch vụ có thể có một hay nhiều cách triển khai khác nhau
- Các tầng ngang hàng trên liên kết sử dụng chung giao thức

* **OSI model** (Open Systems Interconnection): 7 tầng

  1. Physical
  2. Data Link
  3. Network
  4. Transport
  5. Session
  6. Presentation
  7. Application

![osi](https://github.com/user-attachments/assets/9d834434-c1c3-4daf-b177-7fdcc19cd621)

| **Tầng (Tên - Số)**       | **Chức năng chính**                                                                                                                                             | **Đơn vị dữ liệu (PDU)**               | **Giao thức / Chuẩn tiêu biểu**                                 | **Thiết bị hoạt động**                          |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- | --------------------------------------------------------------- | ----------------------------------------------- |
| **Tầng 7 – Application**  | - Giao tiếp trực tiếp với người dùng hoặc ứng dụng<br>- Cung cấp các dịch vụ mạng như web, mail, truy cập từ xa, tên miền,...                                   | **Data**                               | HTTP, HTTPS, FTP, SMTP, POP3, IMAP, DNS, Telnet, SSH, SNMP, NTP | Ứng dụng, Web Server, Mail Server               |
| **Tầng 6 – Presentation** | - Chuyển đổi định dạng dữ liệu (encoding)<br>- Mã hóa/giải mã (Encryption/Decryption)<br>- Nén/giải nén dữ liệu (Compression)                                   | **Data**                               | SSL/TLS, ASCII, JPEG, MPEG, PNG, GIF                            | Thư viện mã hóa (OpenSSL), phần mềm trình chiếu |
| **Tầng 5 – Session**      | - Thiết lập, duy trì và kết thúc phiên kết nối<br>- Đồng bộ dữ liệu giữa hai đầu (checkpoint, recovery)                                                         | **Data**                               | NetBIOS, RPC, PPTP, SMB Session, TLS session                    | Load Balancer, Gateway, Session Manager         |
| **Tầng 4 – Transport**    | - Truyền dữ liệu end-to-end giữa host<br>- Phân mảnh và tái lắp ráp dữ liệu<br>- Kiểm soát luồng, lỗi, đảm bảo thứ tự (TCP)<br>- Dịch vụ hướng hoặc phi kết nối | **Segment (TCP)** / **Datagram (UDP)** | TCP, UDP, SCTP, DCCP                                            | Firewall, Load Balancer, Proxy                  |
| **Tầng 3 – Network**      | - Định tuyến và xác định đường đi<br>- Định địa chỉ logic (IP)<br>- Phân mảnh và hợp nhất gói tin                                                               | **Packet**                             | IP (IPv4, IPv6), ICMP, IGMP, OSPF, RIP, BGP, ARP                | Router, Layer 3 Switch, Firewall                |
| **Tầng 2 – Data Link**    | - Đóng khung dữ liệu (framing)<br>- Đánh địa chỉ vật lý (MAC)<br>- Phát hiện lỗi, kiểm soát truy cập đường truyền (CSMA/CD, VLAN, STP)                          | **Frame**                              | Ethernet (IEEE 802.3), ARP, VLAN (802.1Q), STP, PPP             | Switch, Bridge, NIC, Access Point               |
| **Tầng 1 – Physical**     | - Truyền bit thô (0/1) dưới dạng tín hiệu điện/quang/vô tuyến<br>- Đặc tả phần cứng: điện áp, tốc độ, đầu nối                                                   | **Bit**                                | Ethernet Physical, RS-232, DSL, Fiber, IEEE 802.11 PHY          | Cáp, Hub, Repeater, Modem, NIC                  |

* **TCP/IP model**: 5 tầng

  1. Physical
  2. Link
  3. Internet (Network trong OSI)
  4. Transport (Transport trong OSI)
  5. Application (Session + Presentation + Application trong OSI)

<img width="495" height="353" alt="tcp-ip" src="https://github.com/user-attachments/assets/9146a937-27bf-4918-8ae3-a315aa15fb58" />

Hệ thống mạng hiện nay sử dụng **duy nhất một giao thức liên mạng là IP (Internet Protocol)** ở tầng mạng.

Giao thức IP cho phép **các hệ thống mạng khác nhau, sử dụng bất kỳ công nghệ truyền dẫn nào**, đều có thể **kết nối và trao đổi dữ liệu với nhau**, miễn là công nghệ đó có khả năng **đóng gói và truyền được gói tin IP**.

Nhờ đó, **tầng mạng (IP)** đóng vai trò trung gian tách biệt giữa:

* **Tầng ứng dụng ở phía trên**: có thể phát triển độc lập, chỉ cần biết địa chỉ IP mà không cần quan tâm đến công nghệ truyền dẫn bên dưới.
* **Tầng vật lý và liên kết dữ liệu ở phía dưới**: các kỹ sư có thể phát triển công nghệ truyền dẫn mới (như Wi-Fi, 5G, hay quang học) mà không phải thay đổi ứng dụng ở tầng cao.

Điều này giúp **tầng ứng dụng và tầng truyền dẫn có thể tiến hóa song song**, không phụ thuộc lẫn nhau, duy trì khả năng tương thích và mở rộng của toàn bộ Internet.

Tuy nhiên, chính việc IP trở thành nền tảng chung toàn cầu khiến **việc nâng cấp bản thân giao thức IP trở nên rất khó khăn**.
Ví dụ: quá trình chuyển đổi từ **IPv4 sang IPv6** gặp nhiều trở ngại, do yêu cầu **thay đổi đồng bộ trên quy mô toàn cầu**, ảnh hưởng đến vô số thiết bị và hạ tầng mạng hiện có.

---

## 2. Encapsulation

* **Định nghĩa:** quá trình đóng gói dữ liệu khi đi xuống các tầng mạng.
* **Mục đích:** thêm header/trailer để dữ liệu có thể được truyền chính xác (ví dụ: TCP header thêm port, IP header thêm địa chỉ IP, Ethernet frame thêm MAC).

### Tổng quan Encapsulation (sơ đồ đơn giản)

```
Application (data)
    ↓
Presentation (formatted data)
    ↓
Session (session info)
    ↓
Transport (segment)            <- TCP/UDP header (src port, dst port, seq, ack, flags)
    ↓
Network (packet)              <- IP header (src IP, dst IP, TTL, protocol)
    ↓
Data Link (frame)             <- Ethernet header (dst MAC, src MAC, EtherType) + FCS
    ↓
Physical (bits)               <- tín hiệu điện/ánh sáng/wireless
```

<img width="696" height="453" alt="encap-decap" src="https://github.com/user-attachments/assets/4acbad2a-07fe-47a5-8dbe-6a9d535f572e" />
---

## 3. Application Layer Service and Protocol

* Protocol : Giao thức (Network protocol): là tập hợp các quy tắc quy định khuôn dạng, ngữ nghĩa, thứ tự các thông điệp được gửi và nhận giữa các nút mạng và các hành vi khi trao đổi các thông điệp. Các tầng đồng cấp ở mỗi bên sử dụng chung giao thức để phối hợp với nhau thực hiện chức năng tầng → 2 cách thức để giao thức trao đổi ngang tầng: hướng liên kết hoặc hướng không liên kết

Một số giao thức lớp ứng dụng:

# 1. DNS (Domain Name System)

## Mục đích

Chuyển đổi tên miền (human-readable names) ↔ địa chỉ IP. Ngoài ra còn hỗ trợ ghi các bản ghi khác: MX, TXT, CNAME, NS, SRV, PTR, SOA, v.v.

## Kiểu giao tiếp & cổng

* Giao thức ứng dụng chạy trên **UDP** (thường) và **TCP** (khi trả về dữ liệu lớn hoặc dùng cho zone transfer).
* **Port:** UDP/TCP **53**.

## Bản ghi (record) chính

* **A**: tên → IPv4
* **AAAA**: tên → IPv6
* **CNAME**: bí danh → tên khác
* **MX**: mail exchanger (ưu tiên máy nhận mail)
* **NS**: nameserver cho zone
* **PTR**: reverse lookup (IP → tên)
* **SOA**: thông tin zone (serial, refresh, retry, expire, ttl)
* **SRV**: dịch vụ (ví dụ SIP, XMPP)
* **TXT**: văn bản (SPF, DKIM…)

## Cách hoạt động (overview)

1. **Resolver (client)** kiểm tra cache cục bộ → /etc/hosts → nếu cần gửi truy vấn tới recursive resolver (ISP hoặc public resolver).
2. **Recursive resolver** thực hiện truy vấn đệ quy: hỏi root → TLD → authoritative NS → lấy bản ghi trả về cho client.
3. **Caching**: resolver lưu bản ghi theo TTL để giảm tải.

## Thông điệp DNS (ngắn)

* Header (ID, flags: QR, Opcode, AA, TC, RD, RA, RCODE), Questions, Answers, Authority, Additional.
* QR = 0 (query) / 1 (response). RD (recursion desired), RA (recursion available).

## Luồng ví dụ (recursive A lookup)

Client → resolver: `Query A example.com (UDP:53)`
Resolver → root: `Query NS .` → root trả referral → resolver → .com TLD → referral → resolver → authoritative NS → query A → answer → resolver trả cho client.

## Bảo mật & vấn đề

* **DNS spoofing/poisoning** nếu resolver không xác minh; **DNSSEC** cung cấp chữ ký số để xác thực bản ghi (không mã hóa nội dung).
* **Privacy**: truy vấn DNS qua UDP rõ ràng → DNS over TLS (DoT, port 853) và DNS over HTTPS (DoH, port 443) để bảo vệ riêng tư.
* **Zone transfer (AXFR/IXFR)** qua TCP 53; nên giới hạn bằng ACL.

## Kiểm tra / lệnh

* `dig example.com A` (chi tiết + flags)
* `dig +trace example.com` (theo dõi từ root)
* `nslookup`, `host`

---

# 2. FTP (File Transfer Protocol)

## Mục đích

Truyền file giữa client và server, hỗ trợ danh sách thư mục, upload/download, điều khiển file.

## Kiểu giao tiếp & cổng

* **Port điều khiển:** TCP **21** (control connection)
* **Port dữ liệu:** có thể là active hoặc passive mode (Active: server kết nối về client; Passive: client kết nối tới server).

  * Active: server dùng **port 20** (data) để kết nối về client.
  * Passive: server mở một port động (>1024) và client kết nối tới đó.

## Modes

* **Active (PORT)**: client lắng nghe một port ngẫu nhiên, gửi PORT command cho server; server mở kết nối TCP từ port 20 → client port.
* **Passive (PASV)**: server gửi port passive cho client; client kết nối tới server port đó. (firewall-friendly → PASV phổ biến)

## Các lệnh control tiêu biểu (RFC 959)

* `USER`, `PASS`, `ACCT`, `CWD`, `PWD`, `LIST`, `NLST`, `RETR` (download), `STOR` (upload), `TYPE`, `PORT`, `PASV`, `QUIT`, `MKD`, `RMD`, `DELE`, `RNFR`/`RNTO`.

## Luồng cơ bản (download file, passive)

1. TCP connect đến server:21
2. Thực hiện `USER`/`PASS`
3. `PASV` → server trả IP:port data
4. Client mở TCP connect tới IP:port data
5. `RETR filename` trên control connection → server gửi file qua data connection → đóng data connection

## Kiểm tra / lệnh

* `ftp server` (client truyền thống), `lftp`, `curl ftp://...`, `openssl s_client` (FTPS).

---

# 3. MAIL (SMTP, POP3, IMAP)

Hệ thống email thường chia hai phần chính: **SMTP** để gửi/relay mail; **POP3/IMAP** để nhận mail từ server về client.

---

## 3.1 SMTP (Simple Mail Transfer Protocol)

### Mục đích

Gửi thư điện tử giữa Mail User Agent (MUA) → Mail Transfer Agent (MTA), và giữa MTA với nhau (relay).

### Cổng & mode

* **Port 25**: SMTP truyền thống (MTA ↔ MTA) — không mã hóa mặc định.
* **Port 587**: Submission (MUA → MTA) thường yêu cầu AUTH, có STARTTLS.
* **Port 465**: SMTPS (implicit TLS historically) — đôi khi dùng.

### Luồng cơ bản

1. TCP connect server:25
2. Server gửi `220` greeting
3. Client: `EHLO client.example.com` (hoặc `HELO`)
4. If TLS desired: `STARTTLS` → TLS handshake
5. `AUTH LOGIN` / `AUTH PLAIN` (nếu cần)
6. `MAIL FROM:<sender>`
7. `RCPT TO:<recipient>` (có thể nhiều)
8. `DATA` → client gửi headers + body, kết thúc bằng CRLF.CRLF
9. `QUIT`

### Envelope vs Header

* **Envelope (SMTP commands MAIL/RCPT)** chứa địa chỉ giao vận (return path, recipients) — có thể khác với `From:` header trong thân mail.

### Bảo mật & vấn đề

* **Spam**: cần kiểm soát (RBL, spam filters).
* **Authentication/Encryption**: STARTTLS / SMTPS để bảo mật; AUTH + submission auth trên 587 cho MUA.
* **SPF / DKIM / DMARC**: cơ chế chống giả mạo, xác thực nguồn mail.

---

## 3.2 POP3 (Post Office Protocol v3)

### Mục đích

Tải mail từ server về client (thường tải về và xóa trên server).

### Port & kiểu

* TCP **110** (clear)
* TCP **995** (POP3S, implicit TLS)

### Flow

1. Connect → server `+OK` greeting
2. `USER username` → `PASS password` (or AUTH methods)
3. `STAT` (số thư & size) / `LIST` (liệt kê)
4. `RETR n` → tải message n
5. `DELE n` → đánh dấu xóa (thực thi khi QUIT)
6. `QUIT`

### Đặc điểm

* **Simple model**: mailbox server giữ mail; client kéo về và thường xóa.
* **Không hỗ trợ nhiều folders, server-side state** (trừ các tùy chọn extension).

---

## 3.3 IMAP (Internet Message Access Protocol)

### Mục đích

Truy cập và quản lý mailbox trực tiếp trên server — mail giữ nguyên trên máy chủ, hỗ trợ folders, flags, đồng bộ nhiều client.

### Port & kiểu

* TCP **143** (IMAP, STARTTLS possible)
* TCP **993** (IMAPS, implicit TLS)

### Flow cơ bản

1. Connect → `* OK` greeting
2. `a001 LOGIN user pass` hoặc `a001 AUTHENTICATE`
3. `a002 SELECT INBOX` → server trả trạng thái (message count, recent, flags)
4. `a003 FETCH 1:* (FLAGS BODY[HEADER])` để lấy headers/bodies
5. `a004 STORE 2 +FLAGS (\Deleted)` để đánh dấu, `EXPUNGE` để xóa thực sự.
6. `LOGOUT`

### Đặc điểm

* IMAP là **stateful & feature-rich**: hỗ trợ many folders, UID, sequence numbers, partial fetch (BODY.PEEK), IDLE (push notifications).
* Thích hợp đồng bộ nhiều thiết bị.

### Bảo mật & vấn đề

* TLS (STARTTLS / implicit) để mã hóa.
* OAuth2 thường được dùng cho authentication hiện đại thay password plain.

---

# 4. HTTP / HTTPS

## Mục đích

Giao thức cho web — truyền siêu văn bản (HTML), tài nguyên (JS/CSS/images), API (JSON), REST, v.v.

## Cổng & kiểu

* **HTTP:** TCP **80** (clear text) — stateless, request/response.
* **HTTPS:** TCP **443** (HTTP over TLS), thiết lập TLS trước khi HTTP exchange.

## Phương thức (methods) HTTP phổ biến

* `GET`, `HEAD`, `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`, `CONNECT` (for proxies).

## Cấu trúc request / response

* **Request line:** `METHOD /path HTTP/1.1`
* **Headers:** `Host`, `User-Agent`, `Accept`, `Content-Type`, `Content-Length`, `Authorization`, `Cookie`, v.v.
* **Body:** optional (POST/PUT)
* **Response:** `HTTP/1.1 200 OK` + headers (`Content-Type`, `Content-Length`, `Set-Cookie`, `Cache-Control`) + body.

## Connection & state

* HTTP/1.0: mỗi request mở 1 TCP connection (Connection: close).
* HTTP/1.1: persistent connections mặc định (Connection: keep-alive), pipelining (ít dùng)
* HTTP/2: binary framing, multiplexing nhiều streams trên 1 TCP connection, header compression (HPACK).
* HTTP/3: chạy trên QUIC (UDP) — kết nối + multiplexing trên UDP.

## Cache, cookies, session

* **Cache control**: `Cache-Control`, `Expires`, `ETag`, `Last-Modified` để caching.
* **Cookie**: server set cookie, client gửi cookie để duy trì session.
* **Session**: stateful behavior built on top of HTTP (token, session id).

## TLS (HTTPS)

* TLS cung cấp: confidentiality, integrity, server authentication (certificate chain).
* TLS handshake: ClientHello -> ServerHello, Certificate, (ServerKeyExchange) -> ClientKeyExchange -> Finished; sau đó bắn dữ liệu HTTP qua channel mã hóa.
* TLS versions: TLS1.2, TLS1.3 phổ biến hiện nay.

## Bảo mật & vấn đề

* HTTPS bắt buộc cho bảo mật dữ liệu; HSTS để buộc HTTPS; CSRF/XSS/SQLi là ứng dụng layer threats; bảo mật headers: `Strict-Transport-Security`, `X-Frame-Options`, `Content-Security-Policy`.

## Kiểm tra / lệnh

* `curl -v https://example.com`
* `openssl s_client -connect example.com:443` (kiểm tra cert)
* `httping`, `ab`, `wrk`, `httperf` (benchmark)

---

# 5. Telnet

## Mục đích

Giao thức terminal remote, cho phép đăng nhập shell qua TCP.

## Cổng & kiểu

* TCP **23** (clear text), connection-oriented, interactive.

## Đặc điểm

* Truyền mọi ký tự bàn phím và hiển thị từ server; không mã hóa → username/password gửi plain text → RẤT KHÔNG AN TOÀN trên mạng công cộng.

## Sử dụng

* Hiện nay Telnet chủ yếu dùng cho test (mở socket TCP raw) hoặc quản lý thiết bị cũ; KHÔNG dùng để remote shell production.

## Kiểm tra / lệnh

* `telnet example.com 23` để connect; sau đó gõ lệnh thủ công.
* Dùng `nc` (netcat) thay thế trong test.

---

# 6. SSH (Secure Shell)

## Mục đích

Remote shell an toàn, secure file transfer (SFTP), port forwarding, tunneling, secure command execution.

## Cổng & kiểu

* TCP **22** (mặc định), connection-oriented, bảo mật.

## Mô tả & luồng

1. **Transport layer**: thiết lập kênh mã hóa (key exchange, server authentication bằng certificate/public key), negotiate algorithms (KEX, cipher, MAC).
2. **User authentication**: password hoặc public key (`ssh-rsa`, `ssh-ed25519`) hoặc keyboard-interactive, GSSAPI, 2FA.
3. **Connection layer / channels**: multiplex các kênh (shell, exec, subsystems như sftp, forwarded ports) trên 1 kết nối SSH.

## Key exchange & host key

* KEX (Diffie-Hellman / ECDH / Curve25519) để tạo shared secret, sau đó derive symmetric keys.
* Server có **host key** (RSA/ECDSA/Ed25519) để client xác thực server; client lưu `known_hosts` để phát hiện MITM.

## Public key auth

* Client giữ private key; public key đặt trong `~/.ssh/authorized_keys` trên server.
* Khi auth publickey: server gửi challenge, client trả lời bằng digital signature.

## Tunneling / Port forwarding

* **Local port forwarding:** `ssh -L local:localport:remote:remoteport user@bastion` (client mở local port → tunnel → remote)
* **Remote port forwarding:** `ssh -R` (server mở port → forward về client)
* **Dynamic (SOCKS) proxy:** `ssh -D` tạo SOCKS proxy.

## SFTP & SCP

* **SCP**: copy file via SSH (older, less flexible).
* **SFTP**: subsystem trong SSH, file transfer with more control.

## Security & best practices

* Disable root login (`PermitRootLogin no`)
* Use key-based authentication, disable password auth where possible (`PasswordAuthentication no`)
* Use strong host key algorithms (ed25519), up-to-date ciphers, limit users, fail2ban, rate limiting.
* Use `ssh-agent` to handle keys, and `authorized_keys` options (from="...", no-pty) to restrict.

## Kiểm tra / lệnh

* `ssh -v user@host` (debug)
* `ssh-keygen -t ed25519` (create key)
* `ssh-copy-id user@host` (deploy public key)
* `sftp user@host`, `scp file user@host:/path`

---

# So sánh tóm tắt (một dòng mỗi giao thức)

* **DNS:** name ↔ IP, UDP/TCP 53, phân tán & caching, cần DNSSEC/DoT/DoH để bảo mật.
* **FTP:** truyền file, control:21, data:20/ephemeral, plain → dùng FTPS/SFTP thay thế.
* **SMTP:** gửi/relay mail (port 25), submission 587; kết hợp SPF/DKIM/DMARC để chống giả mạo.
* **POP3/IMAP:** nhận mail — POP3 (110/995) tải về; IMAP (143/993) giữ trên server, multi-device sync.
* **HTTP/HTTPS:** web; HTTP stateless request/response; HTTPS = HTTP + TLS (443).
* **Telnet:** remote shell plain text (23), KHÔNG AN TOÀN; dùng chỉ để test.
* **SSH:** remote secure shell (22), key auth, tunneling, SFTP; tiêu chuẩn cho remote management.

---

## 4. Client - Server Model

* **Định nghĩa:** kiến trúc giao tiếp giữa client (gửi yêu cầu) và server (trả lời).
* **Ví dụ:** Trình duyệt (client) truy cập web server (server).

---

## 5. Connection-oriented và Connectionless

* **Connection-oriented:** có thiết lập kết nối trước khi truyền (TCP).
* **Connectionless:** không cần thiết lập, gửi ngay (UDP).

---

## 6. TCP và UDP

* **TCP (Transmission Control Protocol):** reliable (có ACK, kiểm tra lỗi, sắp xếp), connection-oriented, chậm hơn.
  Ví dụ: HTTP, FTP, SMTP.

* **UDP (User Datagram Protocol):** không đảm bảo, connectionless, nhanh hơn.
  Ví dụ: DNS, VoIP, video streaming.

---

#  BASIC SWITCHING

## 1. Ethernet trong OSI

* **Ở lớp Physical:** định nghĩa chuẩn cáp (UTP, fiber), tốc độ (10Mbps, 100Mbps, 1Gbps…).
* **Ở lớp Data Link:** định nghĩa MAC address, framing, error detection (CRC).

---

## 2. Encapsulation Ethernet Frame

* **Ethernet Frame:** đơn vị dữ liệu ở tầng Data Link.
* **Kích thước:** 64 – 1518 bytes (không kể preamble, IFG).

**Trường trong frame:**

* **Preamble (7B) + SFD (1B):** đồng bộ.
* **Destination MAC (6B)**
* **Source MAC (6B)**
* **EtherType/Length (2B):** xác định loại payload (IPv4, ARP…).
* **Payload (46–1500B)**
* **FCS (4B):** checksum kiểm tra lỗi.

---

## 3. CSMA/CD

* **Carrier Sense Multiple Access with Collision Detection**
* Cơ chế truy cập đường truyền: thiết bị "nghe" trước khi gửi, nếu collision thì dừng và random thời gian gửi lại.
* Dùng trong Ethernet truyền thống (hub, half-duplex).
* **Hiện nay switch + full duplex nên hầu như không còn collision.**

---

## 4. Collision Domain vs Broadcast Domain

* **Collision domain:** phạm vi mà gói tin có thể va chạm. Mỗi port switch là 1 collision domain.
* **Broadcast domain:** phạm vi mà gói broadcast (FF:FF:FF:FF:FF:FF) lan tỏa. Một VLAN = một broadcast domain.

---

## 5. Simplex vs Duplex

* **Simplex:** truyền 1 chiều (TV).
* **Half-duplex:** 2 chiều nhưng không đồng thời (walkie-talkie).
* **Full-duplex:** 2 chiều đồng thời (Ethernet hiện đại).

---

## 6. Vai trò của Switch trong LAN

* Kết nối các thiết bị trong LAN.
* Tách collision domain, giảm xung đột.
* Học MAC address để chuyển frame chính xác (không flood toàn mạng).

---

## 7. Nguyên tắc chuyển mạch của Switch

* Switch duy trì **MAC address table**.
* Khi nhận frame:

  * Nếu biết địa chỉ MAC đích → gửi đúng port.
  * Nếu chưa biết → flood ra tất cả port.
  * Nếu địa chỉ broadcast → gửi tất cả.

---

## 8. Spanning Tree Protocol (STP)

* Giải quyết loop trong mạng có nhiều switch.
* Nguyên tắc: chọn **root bridge**, sau đó disable bớt port để tạo topology dạng cây không vòng lặp.
* Chuẩn: IEEE 802.1D.

---

## 9. VLAN (Virtual LAN)

* Chia mạng LAN vật lý thành nhiều mạng logic.
* Mỗi VLAN = 1 broadcast domain.
* Ưu điểm: tăng bảo mật, giảm broadcast, quản lý dễ hơn.

---

## 10. VTP (VLAN Trunking Protocol)

* Cisco protocol dùng để phân phối VLAN giữa các switch.
* Có 3 mode: **Server, Client, Transparent**.
* Lưu ý: có thể gây mất VLAN nếu config sai → ít dùng trong thực tế.

---

## 11. Inter-VLAN Routing

* Máy trong VLAN khác nhau muốn liên lạc cần **router** hoặc **Layer 3 Switch**.
* Có 2 cách:

  1. **Router-on-a-stick**: dùng 1 router với sub-interface gắn IP cho từng VLAN.
  2. **Layer 3 Switch**: switch có khả năng routing.

---
