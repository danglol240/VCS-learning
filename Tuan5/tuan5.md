# Process monitoring and Scheduling
## Process monitoring
### Cách Chuyển Tiến Trình Đang Chạy Sang Nền Hoặc Tiền Cảnh (&, fg, bg, jobs, Ctrl+Z)

Trong các shell Linux như bash, bạn có thể quản lý tiến trình giữa tiền cảnh (tương tác) và nền (không tương tác) bằng các lệnh tích hợp. Những lệnh này rất cần thiết để đa nhiệm trong terminal.

- **& (Dấu Và)**: Chạy lệnh ngay lập tức ở nền.  
  Ví dụ: `sleep 60 &` – Khởi chạy tiến trình sleep 60 giây ở nền, giải phóng terminal cho các lệnh khác. Shell sẽ in ID job (ví dụ: `[1] 1234`).

- **Ctrl+Z**: Tạm dừng tiến trình tiền cảnh hiện tại bằng cách gửi tín hiệu SIGTSTP. Không giết tiến trình mà chỉ dừng tạm thời.  
  Ví dụ: Khi chạy `sleep 60`, nhấn Ctrl+Z – Kết quả: `[1]+  Stopped                 sleep 60`. Tiến trình giờ bị tạm dừng và có thể quản lý.

- **jobs**: Liệt kê tất cả các job (tiến trình nền hoặc tạm dừng) trong phiên shell hiện tại, kèm ID job (ví dụ: %1, %2).  
  Ví dụ: `jobs` – Có thể hiển thị: `[1]+  Stopped                 sleep 60`. Sử dụng `-l` để xem PID: `jobs -l`.

- **bg (Background)**: Tiếp tục job bị tạm dừng ở nền.  
  Ví dụ: Sau Ctrl+Z, chạy `bg %1` (với %1 là ID job từ `jobs`). Tiến trình tiếp tục chạy mà không chiếm terminal.

- **fg (Foreground)**: Đưa job nền hoặc tạm dừng về tiền cảnh, làm cho nó tương tác lại.  
  Ví dụ: `fg %1` – Tiếp tục job ở foreground, nơi có thể tương tác (ví dụ: xem output hoặc gửi Ctrl+C).

<img width="406" height="277" alt="sleep" src="https://github.com/user-attachments/assets/3cbf4d8b-7ccd-419a-87ea-8b76171eadc6" />

### Các Trường Hợp Sử Dụng Lệnh nohup

`nohup` (no hangup) chạy lệnh mà không bị ảnh hưởng bởi tín hiệu hangup (SIGHUP), được gửi khi terminal đóng (ví dụ: logout hoặc ngắt SSH). Nó chuyển hướng output sang `nohup.out` mặc định và thường kết hợp với `&` để chạy nền.

- **Cú Pháp**: `nohup command [args] &`  
  Ví dụ: `nohup ping 8.8.8.8`
  <img width="1102" height="581" alt="nohup" src="https://github.com/user-attachments/assets/38ba52ca-a0d3-4665-8106-959ca779bfae" />


- **Trường Hợp Sử Dụng**:
  - **Phiên Làm Việc Từ Xa (SSH)**: Chạy nhiệm vụ dài trên server mà không bị dừng khi ngắt kết nối. Ví dụ: `nohup wget file.url &` – Tải tiếp tục sau khi logout ở background.
  - **Xử Lý Script**: Dành cho script mất hàng giờ/ngày (ví dụ: sao lưu dữ liệu, biên dịch) mà không cần terminal mở.
  - **Hành Vi Giống Daemon**: Mô phỏng tiến trình liên tục mà không cần daemon hóa đầy đủ (mặc dù `systemd` hoặc `screen` tốt hơn cho dịch vụ).

Lưu Ý: `nohup` không biến tiến trình thành daemon; kết hợp với `disown` để loại khỏi bảng job của shell.

### Lệnh kill và Gửi Tín Hiệu Đến Tiến Trình (SIGINT, SIGTERM, SIGKILL)

Lệnh `kill` gửi tín hiệu đến tiến trình theo PID (Process ID). Tín hiệu là gián đoạn phần mềm để giao tiếp (ví dụ: dừng, tạm dừng). Tìm PID bằng `ps aux | grep process-name` hoặc `pgrep name`.

- **Cú Pháp**: `kill [-signal] PID` (tín hiệu mặc định là SIGTERM). Sử dụng `kill -l` để liệt kê tất cả tín hiệu.

