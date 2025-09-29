Rồi 👍 mình sẽ làm một bản tổng hợp chi tiết về **Basic Router** cho bạn, theo outline mà bạn đưa ra.

---

# 🌐 BASIC ROUTER

## 1. Encapsulation IP Packet

* **Đóng gói (Encapsulation):** Dữ liệu từ tầng Transport (TCP/UDP segment) được đóng vào **IP packet** ở tầng Network.
* **Cấu trúc IP header (IPv4):**

  * **Version (4 bit):** IPv4/IPv6.
  * **IHL (Internet Header Length).**
  * **Total Length.**
  * **Identification, Flags, Fragment Offset:** hỗ trợ phân mảnh gói.
  * **TTL (Time To Live):** giới hạn vòng đời gói, tránh loop.
  * **Protocol:** TCP = 6, UDP = 17…
  * **Source IP / Destination IP.**
  * **Header Checksum.**

👉 Ý nghĩa: Router **dựa vào IP header** để chuyển tiếp gói tin.

---

## 2. Router Function

* Router là thiết bị **lớp 3 (Network Layer)**, nhiệm vụ chính:

  * **Kết nối nhiều mạng khác nhau.**
  * **Định tuyến (routing):** tìm đường đi tốt nhất để gói tin đến đích.
  * **Chuyển tiếp (forwarding):** đưa gói tin từ interface vào ra đúng interface ra.
  * **Chia broadcast domain** (khác với switch).

---

## 3. Path Determination

* Router dùng **Routing Table** để quyết định đường đi.
* Dựa trên:

  * **Network address (prefix).**
  * **Metric (cost, hop count, bandwidth...).**
  * **Administrative Distance (AD):** độ tin cậy của loại route.

---

## 4. Định tuyến (Routing) và Định tuyến tĩnh (Static Routing)

* **Routing**: quá trình xác định đường đi của packet.
* **Static Routing:**

  * Admin cấu hình thủ công route.
  * Ví dụ:

    ```bash
    Router(config)# ip route 192.168.2.0 255.255.255.0 10.0.0.2
    ```

    → Để đi tới mạng 192.168.2.0/24 thì next-hop là 10.0.0.2.
  * Ưu: dễ kiểm soát, bảo mật.
  * Nhược: không tự động cập nhật khi topology thay đổi.

---

## 5. Link State và Distance Vector Routing Protocol

* **Distance Vector (DV):**

  * Router quảng bá toàn bộ routing table cho neighbor.
  * Metric = hop count (số router đi qua).
  * Ví dụ: RIP.

* **Link State (LS):**

  * Router chia sẻ trạng thái link cho toàn mạng, từ đó mỗi router tự build bản đồ topology và tính đường tốt nhất (Dijkstra).
  * Metric = bandwidth, delay…
  * Ví dụ: OSPF, IS-IS.

👉 **DV = dễ triển khai, ít tài nguyên**; **LS = tối ưu đường đi, hội tụ nhanh, phức tạp hơn.**

---

## 6. IP Address

* **IPv4 address** = 32 bit (4 octet).

* **Chia lớp:**

  * Class A: `0.0.0.0 – 127.255.255.255`, mask mặc định `/8`.
  * Class B: `128.0.0.0 – 191.255.255.255`, mask mặc định `/16`.
  * Class C: `192.0.0.0 – 223.255.255.255`, mask mặc định `/24`.
  * Class D: Multicast.
  * Class E: Reserved.

* **Subnet mask:** xác định phần Network/Host trong IP.

---

## 7. Public, Private IP, NAT

* **Public IP:** địa chỉ IP duy nhất trên Internet, do ISP cấp.

* **Private IP:** chỉ dùng trong LAN, không định tuyến trên Internet.

  * Class A: 10.0.0.0/8
  * Class B: 172.16.0.0/12
  * Class C: 192.168.0.0/16

* **NAT (Network Address Translation):**

  * Cơ chế chuyển đổi Private IP ↔ Public IP.
  * Giúp nhiều thiết bị LAN ra Internet qua 1 IP Public.
  * Các loại NAT:

    * **Static NAT:** 1-1 mapping.
    * **Dynamic NAT:** chọn ngẫu nhiên IP public từ pool.
    * **PAT (Port Address Translation/NAT Overload):** nhiều thiết bị LAN dùng chung 1 IP Public với port khác nhau.

---

## 8. Subnet Calculation

* **Subnetting:** chia nhỏ network lớn thành nhiều subnet.
* Ví dụ:

  * Network: `192.168.1.0/24`
  * Subnet mask `/26` → mỗi subnet có 64 địa chỉ.
  * Subnets:

    * 192.168.1.0 – 192.168.1.63
    * 192.168.1.64 – 192.168.1.127
    * 192.168.1.128 – 192.168.1.191
    * 192.168.1.192 – 192.168.1.255

---

## 9. Access Control List (ACL)

* **ACL**: tập luật lọc gói dựa trên địa chỉ, protocol, port.
* **Dùng để:** packet filtering, hạn chế truy cập, tăng bảo mật, QoS.

### Loại ACL

* **Standard ACL:** chỉ lọc theo source IP.

  ```bash
  access-list 1 permit 192.168.1.0 0.0.0.255
  ```
* **Extended ACL:** lọc theo source/destination IP, protocol, port.

  ```bash
  access-list 101 permit tcp 192.168.1.0 0.0.0.255 any eq 80
  ```
* **Named ACL:** ACL có tên để dễ quản lý.

👉 ACL được áp dụng trên interface (inbound hoặc outbound).

---
