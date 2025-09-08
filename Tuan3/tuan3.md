# Package Management
## Mirror và Repo
* Mirror có thể hiểu là một máy chủ nhân bản có chứa bản sao của dữ liệu hay kho lưu trữ của server khác và được chạy ở trên một thiết bị khác với bản gốc mục đích là để : *Tăng tốc độ tải, Chia tải hoặc dùng làm Dự phòng*
* Repo hay Repository là kho lưu trữ các phần mềm, ứng dụng, tool tiện ích mà được duy trì và phát hành bởi một tổ chức cơ quan => Các công ty thường sẽ tự host một Mirror riêng, nội bộ(internal) nhằm mục đích bảo mật hoặc yêu cầu nhân viên sử dụng những package, yêu cầu về version cụ thể.

## Cách APT cấu hình mirror và repo
* APT lấy cấu hình của repository từ File chính: `/etc/apt/sources.list` Thư mục phụ: `/etc/apt/sources.list.d/*.list` (Trước khi chỉnh sửa cần lưu ý sao lưu trước khi thay đổi)
<img width="605" height="291" alt="aptsources" src="https://github.com/user-attachments/assets/aae27a77-4d98-402f-88cf-09a6930ba753" />

- **Thêm repo**: Sử dụng `sudo add-apt-repository "deb http://example.com/repo focal main"` (đối với PPA: `sudo add-apt-repository ppa:user/ppa-name`). Hoặc thêm thủ công vào `/etc/apt/sources.list` và chạy `sudo apt update`.
- **Sửa repo**: Chỉnh sửa dòng trong `/etc/apt/sources.list` (ví dụ: thay đổi URL mirror) và chạy `sudo apt update`.
- **Xóa repo**: Sử dụng `sudo add-apt-repository --remove "deb http://example.com/repo focal main"`, hoặc xóa tệp trong `/etc/apt/sources.list.d/`, sau đó chạy `sudo apt update`.

## Package
* Một gói là một tệp lưu trữ nén (định dạng `.deb` trong Ubuntu/Debian) chứa phần mềm, bao gồm các tệp thực thi, thư viện, tệp cấu hình và siêu dữ liệu. Nó đơn giản hóa việc cài đặt, quản lý và phân phối phần mềm.
* Các gói được sử dụng để cài đặt, cập nhật và xóa phần mềm một cách hiệu quả trong khi xử lý phụ thuộc, đảm bảo tính nhất quán hệ thống và cho phép kiểm soát phiên bản.

## Thông thường, một gói bao gồm:
- Binary files (tệp thực thi và thư viện).
- Configuration files
- Tài liệu (trang man, README).
- metadata (tên, phiên bản, phụ thuộc, thông tin người duy trì, checksum).
- Các script trước/sau cài đặt (cho các tác vụ thiết lập/dọn dẹp).
- Danh sách tệp và quyền truy cập

* Package Dependency là các gói khác cần thiết để một gói hoạt động. APT tự động giải quyết và cài đặt chúng để tránh xung đột hoặc phần mềm bị hỏng


## APT và dpkg
-   **dpkg**: Công cụ cấp thấp (low-level) để cài đặt, gỡ bỏ và quản lý
    các gói `.deb`.
-   **apt**: Công cụ cấp cao (high-level) dùng để quản lý gói, phụ
    thuộc, và kho lưu trữ, dựa trên `dpkg`.

### So sánh dpkg và APT

| Tiêu chí               | dpkg                                | APT (Advanced Package Tool)                   |
|-------------------------|-------------------------------------|-----------------------------------------------|
| **Mục đích**            | Low-level package manager           | High-level package management tool            |
| **Chức năng**           | Cài đặt, Gỡ bỏ, Chỉnh sửa các package `deb` một cách trực tiếp | Quản lý gói, tự động xử lý phụ thuộc |
| **Xử lý dependency**| Phải xử lý phụ thuộc 1 cách trực tiếp | Tự động tải và xử lý phụ thuộc cần thiết |
| **Phạm vi xử lý**        | Sử dụng cho các package đơn lẻ   | Sử dụng cho toàn bộ hệ thống       |

## Một số câu lệnh chính
* Show dependencies: `apt depends` `apt rdepends`
* Kiểm tra thuộc package nào : dùng `dpkg -S` hoặc `apt-file search`
* Hiển thị thông tin package : `apt show`
* List file trong 1 packge : dùng `dpkg -L` hoặc `apt-file list`
* Search : `apt search` hoặc `apt-file search`
* Download : `sudo apt install`
* Remove : `sudo apt remove`(keep conf files) `sudo apt purge`(no keep) `sudo apt autoremove`(remove unused dependencies)
* Upgrade : `sudo apt update`(update repo cache) `sudo apt upgrade`(upgrade installed packages)/`sudo apt full-upgrade`
* List toàn bộ hoặc đã tải : `apt list` hoặc `dpkg -l`


