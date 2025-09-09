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
  Ví dụ: `nohup ./script.sh > output.log 2>&1 &` – Chạy script, chuyển hướng stdout/stderr sang log, và chạy nền.
  <img width="1102" height="581" alt="nohup" src="https://github.com/user-attachments/assets/38ba52ca-a0d3-4665-8106-959ca779bfae" />


- **Trường Hợp Sử Dụng**:
  - **Phiên Làm Việc Từ Xa (SSH)**: Chạy nhiệm vụ dài trên server mà không bị dừng khi ngắt kết nối. Ví dụ: `nohup wget file.url &` – Tải tiếp tục sau khi logout ở background.
  - **Xử Lý Hàng Loạt**: Dành cho script mất hàng giờ/ngày (ví dụ: sao lưu dữ liệu, biên dịch) mà không cần terminal mở.
  - **Hành Vi Giống Daemon**: Mô phỏng tiến trình liên tục mà không cần daemon hóa đầy đủ (mặc dù `systemd` hoặc `screen` tốt hơn cho dịch vụ).
  - **Xử Lý Lỗi**: Ghi lại output ngay cả khi phiên kết thúc, hữu ích để debug công việc từ xa.

Lưu Ý: `nohup` không biến tiến trình thành daemon; kết hợp với `disown` (`disown %1`) để loại khỏi bảng job của shell.

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

Cron là công cụ lập lịch dựa trên thời gian cho các nhiệm vụ định kỳ.

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

### Các Tùy Chọn Lệnh Crontab

`crontab` quản lý crontab người dùng. Chạy không root cho cấp độ người dùng.

- `-e`: Chỉnh sửa crontab (mở trong editor mặc định như nano/vi).
- `-l`: Liệt kê các entry crontab hiện tại.
- `-r`: Xóa (delete) crontab.
- `-u user`: Chỉ định người dùng (chỉ root, ví dụ: `sudo crontab -u username -e`).

Ví dụ: `crontab -l` hiển thị job lập lịch của bạn.

### Cách Chạy Tiến Trình Với Cron

Thêm entry vào crontab để thực thi lệnh/script theo khoảng thời gian.

1. Chỉnh sửa: `crontab -e`
2. Thêm dòng: `phút giờ ngày-tháng tháng ngày-tuần /đường/dẫn/command-or-script args`
3. Lưu và thoát; cron cài đặt tự động.

<img width="1095" height="623" alt="crontab" src="https://github.com/user-attachments/assets/a0887665-c9c0-4deb-a696-d6281de88d2a" />

### Cách Lập Lịch (Định Dạng Crontab và Ví Dụ)

Entry crontab theo: `m h dom mon dow command`
- `m`: Phút (0-59)
- `h`: Giờ (0-23)
- `dom`: Ngày tháng (1-31)
- `mon`: Tháng (1-12 hoặc tên như JAN)
- `dow`: Ngày tuần (0-7, 0/7=Chủ Nhật, hoặc tên như MON)
- Đặc biệt: `*` (bất kỳ), `*/5` (mỗi 5), `1-5` (phạm vi), `0,15,30,45` (danh sách)

Ví dụ:
- Mỗi phút: `* * * * * command`
- Mỗi 5 phút: `*/5 * * * * command`
- Ngày thường 9 AM: `0 9 * * 1-5 command`
- Ngày 1 hàng tháng lúc nửa đêm: `0 0 1 * * command`
- Khởi động lại: `@reboot command` (chạy khi khởi động)
