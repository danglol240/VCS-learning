# Quản lý mạng trên Linux

## 1. Các thao tác với card mạng (Network Interfaces)

### 1.1. Tắt/Bật network interface

* **Kiểm tra danh sách interface:**

```bash
ip link show
```

* **Tắt interface:**

```bash
sudo ip link set eth0 down
```

* **Bật interface:**

```bash
sudo ip link set eth0 up
```

* Với hệ thống dùng `ifconfig` (cũ):

```bash
sudo ifconfig eth0 down
sudo ifconfig eth0 up
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

* Cho phép nhận IP tự động:

```bash
sudo dhclient eth0
```

* Trên Ubuntu Netplan:

```yaml
eth0:
  dhcp4: yes
```

**Luồng DHCP:**

1. **DHCPDISCOVER** – Client gửi broadcast tìm DHCP server.
2. **DHCPOFFER** – Server phản hồi địa chỉ khả dụng.
3. **DHCPREQUEST** – Client yêu cầu IP từ server.
4. **DHCPACK** – Server xác nhận và gán IP.

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

---

## 4. Routing trên Linux

### Tại sao cần Routing?

* Cho phép hệ thống gửi gói tin đến mạng khác (qua gateway).

### Cấu hình route

* Xem bảng route:

```bash
ip route show
```

* Thêm route:

```bash
sudo ip route add 192.168.2.0/24 via 192.168.1.1
```

* Xóa route:

```bash
sudo ip route del 192.168.2.0/24
```

**Giải thích bảng route:**

* Destination: mạng đích
* Gateway: cổng ra
* Genmask: subnet mask
* Iface: giao diện mạng

---

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

### Cấu hình NTP server đồng bộ

* Cài đặt:

```bash
sudo yum install ntp    # CentOS
sudo apt install ntp    # Ubuntu
```

* Cấu hình `/etc/ntpsec/ntp.conf` (ví dụ đồng bộ với pool.ntp.org):

```
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
```

* Khởi động dịch vụ:

```bash
sudo systemctl enable ntpd
sudo systemctl start ntpd
```

* Kiểm tra đồng bộ:

```bash
ntpq -p
```
