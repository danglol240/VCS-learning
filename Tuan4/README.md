# System startup and Shutdown
## Booting
<img width="3000" height="3900" alt="linux-boot-process" src="https://github.com/user-attachments/assets/cc5554c7-02f4-4db3-9b01-09630720d59a" />

**1. Bật nguồn (Power On)**
* Đây là bước đầu tiên cung cấp điện cho máy tính.

**2. BIOS/UEFI**
* Sau khi có điện, phần mềm đầu tiên chạy là **BIOS** (Hệ thống xuất nhập cơ bản) hoặc **UEFI** (Giao diện phần mềm mở rộng hợp nhất) được lưu trên một con chip của bo mạch chủ.
* Nó thực hiện **POST (Power-On Self-Test)**: một bài kiểm tra nhanh để đảm bảo các phần cứng thiết yếu như RAM, CPU, bàn phím hoạt động bình thường.
* Sau đó, nó sẽ **Phát hiện các thiết bị (Detect Devices)** lưu trữ như ổ cứng (HDD/SSD), USB, v.v.

**3. Chọn thiết bị khởi động (Choose a Boot Device)**
* BIOS/UEFI sẽ tìm một thiết bị có khả năng khởi động (bootable) theo thứ tự ưu tiên đã được cấu hình từ trước.

**4. Bộ nạp khởi động GRUB (GRUB Boot Loader)**
* Khi đã tìm thấy thiết bị khởi động, BIOS/UEFI sẽ nạp và chuyển quyền điều khiển cho **Bộ nạp khởi động (Boot Loader)**, mà trong hầu hết các bản phân phối Linux hiện đại là **GRUB**.
* GRUB thực hiện các nhiệm vụ:
    * Đọc tệp cấu hình của nó (ví dụ: `/etc/grub2.cfg`) để biết vị trí của nhân Linux.
    * **Thực thi nhân (Execute kernel)**: Tải nhân Linux và `initramfs` (hệ thống tệp tạm thời trong RAM) vào bộ nhớ.
    * **Tải các thư viện được hỗ trợ (Load supported libraries)**.

**5. Thực thi `systemd`**
* Sau khi nhân (kernel) được tải và khởi tạo, nó sẽ khởi chạy tiến trình đầu tiên trong **không gian người dùng (user space)**. Tiến trình này luôn có PID (Process ID) là 1.
* Trong các hệ thống Linux hiện đại, tiến trình này là **`systemd`**. `systemd` chịu trách nhiệm khởi tạo phần còn lại của hệ thống.

**6. Chạy các tệp `.target` (Run .target Files)**
* `systemd` sử dụng các đơn vị (units) gọi là `.target` để quản lý và khởi động các dịch vụ theo nhóm. Một `.target` tương tự như `runlevel` trong các hệ thống cũ.
* Sơ đồ cho thấy `default.target` (mục tiêu mặc định) thường trỏ đến `multi-user.target` (hệ thống đa người dùng, không có giao diện đồ họa).
* `multi-user.target` lại phụ thuộc vào các target và service khác như `basic.target` (các dịch vụ cơ bản), `getty.target` (chuẩn bị màn hình đăng nhập terminal), và `ssh.service` (dịch vụ SSH). `systemd` sẽ khởi động chúng song song để tăng tốc độ.

**7. Chạy các Script khởi động (Run Startup Scripts)**
* Sau khi các dịch vụ hệ thống chính đã chạy, `systemd` và các dịch vụ khác sẽ chạy các script để thiết lập môi trường cho người dùng.
* Ví dụ:
    * `/systemd-logind`: Quản lý các phiên đăng nhập của người dùng.
    * `/etc/profile`: Script cấu hình môi trường chung cho tất cả người dùng.
    * `~/.bashrc`: Script cấu hình riêng cho shell của từng người dùng, được thực thi khi người dùng đó mở một terminal.

**8. Người dùng có thể đăng nhập (Users can login now)**
* Khi tất cả các dịch vụ cần thiết đã được khởi động và màn hình đăng nhập đã sẵn sàng (dù là giao diện dòng lệnh hay đồ họa), hệ thống đã hoàn tất quá trình khởi động và sẵn sàng để người dùng đăng nhập.

## SystemV và Systemd
### Difference

### SystemV and runlevel
### Systemd and Unit file
* /sbin/init và nó sẽ là chương trình đầu tiên được khởi động trong hệ thống (PID = 1)
<img width="719" height="181" alt="init-systemd" src="https://github.com/user-attachments/assets/9ae4a5ea-e8f0-4006-88f7-fa3dc67fe783" />

* Thành phần của systemd :
    - `systemctl` dùng để quản lý trạng thái của các dịch vụ hệ thống (bắt đầu, kết thúc, khởi động lại hoặc kiểm tra trạng thái hiện tại)
    - `journald` dùng để quản lý nhật ký hoạt động của hệ thống (hay còn gọi là ghi log)
    - `logind` dùng để quản lý và theo dõi việc đăng nhập/đăng xuất của người dùng
    - `networkd` dùng để quản lý các kết nối mạng thông qua các cấu hình mạng
    - `timedated` dùng để quản lý thời gian hệ thống hoặc thời gian mạng
    - `udev` dùng để quản lý các thiết bị và firmware

