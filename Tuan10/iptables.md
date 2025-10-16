# Iptables – Linux Firewall

## 1. Khái niệm

**iptables** là công cụ quản lý tường lửa (firewall) mặc định trong nhân Linux (kernel).
Nó cho phép kiểm soát các gói tin (packet) **đi vào, đi ra, hoặc đi qua máy chủ**, dựa trên nhiều tiêu chí như:

* Địa chỉ IP nguồn / đích
* Cổng (port)
* Giao thức (TCP, UDP, ICMP,...)
* Giao diện mạng (interface)
* Trạng thái kết nối (connection state)

iptables hoạt động ở tầng **Network Layer (L3)** và **Transport Layer (L4)** trong mô hình OSI.

---

## 2. Cấu trúc hoạt động của iptables

iptables tổ chức theo **4 bảng chính (tables)**, **5 chuỗi mặc định (chains)**, và **tập hợp các luật (rules)**.

### 2.1. Bảng (Tables)

| Bảng       | Mục đích                                      | Ví dụ sử dụng                                 |
| ---------- | --------------------------------------------- | --------------------------------------------- |
| **filter** | Lọc gói tin (cho phép/chặn)                   | `ACCEPT`, `DROP`, `REJECT`                    |
| **nat**    | Thực hiện chuyển địa chỉ (NAT, SNAT, DNAT)    | Chuyển hướng cổng, truy cập Internet          |
| **mangle** | Thay đổi trường trong header (TTL, TOS, mark) | QoS, routing đặc biệt                         |
| **raw**    | Xử lý đặc biệt trước khi conntrack            | Bỏ qua theo dõi kết nối (connection tracking) |

---

### 2.2. Chuỗi (Chains)

| Chuỗi           | Giai đoạn xử lý                       | Ý nghĩa                         |
| --------------- | ------------------------------------- | ------------------------------- |
| **INPUT**       | Gói tin đi **vào chính máy này**      | SSH, HTTP đến server            |
| **OUTPUT**      | Gói tin **từ máy này gửi ra ngoài**   | Ping, curl, apt update          |
| **FORWARD**     | Gói tin **đi qua máy** (router mode)  | Khi máy làm gateway             |
| **PREROUTING**  | Trước khi kernel định tuyến (routing) | Thường dùng cho DNAT            |
| **POSTROUTING** | Sau khi kernel định tuyến             | Thường dùng cho SNAT/MASQUERADE |

---

### 2.3. Rule (Luật)

Mỗi chain chứa nhiều **rule**.
Mỗi rule gồm:

1. Điều kiện (match condition): xác định gói nào phù hợp.
2. Hành động (target): quyết định xử lý gói tin (ACCEPT, DROP, LOG, DNAT,...).

---

## 3. Cách hoạt động của iptables

Luồng xử lý cơ bản của một gói tin:

```
       [PREROUTING] --> [Routing Decision] --> [INPUT] --> Local Process
                            |                      |
                            +--> [FORWARD] --> [POSTROUTING]
```

---
# 2.4 Các target (mục tiêu) phổ biến của `-j`

Dưới đây là **tất cả các target chuẩn trong iptables**, chia theo loại chức năng:

--- 

## Nhóm 1: Hành động quyết định (terminating targets)

Khi một gói tin khớp và gặp target này → **dừng xử lý chain**.

| Target                  | Ý nghĩa                                                  | Ghi chú                                         |
| ----------------------- | -------------------------------------------------------- | ----------------------------------------------- |
| **ACCEPT**              | Cho phép gói tin đi qua                                  | Dừng kiểm tra rule kế tiếp                      |
| **DROP**                | Hủy gói tin (không phản hồi)                             | Dùng để chặn hoàn toàn                          |
| **REJECT**              | Từ chối gói và gửi phản hồi ICMP hoặc TCP RST            | Phù hợp khi cần phản hồi client                 |
| **RETURN**              | Thoát khỏi chain hiện tại và quay lại chain gọi nó       | Chỉ dùng khi chain được gọi bằng `-j` hoặc `-g` |
| **QUEUE**               | Gửi gói tin đến hàng đợi user-space (libnetfilter_queue) | Dùng cho IDS/IPS hoặc xử lý tùy chỉnh           |
| **CONTINUE** *(ít gặp)* | Tiếp tục chain dù match rule (Netfilter patch cũ)        | Không còn phổ biến                              |

