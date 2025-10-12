# 1. Syslog / Rsyslog configuration

### Syslog là gì?

* **Syslog** là chuẩn chung để gửi log message trên Unix/Linux.
* **Rsyslog** là một implementation mở rộng của syslog (có nhiều tính năng hơn: filter, forward log qua TCP/UDP, lưu vào DB…).

### Ý nghĩa:

* Tất cả ứng dụng, service trong Linux đều có thể gửi log đến syslog.
* Syslog sẽ phân loại theo **facility** (auth, mail, daemon, kern, user, local0..local7) và **severity** (emerg, alert, crit, err, warning, notice, info, debug).
* Luồng: **App → Syslog API → Rsyslog daemon (`/dev/log`) → Log file / Remote server**

# 1. Facility là gì?

 **Facility = nguồn gốc (loại dịch vụ / ứng dụng) sinh ra log**.
Hệ thống chia ra nhiều facility chuẩn để phân loại log cho dễ quản lý.

### Một số facility chuẩn:

| Facility          | Giá trị số | Ý nghĩa (nguồn log)                                    |
| ----------------- | ---------- | ------------------------------------------------------ |
| `kern`            | 0          | Log từ kernel                                          |
| `user`            | 1          | Log từ chương trình user-level (ứng dụng thông thường) |
| `mail`            | 2          | Log từ hệ thống mail                                   |
| `daemon`          | 3          | Log từ các system daemon (dịch vụ nền)                 |
| `auth`            | 4          | Log liên quan tới authentication (PAM, login)          |
| `syslog`          | 5          | Log từ chính syslog/rsyslog                            |
| `lpr`             | 6          | Log từ subsystem in ấn                                 |
| `news`            | 7          | Log từ dịch vụ news (Usenet, ít dùng)                  |
| `uucp`            | 8          | UUCP (cũ)                                              |
| `cron`            | 9          | Log từ cron jobs                                       |
| `authpriv`        | 10         | Log auth riêng tư (SSH, sudo, su)                      |
| `ftp`             | 11         | Log FTP                                                |
| `local0`–`local7` | 16–23      | Log dành cho custom app                                |

 **Ứng dụng** khi gửi log sẽ gắn **facility** để syslog biết log thuộc loại nào.

---

# 2. Severity là gì?

 **Severity = mức độ quan trọng (độ nghiêm trọng) của log**.
Có 8 cấp độ chuẩn (theo RFC5424), số càng nhỏ thì càng nghiêm trọng:

| Giá trị số | Tên severity | Ý nghĩa                                                  |
| ---------- | ------------ | -------------------------------------------------------- |
| 0          | `emerg`      | Emergency – hệ thống chết hoàn toàn (panic)              |
| 1          | `alert`      | Alert – cần xử lý ngay (ví dụ mất nguồn điện)            |
| 2          | `crit`       | Critical – lỗi nghiêm trọng (hỏng ổ cứng, service crash) |
| 3          | `err`        | Error – lỗi chung                                        |
| 4          | `warning`    | Warning – cảnh báo, có thể ảnh hưởng                     |
| 5          | `notice`     | Notice – thông báo quan trọng nhưng không lỗi            |
| 6          | `info`       | Info – thông tin bình thường                             |
| 7          | `debug`      | Debug – thông tin chi tiết để gỡ lỗi                     |

 Mỗi log đều có **severity** để cho biết mức nghiêm trọng.

---

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
<img width="656" height="203" alt="rsyslog_server" src="https://github.com/user-attachments/assets/ed6d1823-9623-4f6f-9919-5e5b9004c88f" />
<img width="851" height="191" alt="rsyslog_client" src="https://github.com/user-attachments/assets/333733d9-4832-4fed-a419-b91a760f872b" />

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

Ứng dụng có thể log bằng `logger -p local0.info "msg"`.
Trên client cấu hình:

```conf
local0.*    @@192.168.1.100:514
```

---

## 3. Kết hợp forward + lưu local

Nếu vừa muốn **lưu log local** vừa forward đi, có thể viết 2 action:

```conf
authpriv.*    /var/log/auth.log
authpriv.*    @@192.168.1.100:514
```

# 2. Mô hình log tập trung

