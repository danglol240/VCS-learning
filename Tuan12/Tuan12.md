# Web Server và Load Balancer

## 1. Nginx

### 1.1. Định nghĩa

**Nginx** (đọc là *Engine-X*) là một **web server** mã nguồn mở, nổi tiếng nhờ hiệu năng cao, khả năng chịu tải lớn và tiêu thụ tài nguyên thấp.
Ngoài chức năng làm web server, Nginx còn có thể hoạt động như:

* Reverse Proxy
* Load Balancer
* HTTP Cache
* Streaming Server

---

## 2. Forward Proxy và Reverse Proxy

| Tiêu chí                             | Forward Proxy                             | Reverse Proxy                                    |
| ------------------------------------ | ----------------------------------------- | ------------------------------------------------ |
| **Vị trí**                           | Nằm giữa client và Internet               | Nằm giữa client và backend server                |
| **Đại diện cho ai**                  | Đại diện cho **client** truy cập ra ngoài | Đại diện cho **server** tiếp nhận request        |
| **Mục đích chính**                   | Ẩn danh, kiểm soát truy cập, lọc nội dung | Bảo vệ backend, phân tải, cache, SSL termination |
| **Ví dụ**                            | Squid, SOCKS Proxy                        | Nginx, HAProxy, Apache mod_proxy                 |
| **Client có biết server thật không** | Có                                        | Không                                            |
| **Server có biết client thật không** | Không                                     | Có thể (tùy cấu hình)                            |

Tóm lại:

* Forward Proxy giúp **client** đi ra ngoài Internet.
* Reverse Proxy giúp **server** nhận yêu cầu từ bên ngoài và xử lý thay backend.

---

## 3. Cấu hình Nginx – Các Use Case Cơ Bản

### 3.1. Nginx làm Web Server

**File cấu hình: `/etc/nginx/sites-available/web.conf`**

```nginx
server {
    listen 80;
    server_name myweb.local;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

**Giải thích:**

* `listen 80`: Cổng HTTP mặc định.
* `server_name`: Tên miền hoặc IP máy chủ.
* `root`: Thư mục chứa website.
* `try_files`: Kiểm tra sự tồn tại file, nếu không có → trả lỗi 404.

**Kích hoạt và khởi động:**

```bash
sudo ln -s /etc/nginx/sites-available/web.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

---

### 3.2. Cấu hình SSL Cert cho HTTPS

**File cấu hình:**

```nginx
server {
    listen 443 ssl;
    server_name myweb.local;

    ssl_certificate /etc/ssl/certs/myweb.crt;
    ssl_certificate_key /etc/ssl/private/myweb.key;

    root /var/www/html;
    index index.html;
}
```

**Tạo chứng chỉ tự ký (self-signed):**

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/myweb.key -out /etc/ssl/certs/myweb.crt
```

---

### 3.3. Nginx làm Reverse Proxy

**File cấu hình reverse proxy đến backend Flask app:**

```nginx
server {
    listen 80;
    server_name api.myweb.local;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

**Giải thích:**

* `proxy_pass`: Chuyển request đến backend.
* `proxy_set_header`: Giữ thông tin gốc từ client.

---

## 4. HAProxy

### 4.1. Định nghĩa

**HAProxy (High Availability Proxy)** là phần mềm mã nguồn mở chuyên dùng để:

* Cân bằng tải (Load Balancing)
* Reverse Proxy
* High Availability cho hệ thống web, API, database

HAProxy có thể làm việc ở cả **Layer 4 (TCP/UDP)** và **Layer 7 (HTTP/HTTPS)**.

---

### 4.2. Cấu hình cơ bản HAProxy làm Reverse Proxy

**File cấu hình: `/etc/haproxy/haproxy.cfg`**

```cfg
global
    log /dev/log local0
    maxconn 2000
    daemon

defaults
    log global
    mode http
    timeout connect 5s
    timeout client  30s
    timeout server  30s

frontend http_front
    bind *:80
    default_backend web_backends

backend web_backends
    balance roundrobin
    server web1 192.168.1.10:80 check
    server web2 192.168.1.11:80 check
```

**Hoạt động:**

* Client truy cập HAProxy tại cổng 80.
* HAProxy phân phối yêu cầu đến các server backend (web1, web2) theo thuật toán `roundrobin`.

---

## 5. Load Balancer (LB)

### 5.1. Định nghĩa

**Load Balancer** là thiết bị hoặc phần mềm phân phối lưu lượng truy cập đến nhiều server backend.
Mục tiêu chính:

* Tăng hiệu năng và độ sẵn sàng (High Availability).
* Tránh quá tải hoặc gián đoạn dịch vụ.

---

### 5.2. Phân loại Load Balancer

| Loại                      | Tầng hoạt động             | Đặc điểm                                                                     |
| ------------------------- | -------------------------- | ---------------------------------------------------------------------------- |
| **Layer 4 Load Balancer** | Tầng vận chuyển (TCP/UDP)  | Phân phối dựa trên IP, port; không đọc nội dung gói tin. Nhanh, nhẹ.         |
| **Layer 7 Load Balancer** | Tầng ứng dụng (HTTP/HTTPS) | Phân phối dựa trên nội dung (URL, domain, header). Linh hoạt nhưng chậm hơn. |

**Ví dụ:**

* Layer 4: HAProxy TCP mode, Nginx stream, LVS.
* Layer 7: HAProxy HTTP mode, Nginx reverse proxy.

---

### 5.3. So sánh Layer 4 và Layer 7 Load Balancer

| Tiêu chí           | Layer 4 LB                 | Layer 7 LB                             |
| ------------------ | -------------------------- | -------------------------------------- |
| Tầng OSI           | Transport (TCP/UDP)        | Application (HTTP/HTTPS)               |
| Cách hoạt động     | Phân tải dựa trên IP/port  | Phân tải dựa trên nội dung request     |
| Tốc độ xử lý       | Nhanh hơn                  | Chậm hơn (do xử lý HTTP header)        |
| Tài nguyên CPU     | Ít tiêu tốn                | Nhiều hơn                              |
| Linh hoạt          | Ít                         | Cao                                    |
| Ứng dụng điển hình | Database, SSH, game server | Web server, API gateway, microservices |

---

### 5.4. Kết luận

* **Nginx**: Là web server mạnh, đồng thời có thể làm reverse proxy và load balancer cơ bản.
* **HAProxy**: Chuyên dụng cho cân bằng tải, ổn định, hiệu năng cao, hỗ trợ nhiều thuật toán và mô hình HA.
* **Reverse Proxy**: Bảo vệ backend, cache nội dung, giảm tải SSL.
* **Layer 4 vs Layer 7 LB**: Layer 4 nhanh hơn, Layer 7 linh hoạt hơn.

---