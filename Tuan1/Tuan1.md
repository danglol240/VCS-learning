# Bổ sung
## FS
### **Các Thành Phần Cốt Lõi**

Mọi filesystem đều hoạt động dựa trên các thành phần cấu trúc sau:

* **Superblock**: Chứa siêu dữ liệu (metadata) về toàn bộ filesystem, chẳng hạn như loại filesystem, kích thước tổng thể, số lượng khối dữ liệu, và vị trí của các cấu trúc quan trọng khác. Đây là bản ghi chính của filesystem.

* **Inode**: Viết tắt của "index node". Mỗi tệp và thư mục được đại diện bởi một inode. Inode chứa siêu dữ liệu về đối tượng đó, bao gồm:
    * Quyền sở hữu (user, group).
    * Quyền truy cập (đọc, ghi, thực thi).
    * Kích thước.
    * Các mốc thời gian (ngày tạo, ngày sửa đổi, ngày truy cập).
    * **Con trỏ** trỏ đến các khối dữ liệu (Data Blocks) chứa nội dung thực tế.
    * **Lưu ý**: Inode **không** chứa tên của tệp.

* **Data Blocks**: Là các đơn vị lưu trữ cơ bản trên đĩa cứng. Nội dung thực tế của các tệp được ghi vào các khối này.

* **Directory Entry (dentry)**: Là thành phần liên kết giữa **tên tệp** (mà con người đọc được) và **số inode** của nó. Một thư mục về bản chất là một tệp đặc biệt chứa một danh sách các `dentry` của các tệp và thư mục con bên trong nó.

### **Quy Trình Hoạt Động**

Đây là cách các thành phần trên phối hợp với nhau trong các hoạt động cơ bản.

#### **1. Tạo một tệp mới (`touch file.txt`)**
1.  Filesystem tìm một **inode** còn trống trong bảng inode.
2.  Nó ghi các siêu dữ liệu ban đầu (chủ sở hữu, quyền mặc định, thời gian tạo) vào inode này.
3.  Trong thư mục hiện tại, nó tạo ra một **dentry** mới. `dentry` này chứa tên tệp là `file.txt` và số hiệu của inode vừa được cấp phát.

#### **2. Ghi dữ liệu vào tệp**
1.  Filesystem sử dụng `dentry` để tìm ra **inode** tương ứng với tên tệp.
2.  Nó kiểm tra bản đồ không gian trống (free space bitmap) để tìm một **data block** còn trống.
3.  Dữ liệu của người dùng được ghi vào data block đó.
4.  Địa chỉ của data block này được ghi vào danh sách con trỏ bên trong **inode**.
5.  Các siêu dữ liệu trong inode (như kích thước tệp và thời gian sửa đổi) được cập nhật.

#### **3. Đọc một tệp**
1.  Filesystem duyệt qua cấu trúc thư mục để tìm **dentry** có tên tệp tương ứng.
2.  Từ `dentry`, nó lấy được số hiệu **inode**.
3.  Nó đọc inode để lấy danh sách các con trỏ trỏ đến các **data blocks**.
4.  Hệ thống đi đến địa chỉ của các data block trên đĩa, đọc nội dung và trả về cho ứng dụng của người dùng.

#### **4. Xóa một tệp (`rm file.txt`)**
1.  Filesystem tìm và **xóa `dentry`** có tên `file.txt` khỏi thư mục chứa nó. Việc này làm cho tên tệp biến mất khỏi danh sách.
2.  Nó truy cập vào **inode** của tệp và giảm "số lượng liên kết" (link count) đi 1.
3.  Nếu số lượng liên kết bằng 0 (nghĩa là không còn `dentry` nào trỏ đến inode này), filesystem sẽ:
    * Đánh dấu **inode** này là trống, sẵn sàng để tái sử dụng.
    * Đánh dấu tất cả các **data blocks** mà inode này trỏ tới là trống trong bản đồ không gian trống.
    * **Lưu ý**: Dữ liệu trong các data block không bị xóa ngay lập tức mà chỉ được đánh dấu là có thể ghi đè. Đây là lý do tại sao có thể khôi phục các tệp vừa bị xóa.
### Vấn đề umount lúc 1 tiến trình đang xử lý
* Tình huống: xuất hiện 1 tiến trình đọc ghi / có file descriptor cwd(current working directory) nằm ở bên trong khu vực cần unmount => target is busy
* Quy trình kill+umount: 
    1. Xác định tiến trình đang được xử lý ở bên trong vị trí cần umount bằng : `lsof` hoặc `fuser`
    2. Xác định xong sẽ tiến hành kill tiến trình đấy dựa trên PID
    3. Kiểm tra lại rồi tiến hành unmount
    <img width="1919" height="1153" alt="forcekill" src="https://github.com/user-attachments/assets/3c6114b2-57d7-49cb-ae7f-c848689cecd5" />
* Vấn đề về dữ liệu

