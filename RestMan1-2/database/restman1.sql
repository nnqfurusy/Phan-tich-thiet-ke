-- =====================================================================
-- RestMan - He thong quan ly nha hang
-- CSDL cho 2 chuc nang: Tim kiem thong tin mon an & Nhap nguyen lieu
-- Chay file nay trong phpMyAdmin (XAMPP) -> tab SQL -> Go (Thuc hien)
-- Ten bang: tieng Anh + hau to 1. Ten cot: tieng Anh, khong hau to.
-- =====================================================================

DROP DATABASE IF EXISTS restman1;
CREATE DATABASE restman1 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman1;

-- ---------------------------------------------------------------------
-- Nguoi dung
-- ---------------------------------------------------------------------
CREATE TABLE Employee1 (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    fullName      VARCHAR(255) NOT NULL,
    phoneNumber   VARCHAR(255) NOT NULL,
    email         VARCHAR(255) NULL,
    position      VARCHAR(255) NOT NULL,          -- manager / warehouseStaff / salesStaff
    workingStatus VARCHAR(255) NOT NULL DEFAULT 'working'
) ENGINE=InnoDB;

CREATE TABLE Customer1 (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    fullName    VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(255) NOT NULL,
    email       VARCHAR(255) NULL,
    note        VARCHAR(255) NULL
) ENGINE=InnoDB;

-- Tai khoan dang nhap: thuoc ve 1 nhan vien HOAC 1 khach hang
CREATE TABLE Account1 (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(255) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    role          VARCHAR(255) NOT NULL,          -- customer / warehouseStaff / manager / salesStaff
    accountStatus VARCHAR(255) NOT NULL DEFAULT 'active',
    employeeId    INT NULL UNIQUE,
    customerId    INT NULL UNIQUE,
    CONSTRAINT fk_account_employee FOREIGN KEY (employeeId) REFERENCES Employee1(id),
    CONSTRAINT fk_account_customer FOREIGN KEY (customerId) REFERENCES Customer1(id)
) ENGINE=InnoDB;

