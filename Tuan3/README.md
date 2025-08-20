# Package Management
## Khái niệm cơ bản
### Mirror và Repo
* Mirror có thể hiểu là một máy chủ nhân bản có chứa bản sao của dữ liệu hay kho lưu trữ của server khác và được chạy ở trên một thiết bị khác với bản gốc mục đích là để : *Tăng tốc độ tải, Chia tải hoặc dùng làm Dự phòng*
* Repo hay Repository là kho lưu trữ các phần mềm, ứng dụng, tool tiện ích mà được duy trì và phát hành bởi một tổ chức cơ quan => Các công ty thường sẽ tự host một Mirror riêng, nội bộ(internal) nhằm mục đích bảo mật hoặc yêu cầu nhân viên sử dụng những package, yêu cầu về version cụ thể.
## 📦 APT và YUM
* APT và YUM đều là các công cụ dùng cho việc xử lý và quản lý các package của hệ thống , cả 2 đều cung cấp chứ năng tải, cập nhật, xóa các package 1 cách tự động điểm khác biệt chính nằm ở **distro** và **định dạng package**

| Feature              | **APT** (Debian/Ubuntu)                        | **YUM** (RHEL/CentOS)                          |
|----------------------|------------------------------------------------|------------------------------------------------|
| **Full Name**        | Advanced Package Tool                          | Yellowdog Updater, Modified                    |
| **Linux Family**     | Debian-based (Ubuntu, Mint, Kali, Debian)      | Red Hat-based (CentOS, Fedora, RHEL)          |
| **Package Format**   | `.deb`                                         | `.rpm`                                         |
| **Default Repos**    | `/etc/apt/sources.list`<br>`/etc/apt/sources.list.d/` | `/etc/yum.repos.d/*.repo`                |     |
| **Metadata Handling**| Uses local cache (after `apt update`)          | Downloads metadata each time, can be cached    |
| **Dependency Resolution** | Very strong, tightly integrated with dpkg | Also strong, resolves dependencies automatically |
| **Commands**         | `apt install`<br>`apt remove`<br>`apt update`<br>`apt upgrade` | `yum install`<br>`yum remove`<br>`yum update`<br>`yum upgrade` |
| **Underlying Tool**  | `dpkg` (for installing `.deb` directly)        | `rpm` (for installing `.rpm` directly)         |


## Cách Ubuntu/CentOS cấu hình mirror và repo