* Tất cả các chương trình được quản lý bởi systemd đều được thực thi dưới dạng daemon hay background bên dưới nền và được cấu hình thành 1 file configuration gọi là unit file và bao gồm 12 loại
    - service (các file quản lý hoạt động của 1 số chương trình)
    - socket (quản lý các kết nối)
    - device (quản lý thiết bị)
    - mount (gắn thiết bị)
    - automount (tự đống gắn thiết bị)
    - swap (vùng không gian bộ nhớ trên đĩa cứng)
    - target (quản lý tạo liên kết)
    - path (quản lý các đường dẫn)
    - timer (dùng cho cron-job để lập lịch)
    - snapshot (sao lưu)
    - slice (dùng cho quản lý tiến trình)
    - scope (quy định không gian hoạt động)
<img width="715" height="1147" alt="unit_files" src="https://github.com/user-attachments/assets/689cb4d5-5faa-44bf-8789-3d403aeb5c59" />

# Quản Lý Dịch Vụ Trên Ubuntu (Sử Dụng Systemd)

## Giới Thiệu
Ubuntu sử dụng **systemd** làm hệ thống khởi động và quản lý dịch vụ (init system) từ phiên bản 15.04 trở lên. Systemd thay thế cho các hệ thống cũ như Upstart hoặc SysV init. Các lệnh quản lý dịch vụ chủ yếu sử dụng `systemctl` (cho người dùng root hoặc với `sudo`).

Tài liệu này giải thích cách quản lý dịch vụ (thêm, sửa, xóa), các khái niệm như disable/mask/quản lý tại runtime, script khởi động/init, và quy trình tắt máy.

## Quản Lý Dịch Vụ (Add, Edit, Remove Services)

Dịch vụ trong systemd được định nghĩa bởi các tệp **unit file** (thường là `.service`) trong các thư mục như `/etc/systemd/system/` (cho tùy chỉnh) hoặc `/lib/systemd/system/` (cho hệ thống mặc định). Không nên chỉnh sửa tệp ở `/lib/` trực tiếp để tránh mất thay đổi khi cập nhật.

### Thêm Dịch Vụ (Add Service)
1. Tạo một tệp unit file mới trong `/etc/systemd/system/`, ví dụ: `sudo nano /etc/systemd/system/my-service.service`.
2. Nội dung cơ bản của tệp (ví dụ cho một dịch vụ đơn giản chạy script):
   ```
   [Unit]
   Description=My Custom Service
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/bin/my-script.sh
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```
   - **Description**: Mô tả dịch vụ.
   - **After**: Chạy sau các unit khác (ví dụ: sau khi mạng sẵn sàng).
   - **ExecStart**: Lệnh khởi chạy dịch vụ.
   - **WantedBy**: Mức chạy (runlevel) để khởi động tự động.
3. Tải lại systemd: `sudo systemctl daemon-reload`.
4. Kích hoạt để khởi động tự động: `sudo systemctl enable my-service`.
5. Khởi động dịch vụ: `sudo systemctl start my-service`.
<img width="1517" height="670" alt="testservice" src="https://github.com/user-attachments/assets/d82f5723-6a96-4a09-834f-ea3ef7571b65" />

### Sửa Dịch Vụ (Edit Service)
1. Chỉnh sửa tệp unit file: `sudo nano /etc/systemd/system/my-service.service` (hoặc override tệp gốc bằng cách tạo `/etc/systemd/system/my-service.service.d/override.conf` để chỉ thay đổi phần cần).
2. Tải lại systemd: `sudo systemctl daemon-reload`.
3. Khởi động lại dịch vụ để áp dụng thay đổi: `sudo systemctl restart my-service`.

### Xóa Dịch Vụ (Remove Service)
1. Dừng dịch vụ: `sudo systemctl stop my-service`.
2. Vô hiệu hóa khởi động tự động: `sudo systemctl disable my-service`.
3. Xóa tệp unit file: `sudo rm /etc/systemd/system/my-service.service` (và thư mục override nếu có).
4. Tải lại systemd: `sudo systemctl daemon-reload`.

## Disable, Mask Và Quản Lý Dịch Vụ Tại Runtime

### Disable Service
- **Ý nghĩa**: Ngăn dịch vụ khởi động tự động khi boot máy, nhưng vẫn có thể khởi động thủ công.
- **Lệnh**: `sudo systemctl disable service-name` (ví dụ: `sudo systemctl disable apache2`).
- **Hoàn tác**: `sudo systemctl enable service-name`.

### Mask Service
- **Ý nghĩa**: "Che giấu" dịch vụ hoàn toàn, ngăn chặn việc khởi động (thậm chí thủ công). Hữu ích để vô hiệu hóa dịch vụ hệ thống không mong muốn. Tạo liên kết tượng trưng đến `/dev/null`.
- **Lệnh**: `sudo systemctl mask service-name` (ví dụ: `sudo systemctl mask mysql`).
- **Hoàn tác**: `sudo systemctl unmask service-name`.

