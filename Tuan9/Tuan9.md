# 🌐 BASIC NETWORKING

## 1. TCP/IP và OSI

* **OSI model** (Open Systems Interconnection): 7 tầng

  1. Physical
  2. Data Link
  3. Network
  4. Transport
  5. Session
  6. Presentation
  7. Application

* **TCP/IP model**: 5 tầng

  1. Physical
  2. Link
  3. Internet (Network trong OSI)
  4. Transport (Transport trong OSI)
  5. Application (Session + Presentation + Application trong OSI)

👉 **Giống nhau:** đều phân tầng để truyền dữ liệu, có Transport & Application.
👉 **Khác nhau:** OSI 7 tầng lý thuyết, TCP/IP 4 tầng thực tế (ứng dụng trong Internet).

---

## 2. Encapsulation

* **Định nghĩa:** quá trình đóng gói dữ liệu khi đi xuống các tầng mạng.
* **Mục đích:** thêm header/trailer để dữ liệu có thể được truyền chính xác (ví dụ: TCP header thêm port, IP header thêm địa chỉ IP, Ethernet frame thêm MAC).

---

## 3. Application Layer Service and Protocol

Một số giao thức lớp ứng dụng:

* **DNS (Domain Name System):** chuyển đổi tên miền ↔ IP.
* **FTP (File Transfer Protocol):** truyền file, dùng TCP port 20/21.
* **MAIL:** gồm SMTP (gửi mail), POP3/IMAP (nhận mail).
* **HTTP/HTTPS:** truyền dữ liệu web. HTTPS = HTTP + TLS.
* **Telnet:** remote CLI (port 23, không mã hóa, không an toàn).
* **SSH:** remote CLI bảo mật (port 22, có mã hóa).

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

# 🔀 BASIC SWITCHING

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
