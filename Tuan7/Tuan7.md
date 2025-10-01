# Quản lý mạng trên Linux

## 1. Các thao tác với card mạng (Network Interfaces)

### 1.1. Tắt/Bật network interface

* **Kiểm tra danh sách interface:**

```bash
ip link show / ip -a
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
      ethernets:
        eth0:
          dhcp4: no
          addresses:
            - 192.168.1.100/24
          gateway4: 192.168.1.1
          nameservers:
            addresses: [8.8.8.8, 1.1.1.1]
    ```

    Áp dụng:

    ```bash
    sudo netplan apply
    ```

  * **CentOS 7/8:**
    File: `/etc/sysconfig/network-scripts/ifcfg-eth0`

    ```
    BOOTPROTO=none
    ONBOOT=yes
    IPADDR=192.168.1.100
    PREFIX=24
    GATEWAY=192.168.1.1
    DNS1=8.8.8.8
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

### DNS

* **DNS là gì?**: Hệ thống phân giải tên miền → địa chỉ IP.

* **Vì sao cần?**: Giúp người dùng dễ nhớ tên thay vì IP.

<img width="407" height="295" alt="dns" src="https://github.com/user-attachments/assets/45d60904-301f-4c58-a954-1c8b50c92568" />

* **Kiến trúc sơ lược:**

  * Root servers
  * TLD servers (.com, .org,…)
  * Authoritative servers
  * Recursive resolvers

* Cấu hình DNS trên Linux:

  * Tạm thời: `/etc/resolv.conf`

    ```
    nameserver 8.8.8.8
    nameserver 1.1.1.1
    ```

## 1. **A record (Address Record)**

* **Ý nghĩa:** ánh xạ **tên miền → địa chỉ IPv4**.
* **Ví dụ:**

  ```
  example.com.    IN    A    93.184.216.34
  ```

  → Khi người dùng gõ `example.com`, DNS sẽ trả về địa chỉ IP `93.184.216.34`.
* **Thực tế:** dùng cho website, mail server, FTP server…

---

## 2. **AAAA record (IPv6 Address Record)**

* **Ý nghĩa:** ánh xạ **tên miền → địa chỉ IPv6**.
* **Ví dụ:**

  ```
  example.com.    IN    AAAA    2606:2800:220:1:248:1893:25c8:1946
  ```
* **Thực tế:** dùng khi triển khai IPv6 song song với IPv4.

---

## 3. **CNAME record (Canonical Name Record)**

* **Ý nghĩa:** tạo **bí danh (alias)** cho một tên miền.
* **Ví dụ:**

  ```
  www.example.com.   IN   CNAME   example.com.
  ```

  → `www.example.com` sẽ trỏ đến `example.com`.
* **Thực tế:** giúp quản lý dễ hơn, chỉ cần đổi IP của `example.com` thì alias tự cập nhật.

---

## 4. **MX record (Mail Exchanger)**

* **Ý nghĩa:** xác định **mail server** chịu trách nhiệm nhận email cho tên miền.
* **Ví dụ:**

  ```
  example.com.    IN    MX   10   mail1.example.com.
  example.com.    IN    MX   20   mail2.example.com.
  ```

  * `10`, `20` = **priority** (số nhỏ hơn = ưu tiên cao hơn).
* **Thực tế:** khi gửi mail đến `user@example.com`, mail server sẽ tìm MX record để biết gửi đến đâu.

---

## 5. **NS record (Name Server)**

* **Ý nghĩa:** khai báo **DNS server có thẩm quyền** cho domain.
* **Ví dụ:**

  ```
  example.com.    IN    NS    ns1.example.com.
  example.com.    IN    NS    ns2.example.com.
  ```
* **Thực tế:** khi người dùng tra DNS cho `example.com`, hệ thống sẽ hỏi các NS này để lấy dữ liệu.

---

## 6. **PTR record (Pointer Record)**

* **Ý nghĩa:** ánh xạ **IP → tên miền** (reverse DNS).
* **Ví dụ:**

  ```
  34.216.184.93.in-addr.arpa.    IN    PTR    example.com.
  ```
* **Thực tế:** dùng trong xác thực email (nhiều mail server từ chối kết nối nếu không có PTR).

---

## 7. **TXT record (Text Record)**

* **Ý nghĩa:** lưu **dữ liệu tùy ý dạng text** trong DNS.
* **Thực tế:** thường dùng cho bảo mật, ví dụ:

  * **SPF (Sender Policy Framework):** khai báo mail server nào được phép gửi email.

    ```
    example.com. IN TXT "v=spf1 include:_spf.google.com ~all"
    ```
  * **DKIM (DomainKeys Identified Mail):** dùng để xác thực chữ ký email.
  * **Google site verification, Microsoft 365, AWS…** đều yêu cầu TXT record để verify domain.

---

## 8. **SOA record (Start of Authority)**

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

## 6. NTP (Network Time Protocol)

* **NTP là gì?**: Giao thức đồng bộ thời gian giữa các hệ thống.
* **Mục đích:** Giữ thời gian chuẩn xác cho server.
* **Kiến trúc:** Client → NTP server → Stratum server → Atomic clock/GPS.

### Cấu hình NTP server đồng bộ sử dụng chrony
<img width="835" height="451" alt="chrony" src="https://github.com/user-attachments/assets/fe02eb70-9811-44de-9130-deaeaf55adca" />

## 1. Cài đặt Chrony
```bash
sudo apt update
sudo apt install chrony -y
```

Kiểm tra dịch vụ:

```bash
systemctl status chrony
```
## 2. Cấu hình Chrony

Mở file cấu hình:

```bash
sudo nano /etc/chrony/chrony.conf
```

Thêm/sửa các dòng sau:

```conf
# Cho phép client trong mạng LAN 192.168.1.0/24 truy cập
allow 192.168.1.0/24

# Đặt máy này làm "local clock" khi mất Internet
local stratum 10

# Cấu hình makestep: cho phép chỉnh giờ ngay nếu lệch >1s trong 3 lần đầu
makestep 1.0 3
```

> ⚠️ Lưu ý: Bạn có thể giữ lại các `pool` mặc định hoặc bỏ đi nếu chỉ muốn dùng LAN.

## 3. Khởi động lại dịch vụ
```bash
sudo systemctl restart chrony
sudo systemctl enable chrony
```

<img width="1510" height="682" alt="sync" src="https://github.com/user-attachments/assets/61820173-c195-45b3-997c-fe5e5bdc1a37" />