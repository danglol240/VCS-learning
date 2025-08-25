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