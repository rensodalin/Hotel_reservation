-- ========================
-- 1. AUDIT FOR STAFF
-- ========================
CREATE TABLE Audit_Staff (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    staff_id INT,
    staff_role VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address VARCHAR(100),
    email VARCHAR(50),
    date_hire DATE,
    contact_number VARCHAR(20),
    shift_schedule VARCHAR(50),
    admin_id INT
);

DELIMITER //

CREATE TRIGGER staff_after_insert
AFTER INSERT ON Staff
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Staff VALUES (
        NULL, 'INSERT', NOW(),
        NEW.staff_id, NEW.staff_role, NEW.first_name, NEW.last_name,
        NEW.address, NEW.email, NEW.date_hire, NEW.contact_number,
        NEW.shift_schedule, NEW.admin_id
    );
END;
//

CREATE TRIGGER staff_after_update
AFTER UPDATE ON Staff
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Staff VALUES (
        NULL, 'UPDATE', NOW(),
        OLD.staff_id, OLD.staff_role, OLD.first_name, OLD.last_name,
        OLD.address, OLD.email, OLD.date_hire, OLD.contact_number,
        OLD.shift_schedule, OLD.admin_id
    );
END;
//

CREATE TRIGGER staff_after_delete
AFTER DELETE ON Staff
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Staff VALUES (
        NULL, 'DELETE', NOW(),
        OLD.staff_id, OLD.staff_role, OLD.first_name, OLD.last_name,
        OLD.address, OLD.email, OLD.date_hire, OLD.contact_number,
        OLD.shift_schedule, OLD.admin_id
    );
END;
//

DELIMITER ;

-- ========================
-- 2. AUDIT FOR GUEST
-- ========================
CREATE TABLE Audit_Guest (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    guest_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address VARCHAR(100),
    date_of_birth DATE,
    date_of_register DATE,
    phone_number VARCHAR(20),
    email VARCHAR(50)
);

DELIMITER //

CREATE TRIGGER guest_after_insert
AFTER INSERT ON Guest
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Guest VALUES (
        NULL, 'INSERT', NOW(),
        NEW.guest_id, NEW.first_name, NEW.last_name, NEW.address,
        NEW.date_of_birth, NEW.date_of_register, NEW.phone_number, NEW.email
    );
END;
//

CREATE TRIGGER guest_after_update
AFTER UPDATE ON Guest
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Guest VALUES (
        NULL, 'UPDATE', NOW(),
        OLD.guest_id, OLD.first_name, OLD.last_name, OLD.address,
        OLD.date_of_birth, OLD.date_of_register, OLD.phone_number, OLD.email
    );
END;
//

CREATE TRIGGER guest_after_delete
AFTER DELETE ON Guest
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Guest VALUES (
        NULL, 'DELETE', NOW(),
        OLD.guest_id, OLD.first_name, OLD.last_name, OLD.address,
        OLD.date_of_birth, OLD.date_of_register, OLD.phone_number, OLD.email
    );
END;
//

DELIMITER ;

-- ========================
-- 3. AUDIT FOR ROOM
-- ========================
CREATE TABLE Audit_Room (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    room_id INT,
    bed_count INT,
    floor_number INT,
    price_per_night DECIMAL(10,2),
    room_type VARCHAR(100),
    discount DECIMAL(4,2),
    status VARCHAR(50)
);

DELIMITER //

CREATE TRIGGER room_after_insert
AFTER INSERT ON Room
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Room VALUES (
        NULL, 'INSERT', NOW(),
        NEW.room_id, NEW.bed_count, NEW.floor_number, NEW.price_per_night,
        NEW.room_type, NEW.discount, NEW.status
    );
END;
//

CREATE TRIGGER room_after_update
AFTER UPDATE ON Room
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Room VALUES (
        NULL, 'UPDATE', NOW(),
        OLD.room_id, OLD.bed_count, OLD.floor_number, OLD.price_per_night,
        OLD.room_type, OLD.discount, OLD.status
    );
END;
//