### Ý tưởng:

* Có nhiều server → gửi log về **central log server** để dễ quản lý.
* Client rsyslog forward log qua TCP/UDP đến server.
* Server rsyslog nhận log → lưu vào file theo source host, hoặc gửi tiếp vào hệ thống phân tích (ELK, Loki…).

### Mục đích

* Việc triển khai mô hình log tập trung nhằm giải quyết các vấn đề thường gặp khi quản lý log phân tán:

* Khi chỉ quan sát log từ một nguồn đơn lẻ, ta không thể có cái nhìn tổng thể về toàn hệ thống.

* Trong quá trình xử lý sự cố, các sự kiện thường liên quan đến nhiều thành phần khác nhau → cần tổng hợp và đối chiếu log từ nhiều nguồn.

* Nếu phải đăng nhập thủ công vào từng máy để đọc log, việc này tốn thời gian và dễ bỏ sót sự kiện quan trọng.

* Khi có sự cố nghiêm trọng (server lỗi, ổ đĩa hỏng, bị tấn công...), log cục bộ có thể bị mất hoặc xóa. Lưu trữ tập trung giúp đảm bảo an toàn và toàn vẹn dữ liệu log.

### Lợi ích
| Lợi ích                             | Mô tả                                                                                                                                    |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Quản lý tập trung**               | Dễ dàng theo dõi trạng thái của toàn hệ thống hoặc ứng dụng từ một điểm duy nhất.                                                        |
| **Phân tích nhanh sự cố**           | Cho phép truy vấn, tìm kiếm và lọc log theo nhiều tiêu chí → giúp rút ngắn thời gian khắc phục sự cố.                                    |
| **Đảm bảo tính toàn vẹn log**       | Log được lưu trên máy chủ riêng biệt, tránh bị mất hoặc chỉnh sửa trên máy nguồn.                                                        |
| **Giám sát bảo mật**                | Hỗ trợ phát hiện sớm các hành vi bất thường hoặc tấn công tiềm ẩn.                                                                       |
| **Khả năng mở rộng và tự động hóa** | Có thể tích hợp với các hệ thống giám sát như **Grafana**, **Kibana**, hoặc để trực quan hóa, cảnh báo và phân tích chuyên sâu. |

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

Trong đó có các option:
- p facility.level, chỉ định giá trị facility và level (ví dụ logger -p local0.info “Test”)
- t chỉ định tag cho log (ví dụ logger -t myapp “Test”)
- i, đặt PID kèm theo (ví dụ logger -t myapp -i "App crash")
- n HOST -p PORT, gửi log qua địa chỉ host log server
- --tcp, --udp chỉ định giao thức gửi
- f FILE, đọc từ file (logger -t backup -p local1.info -f /var/log/backup_result.log)
---

# 4. Managing logs with logrotate

### Tác dụng:

* Quản lý log file lớn: rotate (đổi tên), nén, xóa log cũ.
* Tránh đầy đĩa do log tăng mãi.

### File cấu hình:

* Toàn cục: `/etc/logrotate.conf`
* Dịch vụ riêng: `/etc/logrotate.d/<service>`

### Các tham số chính:
* `daily`, `weekly`, `monthly`

  * Chỉ định tần suất rotate. (Tần suất thực tế phụ thuộc cron job gọi logrotate.)

* `rotate <count>`

  * Giữ lại bao nhiêu bản cũ. `rotate 7` giữ 7 bản (1..7).

* `size <bytes>` / `minsize` / `maxsize`

  * `size 100M` → chỉ rotate khi file ≥ 100MB (bất kể time). `minsize` chỉ rotate khi file log lớn hơn dung lượng cho trước nếu đến tần suất (daily,weekly,...) thì sẽ không rotate nếu chưa đủ, `maxsize` kết hợp với tần suất.

* `compress` / `delaycompress` / `compresscmd` / `compressext`

  * `compress`: nén file xoay (mặc định gzip).
  * `delaycompress`: hoãn nén file vừa mới rotate 1 lần (thường dùng khi dịch vụ vẫn giữ file handle).
  * `compresscmd` cho phép dùng chương trình nén khác, `compressext` chỉ định hậu tố.

