# Trong đây sẽ nói về cách tạo 1 Web server để các máy khác có thể tự download package mà không cần kết nối mạng (LAN,OFFLINE)

## 1. **APT-Mirror là gì?**

`apt-mirror` là công cụ giúp **tải về toàn bộ hoặc một phần kho APT của Ubuntu/Debian** và lưu trữ cục bộ. Sau đó, kho này có thể:

* Được chia sẻ qua HTTP/HTTPS/FTP (thường dùng Apache2/Nginx),
* Hoặc mang đi bằng ổ cứng/USB để phục vụ cài đặt và cập nhật **offline**.

---

## 2. **Khi nào nên dùng APT-mirror?**

* Môi trường có **nhiều máy không ra Internet**, chỉ dùng mạng LAN.
* Cần **kiểm soát phiên bản gói** (ví dụ: server sản xuất).
* Muốn **tiết kiệm băng thông Internet** (chỉ tải một lần, dùng nhiều lần).
* Phục vụ **Ubuntu/Debian LTS lâu dài**.

---

## 3. **Cài đặt APT-mirror**

### Trên Ubuntu/Debian có Internet:

```bash
sudo apt update
sudo apt install apt-mirror apache2
```

* `apt-mirror`: tải và đồng bộ kho.
* `apache2`: (tuỳ chọn) dùng làm web server để chia sẻ mirror qua LAN.

## 4. **Cấu hình APT-mirror**

File cấu hình: `/etc/apt/mirror.list`

Ví dụ cho Ubuntu 24.04 LTS (Noble):

<img width="829" height="492" alt="mirrorlist" src="https://github.com/user-attachments/assets/3c23c314-09ee-44f1-b3fb-bab25cc969a0" />
*Hình 1: file `/etc/apt/mirror.list`

**Giải thích:**

* `base_path`: Thư mục lưu trữ dữ liệu mirror.
* `nthreads`: Số luồng tải đồng thời.
* `defaultarch`: Giới hạn kiến trúc
* `deb` `deb-src`: Binary package 
* `clean`: Xoá gói cũ, tiết kiệm dung lượng.

---

## 5. **Chạy APT-mirror**

```bash
sudo apt-mirror
```

* Lần đầu sẽ tải khá lâu (vài GB → hàng trăm GB tuỳ cấu hình).
* Dữ liệu tải về nằm tại:

  ```
  /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu
  ```
<img width="1919" height="1060" alt="aptmirror" src="https://github.com/user-attachments/assets/723bdb30-1782-4731-b9da-1b2b7cd6fa15" />
*Hình 2: Apt-mirror
---

## 6. **Chia sẻ Mirror qua LAN (tùy chọn)**

### Dùng Apache2:

1. Tạo symlink:

   ```bash
   sudo ln -s /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu /var/www/html/ubuntu
   sudo systemctl restart apache2
   ```
2. Kiểm tra bằng trình duyệt từ máy khác:

   ```
   http://<IP_mirror>/ubuntu
   ```
<img width="1919" height="868" alt="localapachemirror" src="https://github.com/user-attachments/assets/29e20db1-503b-4aef-87ff-2ff06cb680fc" />
*Hình 3: mirror được dựng bằng apache2 web server

### Không dùng Apache (chỉ USB/file):

* Copy toàn bộ `/var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu` sang USB/ổ cứng.

---

## 7. **Cấu hình client (máy không có Internet)**

Tạo file `/etc/apt/sources.list.d/mirror.sources` (Ubuntu 24.04):

```text
Types: deb
URIs: http://<IP_mirror>/ubuntu
Suites: noble noble-updates noble-security
Components: main restricted universe multiverse
Signed-By: none
```

Cập nhật:

```bash
sudo apt update
sudo apt install <tên_gói>
```
<img width="1919" height="1149" alt="update" src="https://github.com/user-attachments/assets/fb5fbad6-228b-4c08-81bb-02821225ffcd" />
*Hình 4: Update APT không cần mạng
---

## 8. **Bảo trì và cập nhật mirror**

* Chạy thủ công:

  ```bash
  sudo apt-mirror
  ```
* Tự động hóa bằng cron:

  ```bash
  sudo nano /etc/cron.d/apt-mirror
  ```

  Nội dung mẫu:

  ```
  0 3 * * * root /usr/bin/apt-mirror > /var/spool/apt-mirror/var/cron.log
  ```

---

## 9. **Tối ưu dung lượng**

* Chỉ tải `main restricted` nếu không cần `universe multiverse`.
* Giới hạn kiến trúc:

  ```
  set defaultarch  amd64
  ```
* Không tải source code (`deb-src`).
* Dọn gói cũ bằng `clean`.

Dung lượng tham khảo:

* **Chỉ main+restricted+amd64**: \~15–25 GB.
* **Full components + source**: >500 GB.

---

## 10. **Xử lý sự cố thường gặp**

* **Kho cũ bị xoá (ví dụ Kinetic 22.10)**:
  → Dùng `old-releases.ubuntu.com`.
* **Lỗi 404 khi tải**:
  → Kiểm tra `Suites` (noble, jammy…), URL có đúng không.
* **Quá nhiều dung lượng (vài trăm GB)**:
  → Chỉ định `defaultarch` và loại bỏ `deb-src`.

---

## 11. **So sánh APT-mirror với các giải pháp khác**

* **apt-offline**: phù hợp máy đơn, không cần server.
* **aptly**: mirror chuyên nghiệp hơn, hỗ trợ snapshot, publish, GPG.
* **apt-cacher-ng**: caching proxy, không tải toàn bộ kho, chỉ cache gói được yêu cầu.

## Lưu ý : Vẫn có thể sử dụng apt-offline nhưng nếu muốn setup thì chỉ phù hợp cho việc update package đơn lẻ và khó cập nhật package hơn khi so với mirror