### Quản Lý Dịch Vụ Tại Runtime (Không Cần Khởi Động Lại Máy)
- **Khởi động**: `sudo systemctl start service-name`.
- **Dừng**: `sudo systemctl stop service-name`.
- **Khởi động lại**: `sudo systemctl restart service-name`.
- **Tải lại cấu hình (nếu hỗ trợ)**: `sudo systemctl reload service-name` (không dừng dịch vụ).
- **Kiểm tra trạng thái**: `sudo systemctl status service-name` (hiển thị log, PID, lỗi).
- **Liệt kê tất cả dịch vụ**: `systemctl list-units --type=service` (hoặc `--all` để xem cả inactive).
- **Liệt kê dịch vụ khởi động tự động**: `systemctl list-unit-files --type=service`.

## Startup / Init Script

### Startup (Khởi Động Hệ Thống)
- **Systemd là init process** (PID 1): Khi kernel boot, nó khởi chạy systemd làm tiến trình đầu tiên. Systemd quản lý các "target" (tương đương runlevel cũ như multi-user.target cho chế độ đa người dùng).
- **Quy trình startup**:
  1. Kernel tải systemd.
  2. Systemd đọc các unit file từ `/lib/systemd/system/` và `/etc/systemd/system/`.
  3. Khởi chạy các dịch vụ theo thứ tự phụ thuộc (dependencies).
  4. Đạt đến target mặc định (thường là `graphical.target` cho desktop hoặc `multi-user.target` cho server).

### Init Script
- **Trong systemd**: Không còn script init kiểu cũ. Thay vào đó là unit file (.service, .target, v.v.) viết bằng cú pháp đơn giản (INI-style).
- **Legacy init script**: Ubuntu vẫn hỗ trợ các script cũ ở `/etc/init.d/` (ví dụ: `/etc/init.d/apache2 start`). Systemd tạo wrapper tự động qua `systemd-sysv-generator`.
- **Ví dụ init script cũ** (SysV style):
  ```
  #!/bin/sh
  ### BEGIN INIT INFO
  # Provides:          my-service
  # Required-Start:    $remote_fs $syslog
  # Required-Stop:     $remote_fs $syslog
  # Default-Start:     2 3 4 5
  # Default-Stop:      0 1 6
  ### END INIT INFO

  case "$1" in
    start)
      # Lệnh khởi động
      ;;
    stop)
      # Lệnh dừng
      ;;
  esac
  ```
- Để sử dụng: `sudo /etc/init.d/my-service start`, nhưng khuyến nghị chuyển sang unit file systemd.

## Quy Trình Tắt Máy (Shutdown Process)

Quy trình tắt máy trên Ubuntu được quản lý bởi systemd để đảm bảo an toàn, tránh mất dữ liệu.

### Lệnh Tắt Máy
- **Tắt máy ngay**: `sudo shutdown -h now` hoặc `sudo systemctl poweroff`.
- **Khởi động lại**: `sudo shutdown -r now` hoặc `sudo systemctl reboot`.
- **Lên lịch**: `sudo shutdown -h 10` (tắt sau 10 phút).
- **Hủy**: `sudo shutdown -c`.

### Các Bước Trong Quy Trình Shutdown
1. **Nhận lệnh shutdown**: Từ `shutdown` hoặc `systemctl`, gửi tín hiệu đến systemd (PID 1).
2. **Gửi tín hiệu đến các tiến trình**: Systemd gửi SIGTERM đến tất cả tiến trình để chúng tự dừng gracefully (lưu dữ liệu, đóng kết nối).
3. **Chờ timeout**: Nếu tiến trình không dừng trong thời gian mặc định (thường 90 giây), gửi SIGKILL để buộc dừng.
4. **Dừng dịch vụ**: Systemd dừng các unit theo thứ tự ngược (dựa trên dependencies), ví dụ: dừng network sau các dịch vụ phụ thuộc nó.
5. **Unmount filesystem**: Ngắt kết nối các ổ đĩa, sync dữ liệu để tránh hỏng.
6. **Remount read-only**: Đặt filesystem root thành chỉ đọc.
7. **Tắt nguồn**: Kernel gọi ACPI để tắt phần cứng (power off) hoặc reboot.
8. **Log**: Toàn bộ quy trình được ghi log trong `/var/log/syslog` hoặc dùng `journalctl` để xem.
<img width="1109" height="585" alt="shutdown" src="https://github.com/user-attachments/assets/fb2449cf-ab01-45fb-aa9c-4389740286af" />

## Lưu Ý
- Luôn dùng `sudo` cho các lệnh hệ thống.
- Kiểm tra log với `journalctl -u service-name` để debug dịch vụ.
- Nếu dùng hệ thống cũ (pre-Ubuntu 15.04), có thể dùng SysV init, nhưng systemd là chuẩn hiện đại.