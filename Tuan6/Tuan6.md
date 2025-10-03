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
| `r`    | Append thêm file mới                  |
| `delete`| Xóa file ở trong archive             | 
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
  * Ngoài ra còn 1 số option khác ví dụ nhu : `skip`,`seek`

* **Ứng dụng**: Clone ổ đĩa, kiểm tra tốc độ đọc/ghi, tạo swap file.

* Lưu ý : khi dd 1 ổ đĩa cần chú ý đến dung lượng nếu dd 1 ổ đĩa có dung lượng lớn hơn vào ổ đĩa nhỏ thì sẽ chỉ sao chép block đến khi ổ đĩa nhỏ đầy rồi dừng 
<img width="845" height="255" alt="dd" src="https://github.com/user-attachments/assets/f41a5507-20f9-4a60-8dfe-cc9544d58fbd" />
---

## 3. **Mirroring Data Between Systems: `rsync`, `scp`, `sftp`**

### **3.1. `rsync`**

* **Chức năng**:
  Công cụ đồng bộ dữ liệu giữa các thư mục/ máy tính với **khả năng sao chép tăng dần (incremental)** – chỉ truyền phần thay đổi.

* **Options**:
`rsync` có rất nhiều option, nhưng mình liệt kê cho bạn một số **hay dùng nhất và quan trọng nhất** nhé 👍

---

## 1. **Cơ bản**

* `-v` : verbose, hiển thị thông tin chi tiết.
* `-a` : archive mode (gồm `-rlptgoD`, giữ nguyên permission, owner, symlink, device, timestamp).
* `-r` : recursive (sao chép đệ quy thư mục).
* `-n` : dry-run (chạy thử, không thực sự copy, chỉ in ra sẽ làm gì).

---

## 2. **Đồng bộ và loại trừ**

* `--delete` : xóa file ở destination nếu không còn ở source.
* `--exclude=PATTERN` : bỏ qua file/thư mục theo pattern.
  → ví dụ: `--exclude="*.log"`
* `--exclude-from=FILE` : đọc danh sách exclude từ file.

---

## 3. **Nén**

* `-z` : nén dữ liệu khi truyền qua mạng.
* `--progress` : hiển thị tiến trình copy.

---

## 4. **Quyền và ownership**

* `-p` : giữ nguyên permission.
* `-o` : giữ nguyên owner.
* `-g` : giữ nguyên group.
* `-t` : giữ nguyên timestamp.
* `-l` : copy symlink như symlink.
* `-H` : giữ nguyên hardlink.

---

## 5. **Khác**

* `-e ssh` : truyền qua SSH (rất phổ biến).
* `--bwlimit=RATE` : giới hạn băng thông (KB/s).
  → ví dụ: `--bwlimit=1000` (giới hạn \~1MB/s).
---

* **Ví dụ**:

  ```bash
  rsync -avz /local/path user@remote:/remote/path
  ```

  * `a`: archive mode (giữ quyền, timestamp, symbolic link…)
  * `v`: verbose
  * `z`: nén khi truyền

* **Ứng dụng**: 
1. **Đồng bộ hóa file/thư mục**

   * Giữa **cùng máy** (local → local).
   * Giữa **2 máy khác nhau** (local ↔ remote) qua SSH hoặc daemon `rsync`.

2. **Sao lưu (backup)**

   * Giữ bản sao y hệt thư mục nguồn sang nơi khác.
   * Hỗ trợ **incremental backup** (chỉ copy phần thay đổi, tiết kiệm thời gian và băng thông).

3. **Truyền file hiệu quả**

   * Chỉ gửi **phần khác biệt** (delta transfer), không gửi toàn bộ file mỗi lần.

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

<img width="1059" height="174" alt="scp" src="https://github.com/user-attachments/assets/00b0c83f-3bb5-41f3-83f0-5c18a2cba530" />
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

<img width="1389" height="326" alt="sftp" src="https://github.com/user-attachments/assets/df37298c-8817-4151-88dd-a182bd4b733a" />

* **Ưu điểm**: Có thể duyệt thư mục, quản lý file.

* **Ứng dụng**: Truyền file qua mạng an toàn, thay thế FTP truyền thống.

# Khác biệt chi tiết

## 1) Giao thức & port

Cả `scp` và `sftp` đều dùng **kênh SSH** (tham chiếu qua SSH tunnel). Mặc định là port **22**. Về mặt mạng, giống nhau (một TCP connection tới SSH), nhưng `scp` thực thi thao tác copy bằng lệnh đơn giản, còn `sftp` khởi tạo một phiên SFTP (một “subsystem” trên SSH) để thực hiện nhiều lệnh file-level.

## 2) Cách dùng & tương tác

* `scp` rất đơn giản: một câu lệnh là copy xong. Ví dụ:

  ```bash
  scp localfile.txt user@remote:/path/
  scp -r dir/ user@remote:/path/
  scp -i ~/.ssh/id_rsa -P 2222 file user@host:/path/
  ```
* `sftp` có thể vào interactive shell:

  ```bash
  sftp user@remote
  sftp> ls
  sftp> cd /var/log
  sftp> put localfile
  sftp> get remotefile
  ```

  hoặc chạy non-interactive bằng batch:

  ```bash
  sftp -b batch.sh user@remote
  ```

## 3) Resume & reliability

* `scp` không có resume built-in. Nếu kết nối bị gián đoạn, bạn phải restart transfer.
* `sftp` có lệnh `reget`/`reput` (client hỗ trợ) để resume; nhiều client GUI SFTP cũng hỗ trợ resume.

## 4) Quản lý file & thao tác

* `scp` chỉ cho phép copy; không có `ls`/`rm`/`rename` (ngoại trừ dùng SSH chạy lệnh từ xa).
* `sftp` có bộ lệnh file-level giúp duyệt và quản lý trực tiếp trên server.

## 5) Hiệu năng

* Về hiệu năng thô, `scp` thường nhanh hơn cho copy đơn giản (ít protocol overhead).
* Tuy nhiên với các file lớn/ nhiều file, hiệu năng thực tế còn phụ thuộc vào implementation; nếu cần hiệu quả băng thông khi cập nhật nhiều file, **rsync over SSH** là lựa chọn tốt hơn (sinh delta, resume tốt).
---
# Khi nào dùng

* Dùng **`scp`** khi: copy đơn giản, nhanh, bạn chỉ cần 1 lệnh trong script để chuyển file.
* Dùng **`sftp`** khi: cần quản lý file từ xa (ls/cd/remove/rename), cần resume, hoặc muốn batch nhiều thao tác file.
* Nếu cần **synchronization/đồng bộ delta** (chỉ gửi phần khác nhau), dùng **`rsync -e ssh`** thay vì scp/sftp.