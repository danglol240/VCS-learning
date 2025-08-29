# Process monitoring and Scheduling
## Process monitoring
### 1. Chạy tiến trình nền (background) và tiến trình tiền cảnh (foreground)
* **Background process**: Cho phép tiến trình chạy song song mà không chiếm quyền điều khiển terminal.

  ```bash
  command &
  ```

  Ví dụ:

  ```bash
  sleep 100 &
  ```
* **Foreground process**: Tiến trình chạy chiếm quyền điều khiển terminal.
  ```bash
  fg %job_number
  ```

  Ví dụ:

  ```bash
  fg %1
  ```
* **Chuyển tiến trình đang chạy sang background**:
  * Nhấn `Ctrl+Z` để tạm dừng tiến trình (chuyển sang trạng thái stopped).
  * Dùng `bg` để tiếp tục tiến trình ở background:

    ```bash
    bg %job_number
    ```
* **Xem danh sách jobs**:
  ```bash
  jobs
  ```
---

### 2. `nohup` Command

* **Mục đích**: Giữ tiến trình chạy kể cả khi thoát khỏi terminal (ngăn nhận SIGHUP).

  ```bash
  nohup command &
  ```
* Output mặc định ghi vào `nohup.out` nếu không chuyển hướng.

---

### 3. `kill` Command & Signals

* **Gửi tín hiệu tới tiến trình**:

  ```bash
  kill -SIGNAL PID
  ```

  hoặc

  ```bash
  kill -9 1234
  ```

* **Các tín hiệu thường gặp**:

  * `SIGINT` (2): Ngắt tiến trình từ terminal (`Ctrl+C`).
  * `SIGTERM` (15): Yêu cầu kết thúc tiến trình **một cách an toàn** (default).
  * `SIGKILL` (9): Buộc tiến trình dừng ngay lập tức (không thể bị chặn).

---

## Cron

### 1. System Crontab vs User Crontab

* **System crontab**:

  * File: `/etc/crontab`
  * Chạy các tác vụ hệ thống, có thêm trường `user` để chỉ định ai sẽ chạy.
  * Ví dụ:

    ```
    * * * * * root /path/to/script.sh
    ```

* **User crontab**:

  * Quản lý bằng `crontab -e` cho từng user.
  * Không có trường `user` trong file.

---

### 2. Tại sao crontab chỉ chạy tối thiểu 1 phút?

* Cron daemon mặc định **quét mỗi phút một lần**, nên không thể lập lịch nhỏ hơn 1 phút.
* Nếu cần chạy với độ chính xác giây, dùng:

  * `systemd timers`
  * `watch`
  * vòng lặp `sleep 1`

---

### 3. Crontab Command Options

* `crontab -e`: Sửa crontab của user hiện tại.
* `crontab -l`: Liệt kê crontab của user.
* `crontab -r`: Xóa crontab của user.
* `crontab -u <user>`: Quản lý crontab của user khác (yêu cầu quyền root).

---

### 4. Chạy process với Cron

Ví dụ: Chạy script `/home/user/backup.sh` mỗi ngày lúc 2 giờ sáng:

```
0 2 * * * /home/user/backup.sh
```

---

### 5. Lịch biểu Cron (Cron Schedule)

Cú pháp:

```
* * * * * command_to_run
- - - - -
| | | | |
| | | | +---- Thứ trong tuần (0–7, 0/7 = Chủ nhật)
| | | +------ Tháng (1–12)
| | +-------- Ngày trong tháng (1–31)
| +---------- Giờ (0–23)
+------------ Phút (0–59)
```

Ví dụ:

* `* * * * *`: Mỗi phút
* `*/5 * * * *`: Mỗi 5 phút
* `0 6 * * 1-5`: 6h sáng từ Thứ 2 đến Thứ 6

---

Bạn có muốn tôi viết thêm:

1. **Cách debug cron không chạy (log ở đâu, mail output)**,
2. **Minh họa ví dụ kết hợp nohup + cron**,
3. Hay **so sánh cron với systemd timer**?

Bạn muốn tôi làm thành **cheat sheet tóm tắt nhanh** hay **bản đầy đủ kiểu hướng dẫn thực hành?**