## LVM
### Định nghĩa
Logical Volume (LV) là thành phần của Logical Volume Manager (LVM), dùng để quản lý dung lượng lưu trữ linh hoạt hơn so với phân vùng truyền thống. Nó hoạt động như một “phân vùng ảo” mà bạn có thể tạo, mở rộng, thu nhỏ, di chuyển, snapshot… mà không bị ràng buộc chặt chẽ vào kích thước cố định của phân vùng vật lý.
### Quy trình hoạt động
* LVM sẽ thêm 1 số bước nằm giữa sau khi phân vùng và trước khi gắn file system vào vùng nhớ
![LogicalVolumenManager](https://github.com/user-attachments/assets/03f28770-9757-41bf-b3b2-99c8d713f136)

1. Sau khi phân vùng sẽ phải thêm physical volume dựa trên các partition thông qua các lệnh như `pvcreate` `pvs`. Bản chất là gắn nhãn LVM lên partition đấy
<img width="645" height="144" alt="pvs" src="https://github.com/user-attachments/assets/ba76e258-a6c4-4263-9b95-96a35f867920" />

2. Tiếp theo sẽ là group các physical volume để tạo thành 1 vùng nhớ(ổ đĩa ảo) gọi là volume group thông qua các lệnh `vgcreate` `vgs`
3. Sau đấy sẽ là khởi tạo các logical volume dựa trên ổ đĩa ảo volume group thông qua các lệnh `lvcreate` `lvs`
<img width="1377" height="725" alt="lvs" src="https://github.com/user-attachments/assets/c97b7a0e-7e03-40d0-bb1d-f61b11bcec8b" />

### Mở rộng thu hẹp
1. Physical volume: Yêu cầu phải mở rộng partition trước khi mở rộng physical volume sau đó dùng lệnh `pvresize`
<img width="1273" height="201" alt="pvresize" src="https://github.com/user-attachments/assets/cb35f65d-5fed-4002-909b-09ac0ddcc40e" />

2. Volume group: bằng cách nhóm thêm các physical volume khác vào thông qua lệnh `vgextend` `vgremove`

3. Logical Volume: bằng cách sử dụng lệnh `lvextend` `lvreduce` => lượng bộ nhớ có thể sử dụng mở rộng ra hoặc thu hep phụ thuộc vào volume group mà logical volume này được tạo
<img width="910" height="478" alt="lvextend" src="https://github.com/user-attachments/assets/d2000514-d5f0-4cda-8066-2bc93d9e95f4" />

## Hard link and sym link
### Inode
`inode` (Index Node) là một cấu trúc dữ liệu của hệ thống file (filesystem) trên Linux/UNIX dùng để lưu trữ thông tin **siêu dữ liệu (metadata)** về tệp hoặc thư mục, **không chứa dữ liệu thực tế của tệp** và **không chứa tên tệp**.

### **Thông tin lưu trữ trong inode**

Một inode chứa các thông tin quan trọng sau:

* **Kiểu tệp (file type)**: Tệp thường, thư mục, thiết bị, symbolic link, socket, pipe...
* **Kích thước tệp (file size)**
* **Quyền truy cập (permissions)**: đọc, ghi, thực thi (rwx)
* **Chủ sở hữu (owner UID)**
* **Nhóm sở hữu (GID)**
* **Thời gian quan trọng**:

  * `atime` (Access time) – lần cuối tệp được đọc
  * `mtime` (Modify time) – lần cuối dữ liệu tệp thay đổi
  * `ctime` (Change time) – lần cuối metadata (như permission) thay đổi
* **Số lượng hard link trỏ đến inode**
* **Con trỏ đến các block dữ liệu thực tế** (data blocks)

### **Cách hoạt động của inode**

1. Khi tạo một tệp mới, hệ thống file sẽ:

   * Cấp một inode để lưu metadata.
   * Cấp các block dữ liệu (nếu có nội dung).
   * Lưu tên tệp trong thư mục cùng **chỉ số inode (inode number)** tương ứng.

2. Khi truy cập một tệp:

   * Hệ thống file đọc thư mục → lấy số inode từ tên tệp → tìm inode → từ inode lấy vị trí dữ liệu thực tế.

3. Khi xóa tệp:

   * Hệ thống chỉ giảm **số lượng hard link** trong inode.
   * Nếu số hard link = 0 → giải phóng inode và các block dữ liệu.
### Hard link
- Là **liên kết trực tiếp đến inode của file gốc**.
- Cả file gốc và hard link đều chia sẻ cùng inode.
- Xóa file gốc **không làm mất dữ liệu** nếu hard link còn tồn tại.
- Chỉ hoạt động trong cùng một filesystem.
<img width="595" height="155" alt="hardlink" src="https://github.com/user-attachments/assets/78e59164-74d5-4271-a578-ffb011fc9d6d" />

* E.g <img width="873" height="535" alt="hardlinkvd" src="https://github.com/user-attachments/assets/2816fd8b-e5e3-49a3-844f-73129963e762" />
## Symbolic link
* Là một file đặc biệt chứa đường dẫn đến file gốc (giống shortcut).
* Không chia sẻ inode với file gốc.
* Nếu file gốc bị xóa, symlink trở thành broken link.
* Có thể trỏ đến file hoặc thư mục, và có thể vượt qua filesystem khác.
<img width="628" height="300" alt="symlink" src="https://github.com/user-attachments/assets/d6555a77-0cd1-4441-8a6a-0f0251dbc395" />

* E.g  <img width="935" height="365" alt="symlinkvd" src="https://github.com/user-attachments/assets/5d5fa68b-6f52-4ddf-8b8a-29016176a8f6" />