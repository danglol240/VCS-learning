Dưới đây là giải thích chi tiết về các chức năng mà bạn liệt kê:

---

## 1. **Archiving with `tar`**

* **Chức năng**:
  `tar` (tape archive) được dùng để gom nhiều tệp/thư mục lại thành **một file duy nhất (archive)**, giúp dễ quản lý, sao lưu, hoặc truyền tải. `tar` có thể chỉ tạo archive hoặc kết hợp nén bằng các công cụ như `gzip` (`.tar.gz`), `bzip2` (`.tar.bz2`), hoặc `xz` (`.tar.xz`).

* **Ví dụ**:

  * Tạo archive:

    ```bash
    tar -cvf backup.tar /path/to/files
    ```

    * `c`: create
    * `v`: verbose (hiển thị tiến trình)
    * `f`: filename (tên file archive)

  * Giải nén archive:

    ```bash
    tar -xvf backup.tar
    ```

  * Tạo và nén luôn:

    ```bash
    tar -czvf backup.tar.gz /path/to/files
    ```

    * `z`: nén bằng gzip

* **Ứng dụng**: Sao lưu dữ liệu, đóng gói phần mềm, chuyển dữ liệu qua mạng.

---

## 2. **Using the `dd` Command**

* **Chức năng**:
  `dd` là công cụ cấp thấp dùng để sao chép và chuyển đổi dữ liệu giữa các thiết bị hoặc file. Nó hoạt động ở mức byte/block, phù hợp để:

  * Tạo bản sao ổ đĩa (disk image).
  * Ghi ISO vào USB/CD.
  * Tạo file có kích thước cụ thể.
  * Sao lưu/khôi phục MBR (Master Boot Record).

* **Ví dụ**:

  * Tạo file 100MB:

    ```bash
    dd if=/dev/zero of=sample.img bs=1M count=100
    ```

    * `if`: input file (ở đây là `/dev/zero` tạo dữ liệu rỗng)
    * `of`: output file
    * `bs`: block size (1M = 1 megabyte)
    * `count`: số block

  * Sao chép ổ đĩa:

    ```bash
    dd if=/dev/sda of=/dev/sdb bs=4M status=progress
    ```

* **Ứng dụng**: Clone ổ đĩa, kiểm tra tốc độ đọc/ghi, tạo file test dung lượng lớn.

---

## 3. **Mirroring Data Between Systems: `rsync`, `scp`, `sftp`**

### **3.1. `rsync`**

* **Chức năng**:
  Công cụ đồng bộ dữ liệu giữa các thư mục/ máy tính với **khả năng sao chép tăng dần (incremental)** – chỉ truyền phần thay đổi.

* **Ưu điểm**: Nhanh hơn `scp` khi dữ liệu lớn và ít thay đổi. Hỗ trợ resume.

* **Ví dụ**:

  ```bash
  rsync -avz /local/path user@remote:/remote/path
  ```

  * `a`: archive mode (giữ quyền, timestamp, symbolic link…)
  * `v`: verbose
  * `z`: nén khi truyền

* **Ứng dụng**: Sao lưu dữ liệu định kỳ, mirror server.

---

### **3.2. `scp`**

* **Chức năng**:
  Copy file qua SSH. Hoạt động giống `cp` nhưng giữa hai máy.

* **Ví dụ**:

  ```bash
  scp file.txt user@remote:/path/to/destination
  ```

* **Ưu điểm**: Đơn giản, bảo mật nhờ SSH.

* **Nhược điểm**: Không hỗ trợ incremental copy.

---

### **3.3. `sftp`**

* **Chức năng**:
  Giao thức truyền file bảo mật (Secure File Transfer Protocol) dựa trên SSH. Cho phép tương tác như FTP nhưng bảo mật hơn.

* **Ví dụ**:

  ```bash
  sftp user@remote
  sftp> put localfile
  sftp> get remotefile
  ```

* **Ưu điểm**: Có thể duyệt thư mục, quản lý file, resume transfer.

* **Ứng dụng**: Truyền file qua mạng an toàn, thay thế FTP truyền thống.