* `create <mode> <owner> <group>`

  * Sau khi rotate, tạo file log mới với quyền/owner chỉ định. Ví dụ `create 0640 root adm`.

* `missingok`

  * Không báo lỗi nếu file không tồn tại.

* `notifempty`

  * Không rotate nếu file rỗng.

* `sharedscripts`

  * Nếu group nhiều file cùng 1 khối config, `postrotate`/`prerotate` mặc định chạy **cho mỗi file**; `sharedscripts` khiến các script chạy **1 lần duy nhất** cho toàn bộ block. Rất quan trọng khi postrotate reload service (không muốn reload nhiều lần).

* `prerotate` / `postrotate` ... `endscript`

  * Script shell chạy trước/sau rotation. Thường dùng để reload/reopen service. Ví dụ:

    ```conf
    postrotate
      systemctl reload rsyslog || true
    endscript
    ```

* `dateext` / `dateformat`

  * Sử dụng ngày trong tên file xoay (vd `-20251002`) thay cho `.1`. Dễ quản lý theo thời gian.

* `maxage <days>`

  * Xóa bản cũ hơn N ngày.

* `su <user> <group>`

  * Quy định user/group để thực hiện thao tác rotate file (dùng trên hệ không chạy logrotate bằng root hoặc cần quyền file đặc biệt).

### Ví dụ cấu hình cho log nhận được từ rsyslog (`/etc/logrotate.d/rsyslog-remote`):

```conf
/var/log/danglol240/*.log
/var/log/danglol2400/*.log
/var/log/danglol2402/*.log {
    weekly
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    dateext
    sharedscripts
    su root syslog
    create 0640 syslog syslog
    postrotate
        systemctl reload rsyslog > /dev/null 2>&1 || true
    endscript
}

```
<img width="831" height="1097" alt="logrotate" src="https://github.com/user-attachments/assets/6dbdac1c-9fd9-48f9-9e86-336fc0d360db" />

 **Tại sao cần `postrotate script`?**

* Vì khi rotate log, file log cũ được đổi tên → service đang hoạt động vẫn ghi vào file cũ.
* `postrotate` dùng để gửi lệnh reload → service mở lại file log mới.

### Test logrotate:

```bash
sudo logrotate -d /etc/logrotate.conf     # chạy test, debug
sudo logrotate -f /etc/logrotate.conf     # force rotate
```
# 5. The systemd journal: `journalctl`

### Ý nghĩa:

* Trên hệ thống dùng **systemd**, nhiều service không log ra file `/var/log/...` nữa mà log vào **binary journal**.
* `journalctl` là công cụ để đọc log từ systemd journal.

- Nó gom log từ nhiều nguồn:
+ Kernel messages (dmesg)
+ systemd unit log (dịch vụ, timer, socket)
+ stdout/stderr của dịch vụ chạy bởi systemd
+ Thông điệp từ syslog API (/dev/log)



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
* Lọc theo severity:

  ```bash
  journalctl -p err
  ```

| **Tiêu chí**                     | **systemd-journald / journalctl**                                 | **rsyslog**                                              |
| -------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------- |
| **1. Định dạng log**             | Nhị phân (binary), chỉ đọc bằng `journalctl`                      | Văn bản thuần (plain text), đọc bằng `cat`, `grep`, v.v. |
| **2. Lưu trữ & quản lý**         | Tự quản lý kích thước, tự xoay vòng (SystemMaxUse, RuntimeMaxUse) | Dùng `logrotate`, tùy chỉnh lưu trữ, nén, xóa linh hoạt  |
| **3. Phạm vi sử dụng**           | Ghi log nội bộ của hệ thống `systemd`                             | Thu thập, xử lý, gửi log đi xa, phù hợp log tập trung    |
| **4. Khả năng gửi log ra ngoài** | Không hỗ trợ (chỉ lưu local)                                      | Hỗ trợ gửi log qua UDP/TCP/TLS → server khác             |
| **5. Tích hợp & phân tích**      | Dễ lọc, tìm kiếm theo dịch vụ (`journalctl -u ssh`)               | Dễ tích hợp với ELK, Loki, SIEM để phân tích tập trung   |
