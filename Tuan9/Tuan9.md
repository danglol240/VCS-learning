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

![ftp](https://github.com/user-attachments/assets/a1b3bc2c-e8f0-4af8-940c-a6d93f5df6e4)

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

![smtp](https://github.com/user-attachments/assets/e3501179-5432-4d40-a176-b16cc744618b)

## Định nghĩa

**Mail (Email)** là ứng dụng cung cấp dịch vụ **gửi, chuyển tiếp, nhận và lưu trữ thư điện tử** giữa các người dùng thông qua mạng máy tính.
Nó hoạt động ở **tầng 7 – Application Layer** trong mô hình **OSI**.

---

## Các giao thức chính trong hệ thống Mail

| Giao thức                                   | Vai trò                                    | Cổng TCP                           | Mô tả                                                                          |
| ------------------------------------------- | ------------------------------------------ | ---------------------------------- | ------------------------------------------------------------------------------ |
| **SMTP** (Simple Mail Transfer Protocol)    | Gửi và chuyển tiếp thư đi giữa các máy chủ | 25 (chuẩn), 465 (SMTPS), 587 (TLS) | Dùng để **gửi mail** từ client lên server hoặc giữa các mail server            |
| **POP3** (Post Office Protocol v3)          | Tải mail từ server về client               | 110 (POP3), 995 (POP3S)            | Dùng để **nhận mail**, thường **tải về máy và có thể xóa bản gốc** trên server |
| **IMAP** (Internet Message Access Protocol) | Quản lý mail trực tiếp trên server         | 143 (IMAP), 993 (IMAPS)            | Cho phép **đọc, đồng bộ và quản lý thư ngay trên server**, giữ nguyên bản gốc  |

---

## Các thành phần trong hệ thống Mail

| Thành phần                      | Tên đầy đủ                                                 | Chức năng chính                                                |
| ------------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------- |
| **MUA** (Mail User Agent)       | Ứng dụng người dùng như Outlook, Thunderbird, Gmail Web... | Viết, gửi, đọc, xóa thư                                        |
| **MSA** (Mail Submission Agent) | Lớp trung gian nhận thư từ MUA                             | Xác thực người gửi, kiểm tra nội dung, chuyển cho MTA          |
| **MTA** (Mail Transfer Agent)   | Mail server trung gian như Sendmail, Postfix, Exim...      | Gửi và chuyển tiếp thư giữa các mail server khác nhau qua SMTP |
| **MDA** (Mail Delivery Agent)   | Trình giao thư nội bộ như Procmail, Dovecot LDA...         | Lưu thư vào đúng hộp thư người nhận                            |
| **Mailbox**                     | Hộp thư của người dùng                                     | Nơi lưu trữ mail đến, được truy cập qua POP3 hoặc IMAP         |

---

## Mô hình hoạt động tổng quát

1. **Người gửi** dùng **MUA** (ví dụ: Outlook, Gmail web) gửi thư.
2. **MSA** trên mail server nhận thư, xác thực và chuyển đến **MTA**.
3. **MTA** dùng giao thức **SMTP** để chuyển thư đến **MTA** của người nhận.
4. **MTA** của người nhận chuyển thư cho **MDA**, lưu vào **Mailbox** của người nhận.
5. **Người nhận** dùng **MUA** để truy cập vào hộp thư qua **POP3** hoặc **IMAP**.

---

## So sánh POP3 và IMAP

| Tiêu chí                   | **POP3**                                   | **IMAP**                                              |
| -------------------------- | ------------------------------------------ | ----------------------------------------------------- |
| **Cách hoạt động**         | Tải mail về máy cục bộ                     | Đọc và quản lý mail trực tiếp trên server             |
| **Lưu trữ trên server**    | Có thể bị xóa sau khi tải (tùy cấu hình)   | Giữ nguyên bản gốc trên server                        |
| **Đồng bộ nhiều thiết bị** | Không đồng bộ (mỗi thiết bị lưu bản riêng) | Đồng bộ thời gian thực giữa các thiết bị              |
| **Phù hợp với**            | Người chỉ dùng 1 thiết bị duy nhất         | Người dùng nhiều thiết bị hoặc muốn quản lý tập trung |

---

# 4. HTTP / HTTPS

## Mục đích

**HTTP (HyperText Transfer Protocol)** là giao thức truyền tải siêu văn bản, dùng để **trao đổi dữ liệu giữa client và server** trên mạng Internet.
HTTP hoạt động ở **tầng 7 (Application Layer)** trong mô hình **OSI**.
Phiên bản bảo mật của HTTP là **HTTPS (HTTP Secure)** — sử dụng mã hóa SSL/TLS để đảm bảo an toàn truyền thông tin.

## Cổng & kiểu

* **HTTP:** TCP **80** (clear text) — stateless, request/response.
* **HTTPS:** TCP **443** (HTTP over TLS), thiết lập TLS trước khi HTTP exchange.

## Phương thức (methods) HTTP phổ biến

* `GET`, `HEAD`, `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`,...

---

## Các thành phần cơ bản trong mô hình HTTP

| Thành phần                   | Mô tả                                                                                                                                                                                    |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Client (HTTP User Agent)** | Ứng dụng gửi yêu cầu HTTP, thường là trình duyệt web (Chrome, Firefox, Edge...) hoặc công cụ dòng lệnh (curl, wget). Gửi các phương thức như `GET`, `POST`, `PUT`, `DELETE`, `HEAD`, ... |
| **Server (HTTP Server)**     | Tiếp nhận và xử lý yêu cầu từ client, phản hồi bằng một thông điệp HTTP Response chứa **mã trạng thái**, **header**, và **nội dung**. Ví dụ: Apache, Nginx, IIS.                         |
| **Resource (Tài nguyên)**    | Đối tượng mà client yêu cầu, được định danh qua **URL**, có thể là trang HTML, ảnh, video, API JSON,...                                                                                  |
| **HTTP Message**             | Gồm hai loại chính: **HTTP Request** (client gửi lên) và **HTTP Response** (server trả về).                                                                                              |

---

## Cách thức hoạt động của HTTP

1. **Thiết lập kết nối TCP**

   * Server mở socket lắng nghe tại **cổng 80 (HTTP)** hoặc **443 (HTTPS)**.
   * Client khởi tạo kết nối TCP đến server.
   * Server chấp nhận kết nối và tạo kênh truyền dữ liệu hai chiều.

2. **Trao đổi thông điệp HTTP**

   * Client gửi **HTTP Request** (ví dụ: `GET /index.html HTTP/1.1`)
   * Server xử lý, sau đó phản hồi **HTTP Response** (ví dụ: `HTTP/1.1 200 OK` + dữ liệu).
   * Trình duyệt hiển thị nội dung lên giao diện người dùng.

3. **Đóng kết nối TCP**

   * Sau khi hoàn tất trao đổi, kết nối có thể được đóng hoặc giữ mở (tuỳ theo phiên bản HTTP).

## Cấu trúc request / response

* **Request line:** `METHOD /path HTTP/1.1`
* **Headers:** `Host`, `User-Agent`, `Accept`, `Content-Type`, `Content-Length`, `Authorization`, `Cookie`, v.v.
* **Body:** optional (POST/PUT)
* **Response:** `HTTP/1.1 200 OK` + headers (`Content-Type`, `Content-Length`, `Set-Cookie`, `Cache-Control`) + body.
---

## Các phiên bản HTTP

| Phiên bản    | Đặc điểm nổi bật                                                                                                                                                                                                         |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **HTTP/1.0** | Mỗi yêu cầu mở một kết nối TCP riêng → tốn thời gian bắt tay → hiệu năng thấp.                                                                                                                                           |
| **HTTP/1.1** | Hỗ trợ **Persistent Connection (Keep-Alive)** – giữ một kết nối cho nhiều request; cho phép **Pipeline** – gửi nhiều yêu cầu liên tiếp. Tuy nhiên vẫn bị **Head-of-Line Blocking** (một request bị kẹt → cả luồng dừng). |
| **HTTP/2.0** | Hỗ trợ **Multiplexing** (nhiều request/response chia sẻ một kết nối TCP mà không chặn nhau), **nén header**, và **truyền dữ liệu dạng nhị phân** → nhanh hơn và ổn định hơn nhiều so với HTTP/1.x.                       |

---

## URL – Uniform Resource Locator

**URL** là địa chỉ xác định **tài nguyên trên Internet**, bao gồm:

```
http(s)://<host>[:port]/<path>?<query>#<fragment>
```

Ví dụ:

```
https://example.com:443/products?id=123#detail
```

| Thành phần    | Ý nghĩa                          |
| ------------- | -------------------------------- |
| `https`       | Giao thức truy cập               |
| `example.com` | Tên miền (hostname)              |
| `:443`        | Cổng (port)                      |
| `/products`   | Đường dẫn tài nguyên             |
| `?id=123`     | Tham số truy vấn                 |
| `#detail`     | Vị trí trong tài liệu (fragment) |

---

## Mã trạng thái HTTP (HTTP Status Code)

| Nhóm    | Ý nghĩa                        | Ví dụ                                                                                |
| ------- | ------------------------------ | ------------------------------------------------------------------------------------ |
| **1xx** | Thông tin (Informational)      | 100 Continue                                                                         |
| **2xx** | Thành công (Success)           | 200 OK, 201 Created                                                                  |
| **3xx** | Chuyển hướng (Redirection)     | 301 Moved Permanently, 302 Found                                                     |
| **4xx** | Lỗi phía client (Client Error) | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 408 Request Timeout |
| **5xx** | Lỗi phía server (Server Error) | 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable                  |

---

## HTTP là giao thức *Stateless* (phi trạng thái)

* Mỗi yêu cầu (request) là **độc lập**, server **không ghi nhớ** trạng thái của client.
* Để duy trì trạng thái (đăng nhập, giỏ hàng, phiên làm việc, ...), cần dùng:

  * **Cookie** → lưu dữ liệu nhỏ trên trình duyệt.
  * **Session** → lưu trạng thái trên server, gắn với ID trong cookie.
  * **Token (JWT, OAuth2)** → dùng cho xác thực và API.

---

## HTTPS – Phiên bản bảo mật của HTTP

### Hạn chế của HTTP:

* Không xác thực được **máy chủ** → dễ bị giả mạo, tấn công phishing.
* Không mã hóa dữ liệu → dễ bị nghe lén, chèn mã độc (Man-in-the-Middle Attack).

### HTTPS khắc phục bằng cách:

* Sử dụng **SSL/TLS** để mã hóa dữ liệu giữa client và server.
* Xác thực server qua **chứng chỉ số (digital certificate)** do CA (Certificate Authority) cấp.
* Dùng **TCP port 443** thay vì 80.

→ Kết quả: dữ liệu được **mã hóa**, **toàn vẹn**, và **xác thực nguồn gốc**.

---

## Kiểm tra / lệnh

* `curl -v https://example.com`
* `openssl s_client -connect example.com:443` (kiểm tra cert)
* `httping`, `ab`, `wrk`, `httperf` (benchmark)

---

Dưới đây là phần viết lại **đầy đủ và chi tiết hơn** về **Telnet** — vẫn giữ phong cách ngắn gọn, dễ hiểu, nhưng trình bày rõ ràng và chuyên nghiệp hơn:

---

# Giao thức Telnet (Telecommunication Network Protocol)

## Định nghĩa

**Telnet** (viết tắt của *Telecommunication Network*) là một **giao thức truy cập từ xa (remote login protocol)** cho phép người dùng điều khiển một máy tính hoặc thiết bị mạng từ xa thông qua **giao diện dòng lệnh (CLI)**.

Telnet hoạt động ở **tầng 7 – Application Layer** trong mô hình **OSI**, nhưng sử dụng **kết nối TCP (port 23)** để truyền dữ liệu.

---

## Thành phần cơ bản

| Thành phần         | Mô tả                                                                                                                                                                                            |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Telnet Client**  | Là chương trình chạy trên máy người dùng (ví dụ: `telnet` trên Linux, PuTTY trên Windows). Client tạo kết nối đến Telnet server qua TCP và cung cấp giao diện dòng lệnh để người dùng nhập lệnh. |
| **Telnet Server**  | Dịch vụ chạy trên máy đích, lắng nghe ở **cổng TCP 23**. Khi có kết nối đến, nó xác thực người dùng và mở một **phiên làm việc shell (CLI)** cho phép điều khiển hệ thống.                       |
| **TCP Connection** | Là kênh truyền song công (full-duplex) giữa client và server. Tất cả các lệnh, phản hồi, và dữ liệu điều khiển đều truyền qua kết nối TCP này.                                                   |

---

## Cách thức hoạt động của Telnet

1. **Thiết lập kết nối TCP**

   * Telnet Client gửi yêu cầu kết nối đến **Telnet Server** qua **port 23 (TCP)**.
   * Server chấp nhận kết nối, mở một phiên giao tiếp Telnet.

2. **Xác thực người dùng**

   * Server yêu cầu nhập **tên đăng nhập (username)** và **mật khẩu (password)**.
   * Quá trình xác thực diễn ra trực tiếp qua kết nối TCP (không mã hóa).

3. **Tạo phiên làm việc (Session)**

   * Sau khi xác thực thành công, server khởi tạo một **CLI session** (thường là shell như `/bin/sh` hoặc `/bin/bash` trên Linux).
   * Người dùng có thể nhập lệnh điều khiển hệ thống từ xa.

4. **Trao đổi dữ liệu**

   * Khi người dùng nhập lệnh trên client, Telnet gửi **chuỗi ký tự ASCII** qua mạng đến server.
   * Server **thực thi lệnh** và gửi kết quả trả về cho client để hiển thị.

5. **Kết thúc phiên**

   * Khi người dùng gõ `exit` hoặc đóng client, kết nối TCP được **ngắt**.
   * Server giải phóng tài nguyên phiên làm việc.

---

## Ví dụ sử dụng Telnet

### Trên Linux:

Cài đặt Telnet client:

```bash
sudo apt install telnet
```

Kết nối đến server Telnet:

```bash
telnet 192.168.1.10
```

Khi kết nối thành công:

```
Trying 192.168.1.10...
Connected to 192.168.1.10.
Escape character is '^]'.
login: admin
Password: *****
Welcome to Ubuntu 22.04 LTS!
$
```

---

## Nhược điểm bảo mật của Telnet

| Vấn đề                             | Mô tả                                                                               |
| ---------------------------------- | ----------------------------------------------------------------------------------- |
| **Không mã hóa dữ liệu**           | Tất cả dữ liệu (kể cả mật khẩu) truyền dạng văn bản thuần (plain text).             |
| **Dễ bị nghe lén (sniffing)**      | Hacker có thể thu lại gói tin Telnet qua Wireshark và đọc thông tin đăng nhập.      |
| **Không xác thực máy chủ**         | Client không có cách nào kiểm tra xem server có phải thật sự là máy đích hay không. |
| **Không đảm bảo toàn vẹn dữ liệu** | Gói tin có thể bị chỉnh sửa giữa đường mà client không biết.                        |

→ Chính vì vậy, **Telnet không còn được sử dụng trong môi trường thực tế**, đặc biệt là mạng Internet.

---

## Giải pháp thay thế — SSH (Secure Shell)

**SSH (Secure Shell)** là **phiên bản bảo mật thay thế Telnet**, có các ưu điểm:

| Tiêu chí                  | **Telnet** | **SSH**                                     |
| ------------------------- | ---------- | ------------------------------------------- |
| **Port mặc định**         | 23         | 22                                          |
| **Mã hóa dữ liệu**        | ❌ Không    | ✅ Có (AES, RSA, ECC...)                     |
| **Xác thực máy chủ**      | ❌ Không có | ✅ Có chứng chỉ / khóa công khai             |
| **Tính toàn vẹn dữ liệu** | ❌ Không    | ✅ Đảm bảo bằng thuật toán hash (HMAC)       |
| **An toàn**               | Thấp       | Rất cao                                     |
| **Ứng dụng hiện nay**     | Hầu như bỏ | Sử dụng phổ biến để quản trị hệ thống từ xa |

Ví dụ dùng SSH:

```bash
ssh user@192.168.1.10
```

---

## Kiểm tra / lệnh

* `ssh -v user@host` (debug)
* `ssh-keygen -t ed25519` (create key)
* `ssh-copy-id user@host` (deploy public key)
* `sftp user@host`, `scp file user@host:/path`

---

## 4. Client - Server Model

### Tổng quan

Kiến trúc **Client–Server** là mô hình phổ biến nhất trong mạng Internet hiện nay, được sử dụng trong hầu hết các ứng dụng như web, email, FTP, cơ sở dữ liệu, v.v.
Trong mô hình này, **Client** (máy trạm/người dùng) gửi yêu cầu dịch vụ, còn **Server** (máy chủ) tiếp nhận, xử lý và phản hồi kết quả.

---

### Đặc điểm

* Hệ thống chia thành hai thành phần chính:

  * **Client:** Giao diện người dùng, gửi yêu cầu dịch vụ (request).
  * **Server:** Xử lý yêu cầu và cung cấp tài nguyên hoặc dữ liệu (response).
* Giao tiếp giữa client và server thường sử dụng các giao thức mạng tiêu chuẩn như **HTTP, FTP, SMTP, DNS,…**

---

### Ưu điểm

* **Quản lý tập trung:** Tài nguyên, dữ liệu, và cấu hình được quản lý từ máy chủ, giúp dễ dàng kiểm soát.
* **Dễ mở rộng:** Có thể thêm hoặc nâng cấp server để đáp ứng nhiều client hơn.
* **Bảo mật và cập nhật thuận tiện:** Các chính sách bảo mật, cập nhật phần mềm chỉ cần thực hiện trên server, giảm rủi ro và tiết kiệm thời gian.

---

### Nhược điểm

* **Điểm đơn lỗi (Single Point of Failure):** Nếu server gặp sự cố, toàn bộ hệ thống ngừng hoạt động.
* **Giới hạn tải (Load Issue):** Khi có quá nhiều client truy cập cùng lúc, server có thể bị quá tải, làm giảm hiệu năng.
* **Cấu hình phức tạp:** Việc thiết lập mạng, bảo mật, phân quyền, và quản lý dịch vụ yêu cầu kỹ thuật cao hơn so với mô hình ngang hàng (peer-to-peer).

---

## 5. Connection-oriented và Connectionless

- Truyền thông hướng liên kết (Connection-oriented):
  + Dữ liệu được truyền qua một kết nối đã được thiết lập. Gồm 3 giai đoạn: thiết lập
  liên kết, truyền dữ liệu, hủy liên kết.
  + Đáng tin cậy
  + Truyền chậm hơn khi so với truyền thông hướng không liên kết.
  + Giao thức thường sử dụng TCP
- Truyền thông hướng không liên kết (Connectionless):
  + Không thiết lập liên kết chỉ có giai đoạn truyền dữ liệu
  + Không tin cậy
  + Best Effort: truyền với khả năng tối đa
  + Giao thức thường sử dụng UDP

---

## 6. TCP và UDP

**TCP:**

```
Client → [ SYN ] → Server  
Client ← [ SYN + ACK ] ← Server  
Client → [ ACK ] → Server  
=> Kết nối được thiết lập, sau đó mới truyền dữ liệu.
```

**UDP:**

```
Client → [ Dữ liệu ] → Server  
=> Không cần bắt tay, gửi thẳng, nhanh nhưng có thể mất gói.
```

## So sánh giao thức TCP và UDP

| Tiêu chí                        | **TCP (Transmission Control Protocol)**                                                                                        | **UDP (User Datagram Protocol)**                                                   |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------- |
| **Loại giao thức**              | Giao thức **hướng kết nối** (connection-oriented)                                                                              | Giao thức **không hướng kết nối** (connectionless)                                 |
| **Cách thức hoạt động**         | Thiết lập kết nối trước khi truyền dữ liệu (bắt tay 3 bước - *Three-way handshake*) → đảm bảo đường truyền ổn định giữa 2 đầu. | Gửi dữ liệu trực tiếp mà không cần thiết lập kết nối, mỗi gói tin độc lập.         |
| **Độ tin cậy**                  | **Đảm bảo tin cậy**: có cơ chế kiểm tra lỗi, xác nhận gói (ACK), truyền lại nếu mất.                                           | **Không đảm bảo tin cậy**: không kiểm tra, không xác nhận, nếu mất gói thì bỏ qua. |
| **Trình tự dữ liệu (ordering)** | Dữ liệu đến **đúng thứ tự** nhờ có đánh số gói (sequence number).                                                              | Gói tin có thể **đến sai thứ tự**, trùng lặp hoặc bị mất mà không được phát hiện.  |
| **Kiểm soát luồng & tắc nghẽn** | Có cơ chế **flow control** và **congestion control** để điều chỉnh tốc độ truyền.                                              | Không có cơ chế điều chỉnh tốc độ – gửi càng nhanh càng tốt.                       |
| **Tốc độ truyền**               | Chậm hơn do overhead kiểm soát lớn.                                                                                            | Nhanh hơn, do ít overhead, không cần xác nhận hay thiết lập phiên.                 |
| **Cấu trúc gói tin (header)**   | Header phức tạp hơn (~20 bytes), gồm nhiều trường như Seq, Ack, Window,...                                                     | Header đơn giản (~8 bytes), chỉ có Port, Length, Checksum.                         |
| **Truyền dạng**                 | Dòng byte (byte stream) liên tục.                                                                                              | Gói tin (datagram) rời rạc, độc lập.                                               |

* HTTP/HTTPS (Web)
* SMTP, IMAP, POP3 (Mail)
* FTP, SSH
* Database, File transfer | Các ứng dụng yêu cầu **tốc độ cao, chấp nhận mất mát**:
* DNS query
* Video streaming, VoIP
* Gaming online
* NTP, DHCP |
  | **Giao thức tầng dưới sử dụng** | Dựa trên IP (Internet Protocol). | Dựa trên IP (Internet Protocol). |
  | **Cổng mặc định phổ biến** | HTTP: 80, HTTPS: 443, FTP: 21, SSH: 22 | DNS: 53, DHCP: 67/68, SNMP: 161, NTP: 123 |

---
#  BASIC SWITCHING

## 1. **Ethernet trong mô hình OSI**

### **1.1. Định nghĩa**

**Ethernet** là công nghệ mạng cục bộ (LAN) phổ biến nhất hiện nay, được định nghĩa trong tiêu chuẩn **IEEE 802.3**.
Ethernet quy định cách dữ liệu được **đóng gói, truyền và nhận** qua các loại cáp (đồng hoặc quang) và **cách các thiết bị giao tiếp ở tầng thấp** của mô hình OSI.

### **1.2. Vị trí trong mô hình OSI**

Ethernet hoạt động ở **hai tầng thấp nhất** của mô hình OSI:

| Tầng                         | Tên tầng              | Chức năng của Ethernet tại tầng đó                                                                                                                 |
| ---------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tầng 1 (Physical Layer)**  | Tầng vật lý           | Chuyển đổi bit nhị phân (0/1) thành tín hiệu điện, quang hoặc sóng để truyền đi. Quy định loại cáp, đầu nối, tốc độ (10/100/1000 Mbps, 10 Gbps...) |
| **Tầng 2 (Data Link Layer)** | Tầng liên kết dữ liệu | Đóng gói dữ liệu thành frame, định danh thiết bị qua địa chỉ MAC, kiểm soát lỗi, kiểm soát truy cập đường truyền.                                  |

### **1.3. Thành phần tầng 2**

Tầng Data Link trong Ethernet chia thành 2 phần:

* **LLC (Logical Link Control – IEEE 802.2):**
  Giao tiếp với tầng 3, xác định giao thức tầng trên (IP, ARP, IPX...).
* **MAC (Media Access Control – IEEE 802.3):**
  Giao tiếp với tầng vật lý, gán địa chỉ MAC, kiểm soát quyền truy cập đường truyền.

---

## 2. **Encapsulation – Ethernet Frame**

### **2.1. Ethernet Frame là gì**

**Ethernet Frame** là đơn vị dữ liệu cơ bản tại tầng 2, được tạo ra khi dữ liệu từ tầng mạng (IP Packet) được **đóng gói thêm header và trailer** để truyền trên mạng LAN.

### **2.2. Cấu trúc Ethernet Frame**

| Trường                          | Kích thước    | Ý nghĩa                                                               |
| ------------------------------- | ------------- | --------------------------------------------------------------------- |
| **Preamble**                    | 7 bytes       | Dãy đồng bộ (10101010) giúp đồng bộ tín hiệu giữa các thiết bị.       |
| **Start Frame Delimiter (SFD)** | 1 byte        | Xác định điểm bắt đầu frame (10101011).                               |
| **Destination MAC Address**     | 6 bytes       | Địa chỉ MAC đích (thiết bị nhận).                                     |
| **Source MAC Address**          | 6 bytes       | Địa chỉ MAC nguồn (thiết bị gửi).                                     |
| **Type/Length**                 | 2 bytes       | Cho biết loại giao thức tầng 3 (ví dụ: 0x0800 = IPv4, 0x86DD = IPv6). |
| **Data (Payload)**              | 46–1500 bytes | Dữ liệu được đóng gói (gói IP).                                       |
| **Frame Check Sequence (FCS)**  | 4 bytes       | Kiểm tra lỗi CRC để phát hiện lỗi trong quá trình truyền.             |

➡️ **Tổng kích thước frame:**
Tối thiểu **64 bytes**, tối đa **1518 bytes** (bao gồm header + trailer, chưa tính preamble/SFD).
Nếu nhỏ hơn 64 byte → bị coi là **runt frame (frame lỗi)**.

---

## 3. **CSMA/CD (Carrier Sense Multiple Access with Collision Detection)**

Là **cơ chế truy cập đường truyền** trong mạng Ethernet truyền thống (dạng bus hoặc hub) để tránh va chạm.

### **Cơ chế hoạt động:**

1. **Carrier Sense:** Thiết bị “lắng nghe” xem đường truyền đang rảnh hay có ai gửi.
2. **Multiple Access:** Nhiều thiết bị có thể cùng truy cập vào môi trường mạng.
3. **Collision Detection:** Nếu hai thiết bị truyền cùng lúc → va chạm → gửi tín hiệu “jam” thông báo lỗi.
4. **Backoff:** Mỗi thiết bị chờ ngẫu nhiên một khoảng thời gian rồi thử gửi lại.

---

## 4. **Collision Domain vs Broadcast Domain**

| Khái niệm            | Định nghĩa                                                        | Bị chia tách bởi  | Mô tả                                               |
| -------------------- | ----------------------------------------------------------------- | ----------------- | --------------------------------------------------- |
| **Collision Domain** | Phạm vi mà tại đó hai thiết bị có thể truyền cùng lúc gây va chạm | **Switch**        | Mỗi cổng switch là một collision domain riêng.      |
| **Broadcast Domain** | Phạm vi mà gói tin broadcast được phát tới tất cả thiết bị        | **Router / VLAN** | Một mạng LAN hoặc một VLAN là một broadcast domain. |

➡️ **Switch giảm collision domain nhưng không chia nhỏ broadcast domain**, trừ khi có cấu hình VLAN.

---

## 5. **Simplex vs Duplex**

| Chế độ          | Mô tả                                              | Ví dụ                |
| --------------- | -------------------------------------------------- | -------------------- |
| **Simplex**     | Truyền một chiều, thiết bị nhận không gửi lại được | Màn hình hiển thị    |
| **Half-duplex** | Hai chiều nhưng **không đồng thời**                | Bộ đàm, Hub          |
| **Full-duplex** | Hai chiều **đồng thời**, loại bỏ va chạm           | Switch, NIC hiện đại |

---

## 6. **Vai trò của Switch trong mạng LAN**

Switch là **thiết bị tầng 2** thực hiện chức năng **chuyển mạch (switching)** frame Ethernet trong mạng LAN.

### **Vai trò chính:**

* Kết nối nhiều thiết bị trong cùng LAN.
* Dựa vào **địa chỉ MAC** để gửi dữ liệu chính xác.
* Mỗi cổng là một **collision domain** riêng → tăng hiệu năng.
* Hỗ trợ **full-duplex** → truyền song công.
* Có thể chia **VLAN** để cách ly lưu lượng, tăng bảo mật.
* Tích hợp nhiều tính năng như **QoS, Spanning Tree, VLAN, port security...**

---

## 7. **Nguyên tắc chuyển mạch của Switch**

### **Các bước hoạt động:**

1. **Learning (Học MAC):**
   Khi nhận frame, switch đọc địa chỉ MAC nguồn và lưu vào **MAC Table** cùng với cổng tương ứng.
2. **Forwarding (Chuyển tiếp):**

   * Nếu MAC đích có trong bảng → gửi đúng cổng.
   * Nếu không có → broadcast frame ra tất cả các cổng (trừ cổng nhận).
3. **Aging (Làm mới):**
   Mỗi bản ghi MAC có thời gian sống (mặc định 300s). Hết hạn → xóa để cập nhật lại.

---

## 8. **Spanning Tree Protocol (STP)**

### **Mục đích:**

Ngăn **vòng lặp tầng 2** trong mạng có nhiều đường dự phòng (redundant links), gây **broadcast storm** hoặc **looping**.

### **Cách hoạt động:**

1. **Bầu chọn Root Bridge** – switch có Bridge ID nhỏ nhất (priority + MAC).
2. **Tính toán đường ngắn nhất đến Root Bridge (Root Path Cost).**
3. **Chọn Root Port (cổng về root)** và **Designated Port (cổng được phép chuyển tiếp)**.
4. **Các cổng dư thừa sẽ bị Blocked** để loại bỏ vòng lặp.

### **Trạng thái port trong STP:**

* **Blocking → Listening → Learning → Forwarding**

### **Thông số thời gian:**

* Hello Time: 2s
* Max Age: 20s
* Forward Delay: 15s

### **Các phiên bản STP:**

| Giao thức              | Đặc điểm                         |
| ---------------------- | -------------------------------- |
| **STP (802.1D)**       | Gốc, chậm (30-50s hội tụ).       |
| **RSTP (802.1w)**      | Nhanh hơn, hội tụ vài giây.      |
| **MSTP (802.1s)**      | Gộp nhiều VLAN cùng một cây STP. |
| **PVST/PVST+ (Cisco)** | Một STP riêng cho từng VLAN.     |

---

## 9. **VLAN (Virtual LAN)**

### **Định nghĩa:**

**VLAN** là mạng LAN ảo, chia tách mạng vật lý thành nhiều miền logic độc lập.
Các thiết bị cùng VLAN giao tiếp như trong cùng LAN, dù ở cổng khác nhau.

### **Lợi ích:**

* Tăng bảo mật (cách ly các nhóm người dùng).
* Giảm broadcast domain.
* Quản lý mạng linh hoạt.
* Tối ưu hiệu năng.

### **Các loại cổng:**

| Loại cổng       | Mô tả                           | Ứng dụng                             |
| --------------- | ------------------------------- | ------------------------------------ |
| **Access Port** | Thuộc 1 VLAN duy nhất           | PC, server                           |
| **Trunk Port**  | Mang nhiều VLAN, gắn thẻ 802.1Q | Switch ↔ Switch hoặc Switch ↔ Router |

### **Tagging VLAN (802.1Q):**

Gắn thêm 4 byte tag vào frame để xác định VLAN ID (0–4095).

---

## 10. **VTP (VLAN Trunking Protocol)**

### **Định nghĩa:**

Giao thức riêng của Cisco dùng để **đồng bộ và quản lý VLAN** giữa các switch trong cùng domain.

### **Chế độ hoạt động:**

| Chế độ          | Chức năng                                               |
| --------------- | ------------------------------------------------------- |
| **Server**      | Tạo, xóa, chỉnh VLAN; phát thông tin cho switch khác.   |
| **Client**      | Nhận thông tin VLAN từ server, không tự tạo VLAN.       |
| **Transparent** | Không tham gia đồng bộ, chỉ truyền tiếp thông tin VLAN. |

-> VTP giúp **giảm công cấu hình VLAN lặp lại** giữa nhiều switch.

---

## 11. **Inter-VLAN Routing**

### **Mục đích:**

Các VLAN riêng biệt **không thể giao tiếp với nhau** nếu không có thiết bị tầng 3.
→ **Inter-VLAN Routing** cho phép VLAN A ↔ VLAN B thông qua **router hoặc switch layer 3**.

### **Phương pháp:**

#### **1️⃣ Router-on-a-stick**

* Một router dùng **một interface vật lý**, chia thành nhiều **sub-interface**, mỗi sub tương ứng với 1 VLAN.
* Mỗi sub-interface có IP trong VLAN tương ứng.
  → Giao tiếp giữa các VLAN thông qua router.

#### **2️⃣ Layer 3 Switch (SVI)**

* Tạo **Switch Virtual Interface (SVI)** – mỗi VLAN có 1 SVI (interface VLAN x).
* Switch định tuyến nội bộ giữa các VLAN mà không cần router vật lý.
  → Nhanh, hiệu quả, phổ biến hiện nay.

---