CREATE TABLE MembershipCard1 (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    cardCode     VARCHAR(255) NOT NULL UNIQUE,
    cardStatus   VARCHAR(255) NOT NULL DEFAULT 'active',
    issueDate    DATE NOT NULL,
    expiryDate   DATE NULL,
    customerId   INT NOT NULL UNIQUE,
    salesStaffId INT NULL,
    CONSTRAINT fk_card_customer FOREIGN KEY (customerId) REFERENCES Customer1(id),
    CONSTRAINT fk_card_salesstaff FOREIGN KEY (salesStaffId) REFERENCES Employee1(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Nhap nguyen lieu
-- ---------------------------------------------------------------------
CREATE TABLE Supplier1 (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    supplierName      VARCHAR(255) NOT NULL,
    address           VARCHAR(255) NOT NULL,
    phoneNumber       VARCHAR(255) NOT NULL,
    email             VARCHAR(255) NULL,
    representative    VARCHAR(255) NULL,
    cooperationStatus VARCHAR(255) NOT NULL DEFAULT 'active'
) ENGINE=InnoDB;

CREATE TABLE Ingredient1 (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    ingredientName  VARCHAR(255) NOT NULL,
    unit            VARCHAR(255) NOT NULL,
    price           DECIMAL(15,2) NOT NULL DEFAULT 0,     -- don gia nhap gan nhat
    quantityInStock DECIMAL(12,3) NOT NULL DEFAULT 0,     -- so luong con lai trong kho
    description     VARCHAR(255) NULL,
    usageStatus     VARCHAR(255) NOT NULL DEFAULT 'inUse'
) ENGINE=InnoDB;

CREATE TABLE IngredientReceipt1 (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    receiptStatus    VARCHAR(255) NOT NULL DEFAULT 'paid',
    receivedAt       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totalValue       DECIMAL(15,2) NOT NULL DEFAULT 0,
    warehouseStaffId INT NOT NULL,
    supplierId       INT NOT NULL,
    CONSTRAINT fk_receipt_staff    FOREIGN KEY (warehouseStaffId) REFERENCES Employee1(id),
    CONSTRAINT fk_receipt_supplier FOREIGN KEY (supplierId) REFERENCES Supplier1(id)
) ENGINE=InnoDB;

CREATE TABLE IngredientReceiptDetail1 (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    quantity            DECIMAL(12,3) NOT NULL,
    purchasePrice       DECIMAL(15,2) NOT NULL,
    ingredientReceiptId INT NOT NULL,
    ingredientId        INT NOT NULL,
    CONSTRAINT fk_detail_receipt    FOREIGN KEY (ingredientReceiptId) REFERENCES IngredientReceipt1(id) ON DELETE CASCADE,
    CONSTRAINT fk_detail_ingredient FOREIGN KEY (ingredientId) REFERENCES Ingredient1(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Mon an, combo
-- ---------------------------------------------------------------------
CREATE TABLE Dish1 (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    foodName      VARCHAR(255) NOT NULL,
    foodCategory  VARCHAR(255) NOT NULL,
    description   VARCHAR(1000) NULL,
    image         VARCHAR(255) NULL,
    unit          VARCHAR(255) NOT NULL,          -- khau phan
    price         DECIMAL(15,2) NOT NULL,
    servingStatus VARCHAR(255) NOT NULL DEFAULT 'serving'
) ENGINE=InnoDB;

CREATE TABLE Combo1 (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    comboName     VARCHAR(255) NOT NULL,
    description   VARCHAR(255) NULL,
    image         VARCHAR(255) NULL,
    servingStatus VARCHAR(255) NOT NULL DEFAULT 'serving',
    sellingPrice  DECIMAL(15,2) NOT NULL,
    startTime     TIMESTAMP NULL,
    endTime       TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE ComboDetail1 (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT NOT NULL DEFAULT 1,
    note     VARCHAR(255) NULL,
    comboId  INT NOT NULL,
    dishId   INT NOT NULL,
    CONSTRAINT fk_combodetail_combo FOREIGN KEY (comboId) REFERENCES Combo1(id) ON DELETE CASCADE,
    CONSTRAINT fk_combodetail_dish  FOREIGN KEY (dishId) REFERENCES Dish1(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Ban an, dat ban, goi mon, hoa don ban (chua dung trong 2 chuc nang)
-- ---------------------------------------------------------------------
CREATE TABLE DiningTable1 (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    tableName       VARCHAR(255) NOT NULL,
    location        VARCHAR(255) NOT NULL,
    operatingStatus VARCHAR(255) NOT NULL DEFAULT 'available',
    capacity        INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Reservation1 (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    arrivalDate       DATE NOT NULL,
    timeSlot          VARCHAR(255) NOT NULL,
    guestCount        INT NOT NULL,
    note              VARCHAR(255) NULL,
    createdAt         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reservationStatus VARCHAR(255) NOT NULL DEFAULT 'pending',
    customerId        INT NOT NULL,
    CONSTRAINT fk_reservation_customer FOREIGN KEY (customerId) REFERENCES Customer1(id)
) ENGINE=InnoDB;

CREATE TABLE ReservationTableDetail1 (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    numberOfGuest  INT NULL,
    reservationId  INT NOT NULL,
    diningTableId  INT NOT NULL,
    CONSTRAINT fk_rtd_reservation FOREIGN KEY (reservationId) REFERENCES Reservation1(id) ON DELETE CASCADE,
    CONSTRAINT fk_rtd_table       FOREIGN KEY (diningTableId) REFERENCES DiningTable1(id)
) ENGINE=InnoDB;

CREATE TABLE Order1 (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    orderType     VARCHAR(255) NOT NULL,          -- atTable / online
    note          VARCHAR(255) NULL,
    orderStatus   VARCHAR(255) NOT NULL DEFAULT 'pending',
    createdAt     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diningTableId INT NULL,
    reservationId INT NULL UNIQUE,
    CONSTRAINT fk_order_table       FOREIGN KEY (diningTableId) REFERENCES DiningTable1(id),
    CONSTRAINT fk_order_reservation FOREIGN KEY (reservationId) REFERENCES Reservation1(id)
) ENGINE=InnoDB;

CREATE TABLE OrderDetail1 (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    quantity  INT NOT NULL,
    unitPrice DECIMAL(15,2) NOT NULL,
    note      VARCHAR(255) NULL,
    orderId   INT NOT NULL,
    dishId    INT NULL,
    comboId   INT NULL,
    CONSTRAINT fk_orderdetail_order FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE,
    CONSTRAINT fk_orderdetail_dish  FOREIGN KEY (dishId) REFERENCES Dish1(id),
    CONSTRAINT fk_orderdetail_combo FOREIGN KEY (comboId) REFERENCES Combo1(id)
) ENGINE=InnoDB;

CREATE TABLE Invoice1 (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    paymentMethod  VARCHAR(255) NOT NULL,
    invoiceStatus  VARCHAR(255) NOT NULL DEFAULT 'unpaid',
    issuedAt       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    discountAmount DECIMAL(15,2) NOT NULL DEFAULT 0,
    orderId        INT NOT NULL UNIQUE,
    salesStaffId   INT NOT NULL,
    CONSTRAINT fk_invoice_order FOREIGN KEY (orderId) REFERENCES Order1(id),
    CONSTRAINT fk_invoice_staff FOREIGN KEY (salesStaffId) REFERENCES Employee1(id)
) ENGINE=InnoDB;

-- =====================================================================
-- DU LIEU MAU
-- =====================================================================
INSERT INTO Employee1 (fullName, phoneNumber, email, position) VALUES
('Nguyễn Văn Kho',   '0901000001', 'kho1@restman.vn',    'warehouseStaff'),
('Trần Thị Kho',     '0901000002', 'kho2@restman.vn',    'warehouseStaff'),
('Lê Văn Quản Lý',   '0901000003', 'quanly@restman.vn',  'manager'),
('Phạm Thị Bán Hàng','0901000004', 'banhang@restman.vn', 'salesStaff');

INSERT INTO Customer1 (fullName, phoneNumber, email, note) VALUES
('Nguyễn Văn A', '0912000001', 'khach1@gmail.com', NULL),
('Trần Thị B',   '0912000002', 'khach2@gmail.com', 'Khách quen');

-- Mat khau mau: 123456
INSERT INTO Account1 (username, password, role, employeeId, customerId) VALUES
('kho1',    '123456', 'warehouseStaff', 1, NULL),
('kho2',    '123456', 'warehouseStaff', 2, NULL),
('quanly',  '123456', 'manager',        3, NULL),
('banhang', '123456', 'salesStaff',     4, NULL),
('khach1',  '123456', 'customer',       NULL, 1),
('khach2',  '123456', 'customer',       NULL, 2);

INSERT INTO MembershipCard1 (cardCode, issueDate, expiryDate, customerId, salesStaffId) VALUES
('MC0001', '2026-01-10', '2027-01-10', 2, 4);

INSERT INTO Supplier1 (supplierName, address, phoneNumber, email, representative) VALUES
('Công ty A',                    '12 Trần Phú, Hà Đông, Hà Nội',      '0243000001', 'congtya@gmail.com', 'Nguyễn Văn An'),
('Công ty TNHH Thực phẩm Sạch',  '45 Nguyễn Trãi, Thanh Xuân, Hà Nội','0243000002', 'tpsach@gmail.com',  'Lê Thị Bình'),
('Công ty Hải sản Biển Đông',    '8 Lạc Long Quân, Tây Hồ, Hà Nội',   '0243000003', NULL,                'Trần Văn Cường'),
('Công ty Rau củ Đà Lạt',        '20 Phan Đình Phùng, Đà Lạt',        '0263000004', 'raudalat@gmail.com',NULL);

INSERT INTO Ingredient1 (ingredientName, unit, price, quantityInStock, description) VALUES
('Cá chép',          'kg',   180000, 5,   'Cá chép tươi'),
('Cá hồi',           'kg',   450000, 2,   'Cá hồi Na Uy'),
('Cá basa',          'kg',    90000, 0,   NULL),
('Thịt gà ta',       'kg',   150000, 10,  'Gà ta nguyên con'),
('Thịt bò thăn',     'kg',   320000, 4,   NULL),
('Rau muống',        'bó',    10000, 20,  NULL),
('Gạo tám thơm',     'kg',    22000, 50,  NULL),
('Nước mắm',         'chai',  45000, 12,  NULL),
('Thuốc bắc hầm gà', 'gói',   30000, 8,   'Gói thuốc bắc dùng để hầm');

INSERT INTO Dish1 (foodName, foodCategory, description, unit, price) VALUES
('Gà hầm thuốc bắc',    'Món chính', 'Gà ta hầm cùng thuốc bắc, táo đỏ, kỷ tử trong 3 tiếng, nước dùng ngọt thanh.', '1 nồi (2-3 người)', 280000),
('Gà nướng mật ong',    'Món chính', 'Gà ta ướp mật ong, sả, nướng than hoa.',                                       '1/2 con',            220000),
('Gà rán giòn',         'Món chính', 'Gà tẩm bột chiên giòn, ăn kèm tương ớt.',                                      '1 đĩa',              150000),
('Cá chép om dưa',      'Món chính', 'Cá chép om dưa chua, cà chua, ăn kèm bún.',                                    '1 nồi (2-3 người)', 250000),
('Bò lúc lắc',          'Món chính', 'Thịt bò thăn xào lúc lắc với ớt chuông, hành tây.',                            '1 đĩa',              190000),
('Rau muống xào tỏi',   'Món rau',   'Rau muống xào tỏi giòn xanh.',                                                 '1 đĩa',               50000),
('Cơm trắng',           'Món phụ',   'Cơm gạo tám thơm.',                                                            '1 bát',               10000),
('Gỏi cuốn tôm thịt',   'Khai vị',   'Bánh tráng cuốn tôm, thịt, rau sống, chấm nước mắm chua ngọt.',                '4 cuốn',              70000),
('Trà đá',              'Đồ uống',   NULL,                                                                           '1 cốc',                5000);

INSERT INTO Combo1 (comboName, description, sellingPrice) VALUES
('Combo Gà 2 người', 'Gà nướng mật ong + Rau muống xào tỏi + 2 Cơm trắng', 280000);
INSERT INTO ComboDetail1 (quantity, comboId, dishId) VALUES (1, 1, 2), (1, 1, 6), (2, 1, 7);

INSERT INTO DiningTable1 (tableName, location, capacity) VALUES
('Bàn 01', 'Tầng 1', 4), ('Bàn 02', 'Tầng 1', 6), ('Bàn VIP 01', 'Tầng 2', 10);

-- Mot hoa don nhap mau da co san
INSERT INTO IngredientReceipt1 (receiptStatus, receivedAt, totalValue, warehouseStaffId, supplierId) VALUES
('paid', '2026-11-01 09:30:00', 1440000, 1, 1);
INSERT INTO IngredientReceiptDetail1 (quantity, purchasePrice, ingredientReceiptId, ingredientId) VALUES
(3, 180000, 1, 1),
(6, 150000, 1, 4);