---

## Nhóm 2: Hành động ghi log

| Target    | Ý nghĩa                                                                 | Tùy chọn bổ sung                  |
| --------- | ----------------------------------------------------------------------- | --------------------------------- |
| **LOG**   | Ghi log gói tin vào syslog (`/var/log/syslog` hoặc `/var/log/kern.log`) | `--log-prefix`, `--log-level`     |
| **ULOG**  | Gửi log đến user-space (ulogd)                                          | Cũ, thay thế bởi NFLOG            |
| **NFLOG** | Ghi log hiện đại qua netlink                                            | Dùng trong hệ thống SIEM hoặc IDS |

**Ví dụ:**

```bash
iptables -A INPUT -p tcp --dport 23 -j LOG --log-prefix "Telnet attempt: "
```

---

## Nhóm 3: NAT (Network Address Translation)

| Target         | Ý nghĩa                                            | Dùng trong bảng      |
| -------------- | -------------------------------------------------- | -------------------- |
| **SNAT**       | Thay đổi địa chỉ IP nguồn                          | `nat`, `POSTROUTING` |
| **DNAT**       | Thay đổi địa chỉ IP đích                           | `nat`, `PREROUTING`  |
| **MASQUERADE** | Tự động SNAT với IP động (PPP, DHCP)               | `nat`, `POSTROUTING` |
| **REDIRECT**   | Chuyển hướng gói về local (port forwarding nội bộ) | `nat`, `PREROUTING`  |
| **NETMAP**     | Ánh xạ 1 dải IP nguồn/đích sang dải IP khác        | `nat`                |

**Ví dụ:**

```bash
# NAT LAN ra Internet
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# Chuyển hướng port 8080 đến web server
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.10:80
```

---

## Nhóm 4: Marking và QoS

| Target         | Ý nghĩa                         | Ứng dụng                |
| -------------- | ------------------------------- | ----------------------- |
| **MARK**       | Gắn nhãn cho gói tin (`fwmark`) | Routing policy, QoS     |
| **CONNMARK**   | Gắn nhãn cho cả kết nối         | Giữ trạng thái giữa gói |
| **CLASSIFY**   | Gán lớp TC (traffic class)      | QoS nâng cao            |
| **TTL**        | Thay đổi TTL gói tin            | Giới hạn hop hoặc debug |
| **TOS / DSCP** | Sửa giá trị trường TOS/DSCP     | QoS, traffic shaping    |

**Ví dụ:**

```bash
iptables -t mangle -A PREROUTING -p tcp --dport 22 -j MARK --set-mark 1
```

---

## Nhóm 5: Target đặc biệt hoặc nhảy tới chain khác

| Target                     | Ý nghĩa                                 | Ghi chú                                  |
| -------------------------- | --------------------------------------- | ---------------------------------------- |
| **CHAIN_NAME**             | Nhảy đến chain do người dùng định nghĩa | Khi gói khớp rule, chuyển sang chain mới |
| **NOTRACK**                | Bỏ qua connection tracking              | `raw` table                              |
| **SECMARK / CONNSECMARK**  | Dán nhãn bảo mật SELinux                | Dùng trong hệ thống SELinux-enabled      |
| **SNAPSHOT / RESTOREMARK** | Lưu và khôi phục mark                   | Mở rộng QoS                              |

---
## 4. Cấu trúc lệnh iptables

Cú pháp chung:

```bash
iptables [-t table] command [chain] [match] [target]
```

