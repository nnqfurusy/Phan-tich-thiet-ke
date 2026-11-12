# RestMan1: Hướng dẫn chạy project

Hệ thống quản lý nhà hàng, gồm 2 chức năng:
1. **Khách hàng tìm kiếm thông tin món ăn**
2. **Nhân viên kho nhập nguyên liệu**

Công nghệ: Java (JSP) + Tomcat 10/10.1/11 (Jakarta) + MySQL (XAMPP), project NetBeans kiểu Ant.

---

## 1. Tạo cơ sở dữ liệu (XAMPP)

1. Mở **XAMPP Control Panel** và bấm **Start** ở dòng **MySQL**. Không cần bật Tomcat của XAMPP vì NetBeans dùng Tomcat riêng; bật cả hai sẽ bị trùng cổng 8080.
2. Bấm **Admin** ở dòng MySQL để mở phpMyAdmin.
3. Chọn tab **Import**, chọn file `database/restman1.sql` rồi bấm **Go**.
   Cách khác: vào tab **SQL**, dán toàn bộ nội dung file và bấm **Go**.
4. Kết quả: có database `restman1` với 17 bảng (`Account1`, `Dish1`, `Supplier1`, ...) và dữ liệu mẫu.

> Nếu MySQL của bạn có mật khẩu hoặc dùng cổng khác 3306, sửa `DB_URL`, `DB_USER`, `DB_PASSWORD` trong `src/java/dao/DAO1.java`.

## 2. Thêm driver MySQL

1. Tải **MySQL Connector/J** tại https://dev.mysql.com/downloads/connector/j/, chọn *Platform Independent*, tải file ZIP.
2. Giải nén và lấy file `mysql-connector-j-x.x.x.jar`.
3. Chép file đó vào thư mục **`RestMan1/web/WEB-INF/lib/`**.

Code chỉ dùng `java.sql.*` nên khi biên dịch không cần driver. Driver được nạp lúc chạy từ `WEB-INF/lib`.

## 3. Mở và chạy trong NetBeans

1. **File > Open Project...** rồi chọn thư mục `RestMan1`.
   NetBeans sẽ tự sinh lại file `nbproject/build-impl.xml`.
2. Nếu thấy cảnh báo *"Missing server"* hoặc *"Resolve Problems"*: chuột phải vào project, chọn **Resolve Project Problems...**, rồi chọn Tomcat 10 của bạn.
   Cách khác: chuột phải project, vào **Properties > Run > Server** và chọn Tomcat.
3. Chuột phải vào project và chọn **Run**. Trình duyệt sẽ mở `http://localhost:8080/RestMan1/`.

**Nếu NetBeans không mở được project** (do khác phiên bản), làm theo cách dự phòng sau:
- Tạo project mới: **File > New Project > Java with Ant > Java Web > Web Application**, đặt tên `RestMan1`, chọn server Tomcat 10, Java EE version **Jakarta EE 10 Web** (hoặc 9.1).
- Xoá `index.html`/`index.jsp` mặc định.
- Chép đè thư mục `src/java` và `web` từ bộ code này vào project mới.

## 4. Tài khoản mẫu (mật khẩu đều là `123456`)

| Tài khoản | Vai trò | Vào trang |
|---|---|---|
| `khach1`, `khach2` | Khách hàng | Trang chủ khách hàng, Tìm kiếm món ăn |
| `kho1`, `kho2` | Nhân viên kho | Trang chủ nhân viên kho, Nhập nguyên liệu |
| `quanly`, `banhang` | Quản lý / Bán hàng | Chưa xây dựng chức năng (sẽ có thông báo) |

Dữ liệu mẫu để thử theo kịch bản: món **"Gà"** (Gà hầm thuốc bắc, Gà nướng mật ong, Gà rán giòn), nhà cung cấp **"Công ty A"**, nguyên liệu **"Cá"** (Cá chép, Cá hồi, Cá basa).

## 5. Cấu trúc project

