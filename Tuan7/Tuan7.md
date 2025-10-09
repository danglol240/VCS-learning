# Quản lý mạng trên Linux

## 1. Các thao tác với card mạng (Network Interfaces)

### 1.1. Tắt/Bật network interface

* **Kiểm tra danh sách interface:**

```bash
ip link show / ip a
```

* **Tắt interface:**

```bash
sudo ip link set eth0 down
```

* **Bật interface:**

```bash
sudo ip link set eth0 up
```
---

### 1.2. Cấu hình địa chỉ IP

#### Cấu hình Static (tĩnh)

* Tạm thời (mất sau reboot):

```bash
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

* Vĩnh viễn:

  * **Ubuntu (Netplan - 18.04/20.04):**
    File: `/etc/netplan/01-netcfg.yaml`

    ```yaml
    network:
      version: 2
      renderer: networkd
      ethernets:
        enp3s0:
          dhcp4: no
          addresses: [192.168.1.10/24]
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
          routes:
            - to: default
              via: 192.168.1.1
    ```

    Áp dụng:

    ```bash
    sudo netplan apply
    ```
#### Cấu hình DHCP

<img width="560" height="163" alt="dhcpconf" src="https://github.com/user-attachments/assets/e65b9ade-29b8-4457-889c-0841ba2a308a" />

1. **`subnet 192.168.1.0 netmask 255.255.255.0 { ... }`**

   * Xác định phạm vi mạng mà DHCP server cấp IP.
   * Ở đây là mạng **192.168.1.0/24** (tức từ 192.168.1.1 → 192.168.1.254).

2. **`range 192.168.1.10 192.168.1.20;`**

   * Dải địa chỉ IP mà DHCP sẽ **cấp phát động** cho client.
   * Client sẽ nhận IP từ **192.168.1.10 → 192.168.1.20**.

3. **`default-lease-time 86400;`**

   * Thời gian mặc định một client được thuê IP (lease).
   * Đơn vị = giây → `86400 giây = 24 giờ`.

4. **`max-lease-time 86400;`**

   * Thời gian tối đa một client được thuê IP.
   * Ở đây cũng là 24 giờ.

5. **`option routers 192.168.1.1;`**

   * Cung cấp địa chỉ **gateway (router)** cho client.
   * Client sẽ dùng IP **192.168.1.1** làm default gateway để đi ra ngoài LAN.

6. **`option domain-name-servers 4.4.4.4,8.8.8.8;`**

   * Chỉ định danh sách DNS server mà client sẽ dùng.
   * Ở đây: `4.4.4.4` và `8.8.8.8` (Google DNS).

---
**Luồng DHCP:**

1. **DHCPDISCOVER** – Client gửi broadcast tìm DHCP server.
2. **DHCPOFFER** – Server phản hồi địa chỉ khả dụng.
3. **DHCPREQUEST** – Client yêu cầu IP từ server.
4. **DHCPACK** – Server xác nhận và gán IP.

<img width="1205" height="240" alt="dhcp" src="https://github.com/user-attachments/assets/25d3c64e-2fb9-45d3-bd89-fdffd542ec44" />

---

## 2. Các service quản lý network

* **CentOS/RHEL:** sử dụng `network` hoặc `NetworkManager`

```bash
sudo systemctl restart NetworkManager
```

* **Ubuntu 16.04:** `ifupdown`
* **Ubuntu 18.04/20.04+:** `netplan` kết hợp `systemd-networkd` hoặc `NetworkManager`

---

## 3. Cấu hình Hostname và DNS

### Hostname

* Kiểm tra hostname:

```bash
hostname
hostnamectl
```

* Đặt hostname:

```bash
sudo hostnamectl set-hostname server01
```
File /etc/hosts dùng để ánh xạ tên máy (hostname) ↔ địa chỉ IP trước khi tra cứu qua DNS.
Khi hệ thống cần tìm IP của một tên miền, nó sẽ tra cứu file này đầu tiên, sau đó mới đến DNS.

Vì vậy, file này dùng để:

Xác định hostname nội bộ (ví dụ: localhost, dangdb, myserver.local...).

Cấu hình tạm hoặc ghi đè kết quả DNS (ví dụ để chặn truy cập, test domain, v.v.).

### DNS

* **DNS là gì?**: Hệ thống phân giải tên miền → địa chỉ IP.

* **Vì sao cần?**: Giúp người dùng dễ nhớ tên thay vì IP.

<img width="407" height="295" alt="dns" src="https://github.com/user-attachments/assets/45d60904-301f-4c58-a954-1c8b50c92568" />

* **Kiến trúc sơ lược:**

  * Root servers
  * TLD servers (.com, .org,…)
  * Authoritative servers
  * Recursive resolvers

* Cấu hình DNS resolver trên Linux:

  * Tạm thời: `/etc/resolv.conf`

    ```
    nameserver 8.8.8.8
    nameserver 1.1.1.1
    ```

* Cách kiểm tra / xem 1 DNS record : sử dụng dig/nslookup
<img width="1205" height="788" alt="dig" src="https://github.com/user-attachments/assets/cd1e913f-5b88-4489-99da-98871810ae5f" />

## 1. **A record (Address Record)**

* **Ý nghĩa:** ánh xạ **tên miền → địa chỉ IPv4**.
* **Ví dụ:**

  ```
  example.com.    IN    A    93.184.216.34
  ```

  → Khi người dùng gõ `example.com`, DNS sẽ trả về địa chỉ IP `93.184.216.34`.

---

## 2. **AAAA record (IPv6 Address Record)**

* **Ý nghĩa:** ánh xạ **tên miền → địa chỉ IPv6**.
* **Ví dụ:**

  ```
  example.com.    IN    AAAA    2606:2800:220:1:248:1893:25c8:1946
  ```

---

## 3. **CNAME record (Canonical Name Record)**

* **Ý nghĩa:** tạo **bí danh (alias)** cho một tên miền.
* **Ví dụ:**

  ```
  www.example.com.   IN   CNAME   example.com.
  ```

  → `www.example.com` sẽ trỏ đến `example.com`.

---

## 4. **MX record (Mail Exchanger)**

* **Ý nghĩa:** xác định **mail server** chịu trách nhiệm nhận email cho tên miền.
* **Ví dụ:**

  ```
  example.com.    IN    MX   10   mail1.example.com.
  example.com.    IN    MX   20   mail2.example.com.
  ```

  * `10`, `20` = **priority** (số nhỏ hơn = ưu tiên cao hơn).

---

## 5. **NS record (Name Server)**

* **Ý nghĩa:** khai báo **DNS server có thẩm quyền** cho domain.
* **Ví dụ:**

  ```
  example.com.    IN    NS    ns1.example.com.
  example.com.    IN    NS    ns2.example.com.
  ```
---

## 6. **PTR record (Pointer Record)**

* **Ý nghĩa:** ánh xạ **IP → tên miền** (reverse DNS).
* **Ví dụ:**

  ```
  34.216.184.93.in-addr.arpa.    IN    PTR    example.com.
  ```

---
## 7. **SOA record (Start of Authority)**

* **Ý nghĩa:** chứa thông tin quản trị cho zone DNS.
* **Bao gồm:** primary DNS server, email admin, serial number, refresh, retry, expire, TTL.
* **Ví dụ:**

  ```
  example.com. IN SOA ns1.example.com. admin.example.com. (
      2025092601 ; Serial
      3600       ; Refresh
      600        ; Retry
      1209600    ; Expire
      3600 )     ; Minimum TTL
  ```

## 4. Routing trên Linux

### Tại sao cần Routing?

* Cho phép hệ thống gửi gói tin đến mạng khác (qua gateway).

### Cấu hình route

* Xem bảng route:

```bash
ip route show
```
Ví dụ output:

```bash
default via 192.168.1.1 dev eth0 proto dhcp metric 100
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10 metric 100
```

### Các trường quan trọng:

* **default** → route mặc định (nếu gói tin không match route nào khác thì đi theo route này).
* **via 192.168.1.1** → địa chỉ gateway (router) mà gói tin sẽ đi qua.
* **dev eth0** → interface sử dụng để gửi gói.
* **proto** → nguồn gốc route:

  * `kernel` → do kernel tự tạo khi interface up.
  * `dhcp` → lấy từ DHCP.
  * `static` → do admin thêm thủ công.
* **scope** → phạm vi sử dụng route:
  * `link` → Địa chỉ IP đích nằm trên cùng mạng LAN (cùng subnet) với bạn, nên có thể gửi trực tiếp mà không cần đi qua router/gateway.
* **src 192.168.1.10** → địa chỉ IP mà kernel sẽ dùng làm source khi ứng dụng gửi gói mà không bind một địa chỉ nguồn cụ thể.
* **metric 100** → độ ưu tiên (route nào metric nhỏ hơn sẽ được chọn trước).

---

* Thêm route:

```bash
sudo ip route add 192.168.2.0/24 via 192.168.1.1
```

* Xóa route:

```bash
sudo ip route del 192.168.2.0/24
```
## 5. Cấu hình thời gian và timezone

### Kiểm tra và đặt timezone

```bash
timedatectl
sudo timedatectl set-timezone Asia/Ho_Chi_Minh
```

---
<img width="1510" height="682" alt="sync" src="https://github.com/user-attachments/assets/61820173-c195-45b3-997c-fe5e5bdc1a37" />

# NTP – Network Time Protocol

## 1. Khái niệm

**NTP (Network Time Protocol)** là giao thức chuẩn dùng để đồng bộ thời gian giữa các máy tính trong mạng dùng giao thức UDP cổng 123.
Nếu thời gian giữa các máy không được đồng bộ chính xác, nhiều dịch vụ và hệ thống có thể hoạt động sai hoặc gặp lỗi.

---

## 2. Tầm quan trọng của việc đồng bộ thời gian

| Lĩnh vực                           | Ảnh hưởng khi thời gian không đồng bộ                                                                                                                |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bảo mật                            | Các giao thức bảo mật như SSL/TLS, Kerberos... sử dụng timestamp để chống tấn công phát lại. Khi thời gian lệch, quá trình xác thực có thể thất bại. |
| Ghi log và giám sát                | Thời gian không thống nhất khiến việc phân tích sự cố và theo dõi hệ thống trở nên sai lệch.                                                         |
| Cơ sở dữ liệu và hệ thống phân tán | Lệch thời gian giữa các node có thể gây xung đột dữ liệu, ghi đè sai thứ tự.                                                                         |
| Sao lưu và đồng bộ tệp             | Các công cụ sao lưu dựa trên timestamp để xác định tệp mới. Nếu thời gian không khớp, việc đồng bộ có thể sai hoặc bỏ sót dữ liệu.                   |
| Ứng dụng người dùng                | Các ứng dụng có thể hiển thị dữ liệu không đúng thứ tự hoặc thực hiện hành động sai thời điểm.                                                       |

---

## 3. Kiến trúc của NTP

NTP được tổ chức theo mô hình phân cấp nhiều tầng (gọi là các **Stratum**):

| Tầng                 | Mô tả                                                                                                                                                 |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Stratum 0**        | Là các thiết bị phần cứng có độ chính xác cao như đồng hồ nguyên tử (atomic clock) hoặc GPS clock. Các thiết bị này không kết nối trực tiếp với mạng. |
| **Stratum 1**        | Là các máy chủ NTP đồng bộ trực tiếp với Stratum 0, cung cấp thời gian chính xác cho các tầng dưới.                                                   |
| **Stratum 2**        | Đồng bộ thời gian từ Stratum 1 và cung cấp lại cho client.                                                                                            |
| **Stratum 3, 4,...** | Các tầng thấp hơn, đồng bộ từ tầng trên theo mô hình cây.                                                                                             |
| **Client**           | Là các máy trạm thông thường, thường đồng bộ từ server Stratum 2 hoặc cao hơn.                                                                        |

Hệ thống NTP trên Internet thường được cấu trúc theo mô hình cây đa nguồn, giúp dự phòng khi một máy chủ gặp sự cố.

---

## 4. Cơ chế hoạt động của NTP

Khi một client đồng bộ với NTP server, quá trình trao đổi gồm bốn mốc thời gian:

| Ký hiệu              | Thời điểm                                    | Ý nghĩa |
| -------------------- | -------------------------------------------- | ------- |
| **T1 (Originate)**   | Thời điểm client gửi yêu cầu đến server      |         |
| **T2 (Receive)**     | Thời điểm server nhận yêu cầu                |         |
| **T3 (Transmit)**    | Thời điểm server gửi phản hồi trở lại client |         |
| **T4 (Destination)** | Thời điểm client nhận phản hồi               |         |

Từ bốn giá trị thời gian này, client có thể tính được:

* **Độ trễ mạng (Delay)**
  [
  Delay = \frac{(T4 - T1) - (T3 - T2)}{2}
  ]
  Đại diện cho độ trễ trung bình một chiều của gói tin trên đường truyền.

* **Độ lệch thời gian (Offset)**
  [
  Offset = \frac{(T2 - T1) + (T3 - T4)}{2}
  ]
  Cho biết mức độ sai lệch giữa đồng hồ client và server, giúp client hiệu chỉnh lại thời gian hệ thống.

---

## 5. Cấu hình NTP trên máy chủ (ví dụ với Chrony)

### Bước 1: Cài đặt

```bash
sudo apt install chrony -y
```

### Bước 2: Chỉnh sửa file cấu hình `/etc/chrony/chrony.conf`

```bash
# Khai báo các nguồn thời gian chuẩn
server time.google.com iburst
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst

# Cho phép client trong mạng LAN đồng bộ
allow 192.168.1.0/24
```
<img width="1510" height="682" alt="sync" src="https://github.com/user-attachments/assets/61820173-c195-45b3-997c-fe5e5bdc1a37" />

### Bước 3: Khởi động và kiểm tra trạng thái

```bash
sudo systemctl enable chronyd --now
chronyc sources -v
```

Lệnh `chronyc sources -v` sẽ hiển thị danh sách các máy chủ NTP mà hệ thống đang đồng bộ cùng trạng thái của chúng.
<img width="835" height="451" alt="chrony" src="https://github.com/user-attachments/assets/68df6c90-dd4a-432f-b884-d5859df89387" />

Lệnh `chronyc tracking` sẽ kiểm tra độ chính xác và đồng bộ tổng thể
<img width="436" height="242" alt="tracking" src="https://github.com/user-attachments/assets/aa3734dd-d45f-4be8-8c97-e77ea02a5bc8" />
---