**Ví dụ:**

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

**Giải thích:**

* `-A INPUT`: thêm rule vào chain INPUT
* `-p tcp`: giao thức TCP
* `--dport 22`: cổng đích 22 (SSH)
* `-j ACCEPT`: cho phép gói tin

---

## 5. Các lệnh cơ bản

| Lệnh | Mô tả                                       |
| ---- | ------------------------------------------- |
| `-A` | Thêm rule vào cuối chain                    |
| `-I` | Thêm rule vào đầu chain                     |
| `-D` | Xóa rule                                    |
| `-R` | Sửa rule                                    |
| `-L` | Liệt kê rule hiện có                        |
| `-F` | Xóa tất cả rule trong chain                 |
| `-P` | Thiết lập chính sách mặc định (ACCEPT/DROP) |
| `-t` | Chọn bảng (`filter`, `nat`, `mangle`,...)   |

---

## 6. Ví dụ cấu hình cơ bản

### 6.1. Cho phép SSH, HTTP, HTTPS; chặn mọi thứ khác

```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

---

### 6.2. Cho phép ping (ICMP)

```bash
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
```

---

### 6.3. Cấu hình NAT (chuyển mạng LAN ra Internet)

Giả sử eth0 là interface ra Internet, eth1 là mạng LAN nội bộ:

```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

---

### 6.4. Port Forwarding (DNAT)

Chuyển hướng port 8080 trên gateway đến webserver 192.168.1.10:80

```bash
iptables -t nat -A PREROUTING -p tcp --dport 8080 \
-j DNAT --to-destination 192.168.1.10:80
```

---

### 6.5. Logging

```bash
iptables -A INPUT -p tcp --dport 23 -j LOG --log-prefix "Telnet attempt: "
```

---

## 7. Kiểm tra và quản lý

Liệt kê các rule:

```bash
sudo iptables -L -n -v
```

Liệt kê trong bảng NAT:

```bash
sudo iptables -t nat -L -n -v
```

Lưu cấu hình:

```bash
sudo iptables-save > /etc/iptables/rules.v4
```

Khôi phục:

```bash
sudo iptables-restore < /etc/iptables/rules.v4
```

---

## 8. Mở rộng: iptables và conntrack

iptables sử dụng **connection tracking (conntrack)** để theo dõi trạng thái gói tin.

Các trạng thái phổ biến:

* **NEW**: gói đầu tiên của kết nối mới
* **ESTABLISHED**: kết nối đã tồn tại
* **RELATED**: kết nối phụ (như FTP data)
* **INVALID**: gói lỗi, không xác định

Ví dụ:

```bash
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

---

## 9. Mối quan hệ với Firewalld và nftables

| Công cụ       | Mục đích                                      | Ghi chú                          |
| ------------- | --------------------------------------------- | -------------------------------- |
| **iptables**  | Cấu hình firewall truyền thống                | Kernel < 4.18                    |
| **nftables**  | Thay thế iptables (modern backend)            | Ubuntu 22+, RHEL 9               |
| **firewalld** | Giao diện quản lý iptables/nftables bằng zone | Tiện hơn, dùng trong CentOS/RHEL |

---

## 10. Ví dụ lab thực tế

Giả sử có máy Ubuntu làm firewall cho LAN:

* eth0: Internet (WAN)
* eth1: LAN (192.168.10.0/24)
* Muốn cho LAN ra Internet, nhưng chỉ cho HTTP/HTTPS và DNS.

**Cấu hình:**

```bash
# Xóa toàn bộ rule cũ
iptables -F
iptables -t nat -F

# Cho phép loopback và kết nối sẵn có
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Cho phép LAN ra Internet (NAT)
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Cho phép LAN truy cập web và DNS
iptables -A FORWARD -i eth1 -o eth0 -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -p udp --dport 53 -j ACCEPT

# Chặn tất cả các truy cập khác
iptables -A FORWARD -j DROP
```