CREATE TRIGGER room_after_delete
AFTER DELETE ON Room
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Room VALUES (
        NULL, 'DELETE', NOW(),
        OLD.room_id, OLD.bed_count, OLD.floor_number, OLD.price_per_night,
        OLD.room_type, OLD.discount, OLD.status
    );
END;
//

DELIMITER ;

-- ========================
-- 4. AUDIT FOR RESERVATION
-- ========================
CREATE TABLE Audit_Reservation (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    reservation_id INT,
    reservation_date DATE,
    staff_id INT,
    guest_id INT,
    partner_id INT
);

DELIMITER //

CREATE TRIGGER reservation_after_insert
AFTER INSERT ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Reservation VALUES (
        NULL, 'INSERT', NOW(),
        NEW.reservation_id, NEW.reservation_date,
        NEW.staff_id, NEW.guest_id, NEW.partner_id
    );
END;
//

CREATE TRIGGER reservation_after_update
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Reservation VALUES (
        NULL, 'UPDATE', NOW(),
        OLD.reservation_id, OLD.reservation_date,
        OLD.staff_id, OLD.guest_id, OLD.partner_id
    );
END;
//

CREATE TRIGGER reservation_after_delete
AFTER DELETE ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Reservation VALUES (
        NULL, 'DELETE', NOW(),
        OLD.reservation_id, OLD.reservation_date,
        OLD.staff_id, OLD.guest_id, OLD.partner_id
    );
END;
//

DELIMITER ;

-- ========================
-- 5. AUDIT FOR RESERVATION_ROOM
-- ========================
CREATE TABLE Audit_Reservation_Room (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    reservation_id INT,
    room_id INT,
    check_in_date DATE,
    check_out_date DATE,
    number_night INT,
    member INT,
    status VARCHAR(50)
);

DELIMITER //

CREATE TRIGGER reservation_room_after_insert
AFTER INSERT ON Reservation_Room
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Reservation_Room VALUES (
        NULL, 'INSERT', NOW(),
        NEW.reservation_id, NEW.room_id, NEW.check_in_date,
        NEW.check_out_date, NEW.number_night, NEW.member, NEW.status
    );
END;
//

CREATE TRIGGER reservation_room_after_update
AFTER UPDATE ON Reservation_Room
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Reservation_Room VALUES (
        NULL, 'UPDATE', NOW(),
        OLD.reservation_id, OLD.room_id, OLD.check_in_date,
        OLD.check_out_date, OLD.number_night, OLD.member, OLD.status
    );
END;
//

CREATE TRIGGER reservation_room_after_delete
AFTER DELETE ON Reservation_Room
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Reservation_Room VALUES (
        NULL, 'DELETE', NOW(),
        OLD.reservation_id, OLD.room_id, OLD.check_in_date,
        OLD.check_out_date, OLD.number_night, OLD.member, OLD.status
    );
END;
//

DELIMITER ;

-- ========================
-- 6. AUDIT FOR PAYMENT
-- ========================
CREATE TABLE Audit_Payment (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    payment_id INT,
    payment_date DATE,
    payment_method VARCHAR(100),
    amount_paid DECIMAL(10,2),
    trancation_id VARCHAR(50),
    status VARCHAR(50),
    reservation_id INT
);

DELIMITER //

CREATE TRIGGER payment_after_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Payment VALUES (
        NULL, 'INSERT', NOW(),
        NEW.payment_id, NEW.payment_date, NEW.payment_method,
        NEW.amount_paid, NEW.trancation_id, NEW.status, NEW.reservation_id
    );
END;
//

CREATE TRIGGER payment_after_update
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Payment VALUES (
        NULL, 'UPDATE', NOW(),
        OLD.payment_id, OLD.payment_date, OLD.payment_method,
        OLD.amount_paid, OLD.trancation_id, OLD.status, OLD.reservation_id
    );
END;
//

CREATE TRIGGER payment_after_delete
AFTER DELETE ON Payment
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Payment VALUES (
        NULL, 'DELETE', NOW(),
        OLD.payment_id, OLD.payment_date, OLD.payment_method,
        OLD.amount_paid, OLD.trancation_id, OLD.status, OLD.reservation_id
    );
END;
//

DELIMITER ;
