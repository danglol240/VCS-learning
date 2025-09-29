# 1. Syslog / Rsyslog configuration

### Syslog là gì?

* **Syslog** là chuẩn chung để gửi log message trên Unix/Linux.
* **Rsyslog** là một implementation mở rộng của syslog (có nhiều tính năng hơn: filter, forward log qua TCP/UDP, lưu vào DB…).

### Ý nghĩa:

* Tất cả ứng dụng, service trong Linux đều có thể gửi log đến syslog.
* Syslog sẽ phân loại theo **facility** (auth, mail, daemon, kern, user, local0..local7) và **severity** (emerg, alert, crit, err, warning, notice, info, debug).
* Luồng: **App → Syslog API → Rsyslog daemon (`/dev/log`) → Log file / Remote server**

### File cấu hình cơ bản:

* `/etc/rsyslog.conf` hoặc `/etc/rsyslog.d/*.conf`

Ví dụ:

```
# Tất cả log kernel gửi vào /var/log/kern.log
kern.*     /var/log/kern.log

# Log auth và security gửi vào /var/log/auth.log
auth,authpriv.*    /var/log/auth.log

# Chuyển tiếp log sang server tập trung
*.*     @192.168.1.100:514    # UDP
*.*     @@192.168.1.100:514   # TCP
```

## 1. Cú pháp cơ bản của rsyslog

Trong file `/etc/rsyslog.conf` hoặc `/etc/rsyslog.d/*.conf`:

```
FACILITY.SEVERITY   ACTION
```

* **FACILITY**: loại log (auth, mail, daemon, kern, user, local0..local7, `*` = tất cả).
* **SEVERITY**: mức độ (debug, info, notice, warning, err, crit, alert, emerg, `*` = tất cả).
* **ACTION**: nơi gửi log (file, socket, remote server).

Ví dụ gửi ra remote:

```
*.*    @@192.168.1.100:514
```

(`@` = UDP, `@@` = TCP)

---

## 2. Chỉ định log cụ thể để forward

### Ví dụ 1: Chỉ forward log xác thực (auth)

```conf
auth,authpriv.*    @@192.168.1.100:514
```

### Ví dụ 2: Chỉ forward log kernel warning trở lên

```conf
kern.warning    @@192.168.1.100:514
```

### Ví dụ 3: Chỉ forward log apache2

Ứng dụng Apache log vào `/var/log/apache2/*.log`. Để forward:

```conf
if $programname == 'apache2' then @@192.168.1.100:514
& stop
```

### Ví dụ 4: Gửi log ứng dụng tự định nghĩa (dùng local facility)

Ứng dụng của bạn có thể log bằng `logger -p local0.info "msg"`.
Trên client cấu hình:

```conf
local0.*    @@192.168.1.100:514
```

---

## 3. Kết hợp forward + lưu local

Nếu bạn vừa muốn **lưu log local** vừa forward đi, có thể viết 2 action:

```conf
authpriv.*    /var/log/auth.log
authpriv.*    @@192.168.1.100:514
```

---

## 4. Reload lại rsyslog để áp dụng

```bash
sudo systemctl restart rsyslog
```

---

# 2. Mô hình log tập trung

### Ý tưởng:

* Có nhiều server → gửi log về **central log server** để dễ quản lý.
* Client rsyslog forward log qua TCP/UDP đến server.
* Server rsyslog nhận log → lưu vào file theo source host, hoặc gửi tiếp vào hệ thống phân tích (ELK, Loki…).

### Cấu hình cơ bản:

* **Server (/etc/rsyslog.conf):**

```conf
module(load="imudp")
input(type="imudp" port="514")

module(load="imtcp")
input(type="imtcp" port="514")

*.*   /var/log/remote.log
```

* **Client (/etc/rsyslog.conf):**

```conf
*.*   @@logserver.example.com:514
```

---

# 3. Testing using logger

* `logger` là công cụ CLI gửi log đến syslog để test.

Ví dụ:

```bash
logger "Hello syslog test"
logger -p auth.notice "Login event test"
logger -t myapp "This is a test log from myapp"
```

→ Sau đó kiểm tra trong `/var/log/syslog`, `/var/log/auth.log`…

---

# 4. Managing logs with logrotate

### Tác dụng:

* Quản lý log file lớn: rotate (đổi tên), nén, xóa log cũ.
* Tránh đầy đĩa do log tăng mãi.

### File cấu hình:

* Toàn cục: `/etc/logrotate.conf`
* Dịch vụ riêng: `/etc/logrotate.d/<service>`

### Các tham số chính:

* `daily/weekly/monthly` → tần suất rotate
* `rotate N` → giữ lại N file cũ
* `compress` → nén log cũ (.gz)
* `size 100M` → rotate khi log > 100MB
* `missingok` → không báo lỗi nếu file log không tồn tại
* `notifempty` → không rotate file rỗng

### Ví dụ cấu hình cho Apache2 (`/etc/logrotate.d/apache2`):

```conf
/var/log/apache2/*.log {
    daily
    rotate 14
    compress
    missingok
    notifempty
    sharedscripts
    postrotate
        if [ -f /var/run/apache2.pid ]; then
            /etc/init.d/apache2 reload > /dev/null
        fi
    endscript
}
```

👉 **Tại sao cần `postrotate script`?**

* Vì khi rotate log, file log cũ được đổi tên → service vẫn ghi vào file cũ.
* `postrotate` dùng để gửi lệnh reload → service mở lại file log mới.

### Test logrotate:

```bash
sudo logrotate -d /etc/logrotate.conf     # chạy test, debug
sudo logrotate -f /etc/logrotate.conf     # force rotate
```

---

# 5. The systemd journal: `journalctl`

### Ý nghĩa:

* Trên hệ thống dùng **systemd**, nhiều service không log ra file `/var/log/...` nữa mà log vào **binary journal**.
* `journalctl` là công cụ để đọc log từ systemd journal.

### Cách dùng:

* Xem toàn bộ log:

  ```bash
  journalctl
  ```
* Xem log realtime (như `tail -f`):

  ```bash
  journalctl -f
  ```
* Lọc theo service:

  ```bash
  journalctl -u ssh
  journalctl -u apache2
  ```
* Lọc theo thời gian:

  ```bash
  journalctl --since "2025-09-01" --until "2025-09-29"
  ```
* Lọc theo priority (chỉ error):

  ```bash
  journalctl -p err
  ```

---

✅ Tóm lại:

* **Syslog/rsyslog**: nền tảng thu thập log, có thể tập trung.
* **logger**: test cấu hình syslog.
* **logrotate**: quản lý kích thước log, kèm postrotate để reload service.
* **journalctl**: đọc log trong hệ thống systemd.

---