```
RestMan1/
├── database/restman1.sql            CSDL + dữ liệu mẫu
├── src/java/
│   ├── model/                       Lớp thực thể
│   │   Member1, Employee1, WarehouseStaff1, Customer1, Dish1,
│   │   Supplier1, Ingredient1, IngredientReceipt1, IngredientReceiptDetail1
│   ├── dao/                         Truy cập CSDL
│   │   DAO1 (giữ Connection con), MemberDAO1, DishDAO1,
│   │   SupplierDAO1, IngredientDAO1, IngredientReceiptDAO1
│   └── util/Format1.java            Định dạng tiền, số, escape HTML
└── web/
    ├── member/GDLogin1.jsp          Đăng nhập / đăng xuất
    ├── customer/                    Module Tìm kiếm thông tin món ăn
    │   GDMainCustomer1.jsp → GDSearchDish1.jsp → GDDishInformation1.jsp
    ├── warehouseStaff/              Module Nhập nguyên liệu
    │   GDMainWarehouseStaff1.jsp → GDSupplierSearch1.jsp (+ GDNewSupplier1.jsp)
    │   → GDIngredientSearch1.jsp (+ GDNewIngredient1.jsp) ⇄ GDIngredientAmount1.jsp
    │   → GDIngredientReceipt1.jsp
    └── css/style1.css
```

Cấu trúc gói theo package diagram: `view (member, customer, warehouseStaff)` → `dao` → `model`.

### Các phương thức chính (đúng tên trong thiết kế)

| Lớp | Phương thức | Việc làm |
|---|---|---|
| DishDAO1 | `searchDish(key)` | Tìm món có tên chứa từ khoá |
| DishDAO1 | `getDish(id)` | Lấy chi tiết một món |
| SupplierDAO1 | `searchSupplier(key)` / `addNewSupplier(s)` | Tìm / thêm nhà cung cấp |
| IngredientDAO1 | `searchIngredient(key)` / `addNewIngredient(i)` | Tìm / thêm nguyên liệu |
| IngredientDAO1 | `updateAmountInStock(i, quantity, price)` | Cộng tồn kho sau khi nhập |
| IngredientReceiptDAO1 | `saveImportReceipt(receipt)` | Lưu hoá đơn + chi tiết (transaction) |
| MemberDAO1 | `checkLogin(member)` | Kiểm tra đăng nhập |

## 6. Những chỗ đã điều chỉnh so với tài liệu thiết kế

- **Bảng `Ingredient1`** có thêm cột `price` và `quantityInStock`. Giao diện cần hiện "Số lượng còn lại" và hàm `updateAmountInStock()` cần cập nhật tồn kho, nhưng sơ đồ CSDL gốc chưa có các cột này.
- **Bảng `Account1`** có thêm cột `customerId` để khách hàng đăng nhập được.
- **Bảng `IngredientReceipt1`** có thêm cột `totalValue`, khớp với thuộc tính trong sơ đồ lớp.
- Bảng `FoodItem` trong sơ đồ CSDL được đặt tên là **`Dish1`** cho khớp với lớp `Dish1`. Cột khoá ngoại tới món ăn cũng đổi thành `dishId`.
- Bảng `Reservation` bỏ cột `DiningTableId` vì đã có bảng chi tiết `ReservationTableDetail1`.
- **Ngoại lệ "không nhập gì rồi bấm Tìm kiếm"**: hệ thống hiện toàn bộ danh sách (theo kịch bản mục 3.1).
- **Thêm nút "Xoá"** cho từng dòng trong bảng "Nguyên liệu đã nhập" để sửa khi nhập nhầm.
- Nút **"In hoá đơn"** sẽ lưu hoá đơn, cập nhật tồn kho, rồi mở hộp thoại in của trình duyệt. Trạng thái hoá đơn được lưu là `paid` (đã thanh toán).
- Kiểu `id` dùng `int` (CSDL là integer). Tiền và số lượng dùng `double` thay cho `float` để tránh sai số khi tổng tiền lớn.
- Các file bắt buộc theo chuẩn (`web.xml`, `context.xml`, `build.xml`, `project.properties`...) giữ nguyên tên vì Tomcat và NetBeans yêu cầu như vậy.
- Mật khẩu đang lưu dạng chữ thường (chưa mã hoá). Cách này chỉ phù hợp cho bài tập.