- **Các Tín Hiệu Phổ Biến**:
  - **SIGINT (Tín Hiệu 2)**: Gián đoạn từ bàn phím (ví dụ: Ctrl+C). Yêu cầu dừng lịch sự, cho phép dọn dẹp. Thường bị bỏ qua bởi daemon.
    - Ví dụ: `kill -2 1234` hoặc `kill -SIGINT 1234`.
  - **SIGTERM (Tín Hiệu 15)**: Yêu cầu dừng (mặc định cho `kill PID`). Dừng graceful; tiến trình có thể xử lý (lưu dữ liệu, đóng file).
    - Ví dụ: `kill 1234` (gửi SIGTERM).
  - **SIGKILL (Tín Hiệu 9)**: Dừng ép buộc. Dừng ngay lập tức mà không dọn dẹp; kernel thực thi. Sử dụng cuối cùng (có thể gây mất dữ liệu).
    - Ví dụ: `kill -9 1234` hoặc `kill -SIGKILL 1234`. Không thể bỏ qua.

- **Trường Hợp Sử Dụng**:
  - Dừng graceful: Sử dụng SIGTERM cho dịch vụ như Apache (`kill -15 $(pgrep apache)`).
  - Gián đoạn tương tác: SIGINT cho tiến trình người dùng.
  - Tiến trình không phản hồi: SIGKILL khi các tín hiệu khác thất bại.
  - Tín hiệu khác: SIGUSR1 (tùy chỉnh, ví dụ: tải lại config), SIGHUP (hangup, ví dụ: tải lại daemon).

Công cụ như `pkill` (kill theo tên) hoặc `killall` đơn giản hóa: `pkill -SIGTERM process-name`.

## Cron

### Crontab Hệ Thống và Crontab Người Dùng Là Gì

Cron là một daemon trên Linux/Unix là công cụ lập lịch dựa trên thời gian cho các nhiệm vụ định kỳ.

- **Crontab Hệ Thống**: Nằm ở `/etc/crontab`, quản lý bởi root. Bao gồm trường "user" thêm để chỉ định ai chạy job (ví dụ: `root`) Dùng cho nhiệm vụ toàn hệ thống . Chỉnh sửa bằng `sudo nano /etc/crontab`. Ngoài ra, thư mục như `/etc/cron.d/` cho job cụ thể của package.

- **Crontab Người Dùng**: File theo từng người dùng, chỉnh sửa bằng `crontab -e` (không cần sudo cho file của bạn). Không có trường "user"; chạy dưới quyền người dùng chỉnh sửa. Lưu ở `/var/spool/cron/crontabs/username`. Lý tưởng cho script cá nhân.

Cả hai dùng định dạng giống nhau nhưng khác về phạm vi và quyền hạn.

### Tại Sao Crontab Chỉ Chạy Mỗi Phút Một Lần Và Không Phải Mỗi Giây

Độ chi tiết của Cron bị giới hạn ở phút theo thiết kế, theo chuẩn POSIX để tương thích và hiệu quả. Daemon cron (cron hoặc crond) thức dậy mỗi phút để kiểm tra và thực thi job, tránh polling liên tục có thể làm quá tải hệ thống. Lý do lịch sử bắt nguồn từ Vixie cron (triển khai phổ biến), ngủ 60 giây giữa các lần kiểm tra.

Đối với nhiệm vụ dưới phút, các lựa chọn thay thế bao gồm:
- Script với vòng lặp và `sleep` (ví dụ: job cron mỗi phút chạy script lặp với `sleep 10` cho khoảng cách 10 giây).
- Công cụ như `systemd timers` (hỗ trợ giây) hoặc `fcron` (độ chi tiết mịn hơn).
- Không dùng cron cho nhu cầu thời gian thực; dùng daemon hoặc hệ thống dựa trên sự kiện.

Điều này ngăn lãng phí tài nguyên cho kiểm tra thường xuyên.
## 2. Cú pháp cơ bản

### 2.1. Cú pháp trong file user crontab

Một dòng cơ bản:

```
* * * * * command_to_run
```

Các trường là:

```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of week (0 - 7) (Sun=0 or 7)
# │ │ │ │ │
# │ │ │ │ │
# * * * * * command
```

**Ví dụ:**

* Chạy script `/home/user/backup.sh` lúc 3:30 sáng mỗi ngày:

```
30 3 * * * /home/user/backup.sh
```

---

### 2.2. Dấu đặc biệt

* `*` → mọi giá trị.
* `,` → liệt kê nhiều giá trị. Ví dụ: `1,15` → ngày 1 và 15.
* `-` → khoảng. Ví dụ: `1-5` → từ thứ Hai đến thứ Sáu.
* `/` → bước nhảy (step). Ví dụ: `*/10` trong phút → mỗi 10 phút.
* `@` → alias cho một số lịch trình phổ biến:

| Alias       | Tương đương       |
| ----------- | ----------------- |
| `@reboot`   | Khi khởi động máy |
| `@yearly`   | 0 0 1 1 \*        |
| `@annually` | 0 0 1 1 \*        |
| `@monthly`  | 0 0 1 \* \*       |
| `@weekly`   | 0 0 \* \* 0       |
| `@daily`    | 0 0 \* \* \*      |
| `@midnight` | 0 0 \* \* \*      |
| `@hourly`   | 0 \* \* \* \*     |

**Ví dụ:**

```
@reboot /home/user/startup.sh
```

---

### 2.3. System crontab (ví dụ `/etc/crontab`)

Khác với user crontab, **có thêm trường user**:

```
minute hour day month day_of_week user command
```

**Ví dụ:**

```
0 5 * * * root /usr/local/bin/system_backup.sh
```

Chạy lúc 5:00 sáng mỗi ngày với quyền `root`.

---

### 2.4. Comment

* Bắt đầu bằng `#` → dòng chú thích.
  Ví dụ:

```
# Đây là crontab của user danglol240
```

---

## 3. Quản lý crontab

| Lệnh                     | Chức năng                                  |
| ------------------------ | ------------------------------------------ |
| `crontab -e`             | Chỉnh sửa crontab của user hiện tại        |
| `crontab -l`             | Liệt kê crontab của user hiện tại          |
| `crontab -r`             | Xóa crontab của user hiện tại              |
| `crontab -u username -l` | Liệt kê crontab của user khác (cần root)   |
| `crontab -u username -e` | Chỉnh sửa crontab của user khác (cần root) |

---
## 4. Use cases đặc biệt

### 4.1. Chạy script nhiều lần trong 1 giờ

* Mỗi 10 phút:

```
*/10 * * * * /home/user/job.sh
```

### 4.2. Chạy script trong khoảng giờ nhất định

* Mỗi 5 phút từ 9h đến 17h:

```
*/5 9-17 * * * /home/user/job.sh
```

### 4.3. Chạy script vào các ngày cụ thể

* Mỗi thứ 2 và thứ 5:

```
0 12 * * 1,4 /home/user/midday.sh
```

### 4.4. Chạy khi khởi động hệ thống

```
@reboot /home/user/startup.sh
```
## 6. Lưu ý crontab

1. Kiểm tra log cron:

```
sudo journalctl -u cron
# hoặc
grep CRON /var/log/syslog
```

2. Chắc chắn script có **quyền thực thi** (`chmod +x script.sh`).
3. Sử dụng **đường dẫn tuyệt đối** cho mọi lệnh, tệp, biến môi trường.

Ok 👍 mình bổ sung phần **`cron.allow` / `cron.deny`** để bạn nắm đầy đủ về quản lý quyền chạy crontab.

---

# 📌 Quản lý quyền với `cron.allow` và `cron.deny`

## 1. Vị trí file

Trên hầu hết Linux distro, file quản lý quyền thường nằm ở:

* `/etc/cron.allow`
* `/etc/cron.deny`

(Nếu không có, bạn có thể tự tạo).

---

## 2. Cách hoạt động

* Nếu tồn tại file **`/etc/cron.allow`**
  → **Chỉ những user trong danh sách này mới được phép dùng `crontab -e`**.
  → Các user khác sẽ bị từ chối, kể cả khi không có trong `cron.deny`.

* Nếu **không có** `cron.allow` nhưng có `cron.deny`
  → **Tất cả user đều được phép**, trừ những user có tên trong `cron.deny`.

* Nếu **không có cả hai file**
  → Quy tắc mặc định tùy distro:

  * Trên Ubuntu/Debian: chỉ `root` mới được dùng crontab.
  * Trên CentOS/RHEL: tất cả user đều được phép.

---

## 3. Ví dụ

### Chỉ cho phép 2 user `alice` và `bob` dùng crontab:

```bash
/etc/cron.allow
alice
bob
```

### Chặn user `guest` và `test` khỏi dùng crontab:

```bash
/etc/cron.deny
guest
test
```

### Khi có cả 2 file

* `cron.allow` **ưu tiên hơn** `cron.deny`.
* Tức là nếu user **có trong `cron.allow`** thì chắc chắn được phép, bất kể `cron.deny`.
<img width="833" height="347" alt="allow+deny" src="https://github.com/user-attachments/assets/3c30d827-be77-45c4-91f7-13edf2a45631" />
---

## 4. Lưu ý

* File chỉ cần chứa **tên user**, mỗi dòng một tên.
* Không cần thêm mật khẩu hay shell.
* Sau khi chỉnh sửa, không cần restart cron, vì cron sẽ đọc lại mỗi khi có yêu cầu `crontab`.

---
