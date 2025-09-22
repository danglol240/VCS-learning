## 1. **Archiving with `tar`**

* **Chức năng**:
  `tar` (tape archive) được dùng để gom nhiều tệp/thư mục lại thành **một file duy nhất (archive)**, giúp dễ quản lý, sao lưu, hoặc truyền tải. `tar` có thể chỉ tạo archive hoặc kết hợp nén bằng các công cụ như `gzip` (`.tar.gz`), `bzip2` (`.tar.bz2`), hoặc `xz` (`.tar.xz`).

* **Ví dụ**:
| Option | Ý nghĩa                               |
| ------ | ------------------------------------- |
| `c`    | Create archive (tạo archive)          |
| `x`    | Extract archive (giải nén)            |
| `t`    | List nội dung archive                 |
| `v`    | Verbose – hiển thị chi tiết           |
| `f`    | File – chỉ định tên archive           |
| `z`    | Nén bằng gzip (`.tar.gz`)             |
| `j`    | Nén bằng bzip2 (`.tar.bz2`)           |
| `J`    | Nén bằng xz (`.tar.xz`)               |
| `C`    | Chuyển thư mục trước khi nén/giải nén |

* **Ứng dụng**: Sao lưu dữ liệu, đóng gói phần mềm, chuyển dữ liệu qua mạng.

* Lưu ý
Về đường dẫn tar sẽ tự động bỏ dấu / đầu tiên và giữ nguyên cấu trúc thư mục dựa trên đường dẫn
<img width="938" height="392" alt="tar" src="https://github.com/user-attachments/assets/bfa78b20-ae35-46e0-82d5-c21e40bf2d2c" />
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

* **Ứng dụng**: Clone ổ đĩa, kiểm tra tốc độ đọc/ghi, tạo swap file.

* Lưu ý : khi dd 1 ổ đĩa cần chú ý đến dung lượng nếu dd 1 ổ đĩa có dung lượng lớn hơn vào ổ đĩa nhỏ thì sẽ chỉ sao chép block đến khi ổ đĩa nhỏ đầy rồi dừng 
<img width="845" height="255" alt="dd" src="https://github.com/user-attachments/assets/f41a5507-20f9-4a60-8dfe-cc9544d58fbd" />
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
<img width="910" height="630" alt="incremental" src="https://github.com/user-attachments/assets/a7538d81-cc3d-4e8b-a25f-d8bba6573541" />
---

* Lưu ý : 
khi để đường dẫn nếu rsync directories thì phải chú ý tới trailing slash (/) cuối cùng
<img width="1865" height="516" alt="trailing" src="https://github.com/user-attachments/assets/0eed9e6a-625e-43af-ad42-b9a6b3238f75" />

khi muốn giữ nguyên user-id group-id nếu bên đích không tồn tại userid đấy
<img width="1715" height="328" alt="testsource" src="https://github.com/user-attachments/assets/5630b767-8424-470a-9431-1bc658bbfd90" />

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