## **1. Trường trong kho APT (sources.list hoặc .sources)**

### Định dạng cũ (`/etc/apt/sources.list`)
Ví dụ:

```
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
```

* `deb`: Loại repository (binary package). Có thể là `deb-src` (source code).
* `http://archive.ubuntu.com/ubuntu`: Địa chỉ kho.
* `noble`: Phiên bản (codename: 24.04 LTS).
* `main restricted universe multiverse`: Components.

### Định dạng mới (Ubuntu ≥ 24.04, `.sources`)

Ví dụ:

```
Types: deb
URIs: http://archive.ubuntu.com/ubuntu
Suites: noble noble-updates noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

* `Types`: Loại kho (`deb`, `deb-src`).
* `URIs`: URL của kho.
* `Suites`: Danh sách bản phát hành (release, updates, security...).
* `Components`: Thành phần.
* `Signed-By`: Khóa GPG dùng để xác thực.

---

## **2. Trường trong metadata gói (`Packages`, `Sources`)**

Ví dụ (`Packages`):

```
Package: bash
Version: 5.2.21-1ubuntu1
Architecture: amd64
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Installed-Size: 3780
Depends: libc6 (>= 2.34), libtinfo6 (>= 6)
Description: GNU Bourne Again SHell
```

Các trường quan trọng:

* `Package`: Tên gói.
* `Version`: Phiên bản.
* `Architecture`: Kiến trúc (`amd64`, `i386`, `arm64`…).
* `Maintainer`: Người/bộ phận duy trì gói.
* `Installed-Size`: Dung lượng sau khi cài (KB).
* `Depends`: Gói bắt buộc.
* `Recommends`: Gói khuyến nghị.
* `Suggests`: Gói tùy chọn.
* `Conflicts`: Gói xung đột.
* `Description`: Mô tả.

## **4. Các thành phần (Components)**

* `main`: Phần mềm chính, được Canonical hỗ trợ.
* `restricted`: Phần mềm chính có giới hạn bản quyền (driver…).
* `universe`: Phần mềm cộng đồng duy trì (ít bảo đảm hỗ trợ).
* `multiverse`: Phần mềm có vấn đề về bản quyền, không đảm bảo hỗ trợ.

## **5. Các suites/phân phối (Suites)**

* `noble`: Kho chính (Ubuntu 24.04 LTS).
* `noble-updates`: Cập nhật thường xuyên.
* `noble-security`: Cập nhật bảo mật.
* `noble-backports`: Gói mới được backport.
* `noble-proposed`: Gói thử nghiệm.

# **Package Management (YUM/DNF – CentOS, RHEL, Fedora)**

## **Mirror và Repository**

* **Mirror**: Máy chủ nhân bản chứa bản sao của dữ liệu/kho lưu trữ gốc. Mục đích:

  * Tăng tốc độ tải.
  * Chia tải.
  * Dự phòng khi kho gốc gặp sự cố.
* **Repository (repo)**: Kho chứa các gói RPM được duy trì bởi nhà cung cấp (Red Hat, CentOS, EPEL…) hoặc nội bộ doanh nghiệp.

  * Các công ty thường tự host **repo nội bộ** để kiểm soát bảo mật, phiên bản và tính ổn định.

## **Cách YUM/DNF cấu hình mirror và repo**

* YUM/DNF lấy cấu hình từ:

  * Thư mục chính: `/etc/yum.repos.d/*.repo`
  * File cấu hình gốc: `/etc/yum.conf`
* Một repo được mô tả bằng file `.repo`, ví dụ:

```ini
[base]
name=CentOS-$releasever - Base
baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

**Các trường chính:**

* `[base]`: ID của repo.
* `name`: Tên repo.
* `baseurl`: Đường dẫn tới repo.
* `enabled`: 1 = bật, 0 = tắt.
* `gpgcheck`: Kiểm tra chữ ký GPG.
* `gpgkey`: Vị trí khóa GPG.

- **Thêm repo**:

  * Thủ công: Thêm file `.repo` vào `/etc/yum.repos.d/`.
  * Tự động: `sudo yum-config-manager --add-repo http://example.com/repo.repo`
- **Sửa repo**: Sửa trực tiếp file `.repo` hoặc dùng `yum-config-manager --enable/--disable`.
- **Xóa repo**: Xóa file `.repo` hoặc `yum-config-manager --remove-repo name`.

## **Package**

* Gói trên CentOS/RHEL sử dụng định dạng `.rpm`.
* Một gói bao gồm:

  * Binary files (tệp thực thi, thư viện).
  * Configuration files.
  * Documentation (README, man pages).
  * Metadata (tên, phiên bản, phụ thuộc…).
  * Script cài đặt/gỡ bỏ.
* **Dependency**: YUM/DNF sẽ tự động xử lý, tải và cài đặt các phụ thuộc.

## **YUM/DNF và rpm**

* **rpm**: Trình quản lý cấp thấp (low-level), cài đặt/gỡ bỏ trực tiếp `.rpm`.
* **yum/dnf**: Trình quản lý cấp cao (high-level), xử lý phụ thuộc, tương tác với repo.

### **So sánh rpm và YUM/DNF**

| Tiêu chí             | rpm                              | YUM/DNF                      |
| -------------------- | -------------------------------- | ---------------------------- |
| **Mục đích**         | Quản lý gói `.rpm` trực tiếp     | Quản lý gói và phụ thuộc     |
| **Xử lý dependency** | Không tự xử lý, cần cài thủ công | Tự động giải quyết phụ thuộc |
| **Nguồn dữ liệu**    | File `.rpm` cục bộ               | Repo từ xa hoặc nội bộ       |

## **Một số câu lệnh chính**

* **Hiển thị thông tin package**:

  * `yum info <pkg>` hoặc `dnf info <pkg>`
* **Tìm kiếm**:

  * `yum search <keyword>` hoặc `dnf search <keyword>`
* **Liệt kê file trong package**:

  * `rpm -ql <pkg>`
* **Xem package thuộc file nào**:

  * `rpm -qf <path_to_file>`
* **Cài đặt**:

  * `sudo yum install <pkg>` hoặc `sudo dnf install <pkg>`
* **Gỡ bỏ**:

  * `sudo yum remove <pkg>` hoặc `sudo dnf remove <pkg>`
* **Cập nhật hệ thống**:

  * `sudo yum update` / `sudo dnf update`
* **Chỉ tải mà không cài**:

  * `yumdownloader <pkg>`
* **Danh sách repo**:

  * `yum repolist all` hoặc `dnf repolist all`
* **Làm sạch cache**:

  * `sudo yum clean all` hoặc `sudo dnf clean all`

## **Trường trong metadata gói (RPM spec)**

Ví dụ (`rpm -qi bash`):

```
Name        : bash
Version     : 5.2.26
Release     : 2.el9
Architecture: x86_64
Summary     : The GNU Bourne Again shell
URL         : https://www.gnu.org/software/bash
License     : GPLv3+
Source RPM  : bash-5.2.26-2.el9.src.rpm
Build Date  : Mon 05 Feb 2024
Group       : System Environment/Shells
Packager    : Red Hat, Inc.
Vendor      : CentOS
Description : Bash is the GNU Project's shell...
```

Các trường chính:

* `Name`: Tên gói.
* `Version`, `Release`: Phiên bản và lần build.
* `Architecture`: Kiến trúc (`x86_64`, `aarch64`…).
* `Requires`: Gói bắt buộc.
* `Provides`: Khả năng cung cấp.
* `Conflicts`: Xung đột.
* `Obsoletes`: Gói bị thay thế.
* `Summary`, `Description`: Mô tả.

## **Repository Components và Channels**

Khác với Ubuntu (main, universe, multiverse…), CentOS/RHEL chia thành:

* `BaseOS`: Hệ thống cơ bản.
* `AppStream`: Ứng dụng, runtime, module streams.
* `Extras`: Gói bổ sung.
* `EPEL`: Extra Packages for Enterprise Linux (từ Fedora).

## **Các Channel (RHEL Subscription)**

* `rhel-8-for-x86_64-baseos-rpms`: Kho cơ bản.
* `rhel-8-for-x86_64-appstream-rpms`: Ứng dụng.
* `rhel-8-for-x86_64-supplementary-rpms`: Gói bổ trợ.

# Sử dụng dpkg
* Tải package apache2 chỉ sử dụng dpkg
1. Sử dụng lệnh apt-cache search để tìm kiếm xem có package apache2 chưa sau đó dùng lệnh apt show để check phiên bản
<img width="1394" height="565" alt="show" src="https://github.com/user-attachments/assets/b51156bb-930f-4646-8ba8-dff603b5e6bd" />

2. Khi dùng `dpkg -i` sẽ nhận thấy lỗi dependency
<img width="682" height="356" alt="dpkg" src="https://github.com/user-attachments/assets/7bdcfcfd-01d0-487e-9809-e5a3ad1400a9" />

2. Để lấy được package/package dependency thì sẽ dùng lệnh wget để lấy package `.deb` từ mirror
<img width="1141" height="1093" alt="pool" src="https://github.com/user-attachments/assets/f3f87fa7-5388-4273-91bb-3be1645500f2" />

3. Sau đấy sẽ dùng `dpkg -i` để tải về từ file .deb . Lưu ý phải tỉa các file phụ thuộc trước
<img width="921" height="1071" alt="pkg" src="https://github.com/user-attachments/assets/154ccf67-a273-4560-a9c3-33af6b2fef62" />