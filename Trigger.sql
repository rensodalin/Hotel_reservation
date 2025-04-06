-- Trigger

-- ======================trigger=================================
-- Final Summary
-- Before reservation: "Available"
-- 
-- After inserting a confirmed reservation: "Occupied"
-- 
-- After checking out: "Available" again
-- 1. Trigger to Update Room Status on Reservation
DELIMITER $$

-- Trigger to Update Room Status on Reservation
CREATE TRIGGER update_room_status_after_reservation
AFTER INSERT ON Reservation_Room
FOR EACH ROW
BEGIN
    -- Only update room status if the reservation is confirmed
    IF NEW.status = 'Confirmed' THEN
        UPDATE Room
        SET status = 'Occupied'
        WHERE room_id = NEW.room_id;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

-- Trigger to Reset Room Status on Check-Out
CREATE TRIGGER reset_room_status_after_checkout
AFTER UPDATE ON Reservation_Room
FOR EACH ROW
BEGIN
    -- Only reset room status if the reservation status is updated to 'Checked Out'
    IF OLD.status <> 'Checked Out' AND NEW.status = 'Checked Out' THEN
        UPDATE Room
        SET status = 'Available'
        WHERE room_id = NEW.room_id;
    END IF;
END $$

DELIMITER ;
SELECT * FROM Room WHERE room_id = 10;
INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status)
VALUES (11, 10, '2024-04-10', '2024-04-15', 4, 2, 'Confirmed');
UPDATE Reservation_Room
SET status = 'Checked Out'
WHERE reservation_id = 11;
SELECT * FROM Room WHERE room_id = 10;


-- 2. Create Triggers for Logging Changes
-- Final Notes
-- ✅ Tracks staff and guest updates
-- ✅ Logs old and new values for changes
-- ✅ Easy to expand for more columns
-- Trigger for Staff Table
DELIMITER $$

CREATE TRIGGER log_staff_changes
AFTER UPDATE ON Staff
FOR EACH ROW
BEGIN
    DECLARE col_name VARCHAR(50);
    DECLARE old_val TEXT;
    DECLARE new_val TEXT;
    
    -- Check each column for changes and log them
    IF OLD.first_name <> NEW.first_name THEN
        SET col_name = 'first_name', old_val = OLD.first_name, new_val = NEW.first_name;
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Staff', 'UPDATE', NEW.staff_id, col_name, old_val, new_val);
    END IF;

    IF OLD.last_name <> NEW.last_name THEN
        SET col_name = 'last_name', old_val = OLD.last_name, new_val = NEW.last_name;
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Staff', 'UPDATE', NEW.staff_id, col_name, old_val, new_val);
    END IF;

    IF OLD.email <> NEW.email THEN
        SET col_name = 'email', old_val = OLD.email, new_val = NEW.email;
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Staff', 'UPDATE', NEW.staff_id, col_name, old_val, new_val);
    END IF;

END $$

DELIMITER ;

-- Trigger for Guest table
DELIMITER $$

CREATE TRIGGER log_guest_changes
AFTER UPDATE ON Guest
FOR EACH ROW
BEGIN
    DECLARE col_name VARCHAR(50);
    DECLARE old_val TEXT;
    DECLARE new_val TEXT;
    
    -- Log changes for first_name
    IF OLD.first_name <> NEW.first_name THEN
        SET col_name = 'first_name', old_val = OLD.first_name, new_val = NEW.first_name;
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Guest', 'UPDATE', NEW.guest_id, col_name, old_val, new_val);
    END IF;

    -- Log changes for last_name
    IF OLD.last_name <> NEW.last_name THEN
        SET col_name = 'last_name', old_val = OLD.last_name, new_val = NEW.last_name;
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Guest', 'UPDATE', NEW.guest_id, col_name, old_val, new_val);
    END IF;

    -- Log changes for email
    IF OLD.email <> NEW.email THEN
        SET col_name = 'email', old_val = OLD.email, new_val = NEW.email;
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Guest', 'UPDATE', NEW.guest_id, col_name, old_val, new_val);
    END IF;

END $$

DELIMITER ;
INSERT INTO Staff (staff_role, first_name, last_name, address, email, date_hire, contact_number, shift_schedule)
VALUES ('Manager', 'John', 'Doe', '123 Main St', 'john.doe@email.com', '2024-03-01', '0987654321', 'Morning Shift');

INSERT INTO Guest (first_name, last_name, address, date_of_birth, date_of_register, phone_number, email)
VALUES ('Alice', 'Smith', '456 Elm St', '1995-05-10', '2024-03-05', '0123456789', 'alice@email.com');

-- Update Data to Trigger Log
UPDATE Staff 
SET email = 'john.dav@email.com'
WHERE staff_id = 3;
select *from staff;
SELECT * FROM Change_Log;
select * from guest ;

UPDATE Guest 
SET first_name = 'nita'
WHERE guest_id = 1;
SELECT * FROM Change_Log;


-- 3.trigger Automatically Apply Discount Based on Length of Stay 
-- Purpose: Automatically apply a discount to a room if the guest stays for more than a certain number of nights.
DELIMITER $$

CREATE TRIGGER apply_discount_based_on_stay
BEFORE INSERT ON Reservation_Room
FOR EACH ROW
BEGIN
    -- Check if the length of stay is more than 7 nights
    IF NEW.number_night > 7 THEN
        -- Apply a 10% discount if the stay is longer than 7 nights
        UPDATE Room
        SET discount = 0.10
        WHERE room_id = NEW.room_id;
    END IF;
END $$

DELIMITER ;
-- Check the room details to verify the discount
INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status)
VALUES (1, 26, '2025-01-01', '2025-01-10', 9, 1, 'Confirmed');
SELECT room_id, discount FROM Room WHERE room_id =26;
select * from room r ;


UPDATE Room
SET discount = NULL;

-- Update Room Status When Payment Is Made:
-- 4.This trigger will automatically update the room status to "Paid" when a payment is made for a reservation.
DELIMITER $$

CREATE TRIGGER payment_status_update
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    -- Check if the status of the payment has been updated
    IF OLD.status <> NEW.status THEN
        -- Insert a log entry into Change_Log if the status has changed
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Payment', 'UPDATE', NEW.payment_id, 'status', OLD.status, NEW.status);
    END IF;
END $$

DELIMITER ;
INSERT INTO Payment (payment_date, payment_method, amount_paid, trancation_id, status, reservation_id) 
VALUES ('2024-02-02', 'Credit Card', 100.00, 'TX12345', 'Pending', 36);
select *from payment;
UPDATE Payment 
SET status = 'Completed' 
WHERE payment_id = 31;
SELECT * FROM Change_Log WHERE table_name = 'Payment';





-- 5.Trigger for Updating shift_schedule for staff
DELIMITER $$

CREATE TRIGGER update_shift_schedule
BEFORE UPDATE ON Staff
FOR EACH ROW
BEGIN
    -- Declare a temporary table for storing the new shift schedule
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_shift (
        staff_id INT PRIMARY KEY,
        new_shift VARCHAR(50)
    );

    -- Insert the new shift data into the temporary table
    INSERT INTO temp_shift (staff_id, new_shift)
    VALUES (OLD.staff_id, NEW.shift_schedule);
END $$

DELIMITER ;

UPDATE Staff 
SET shift_schedule = 'night'
WHERE staff_id = 36;
UPDATE Staff 
SET shift_schedule = 'Morning Shift'
WHERE staff_id = 32;
SELECT staff_id, staff.first_name , staff.last_name ,staff_role , shift_schedule FROM Staff;




-- 6.Trigger on UPDATE (when status changes to "Canceled")
DELIMITER $$

-- UPDATE Trigger (Logs when status changes)
CREATE TRIGGER reservation_room_status_update
AFTER UPDATE ON Reservation_Room
FOR EACH ROW
BEGIN
    -- Check if the status is being updated
    IF OLD.status <> NEW.status THEN
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Reservation_Room', 'UPDATE', NEW.reservation_id, 'status', OLD.status, NEW.status);
    END IF;
END $$

DELIMITER ;

INSERT INTO Reservation (reservation_date, staff_id, guest_id, partner_id) 
VALUES ('2024-08-15', 2, 3, NULL);

INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status) 
VALUES (24, 35, '2024-08-15', '2024-08-18', 3, 2, 'Confirmed');

SELECT * FROM Reservation_Room WHERE reservation_id = 24;
UPDATE Reservation_Room 
SET status = 'Canceled' 
WHERE reservation_id = 24 AND room_id = 35;

SELECT * FROM Change_Log WHERE table_name = 'Reservation_Room';

-- 7.trigger to udate for early checkout 
DELIMITER $$

CREATE TRIGGER reservation_room_early_checkout
AFTER UPDATE ON Reservation_Room
FOR EACH ROW
BEGIN
    -- Check if the check-out date has been updated to an earlier date
    IF OLD.check_out_date > NEW.check_out_date THEN
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Reservation_Room', 'UPDATE', NEW.reservation_id, 'check_out_date', 
                OLD.check_out_date, NEW.check_out_date);
    END IF;
END $$

DELIMITER ;
INSERT INTO Reservation (reservation_date, staff_id, guest_id, partner_id) 
VALUES ('2024-08-15', 2, 3, NULL);

INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status) 
VALUES (23, 34, '2024-08-15', '2024-08-18', 3, 2, 'Confirmed');
UPDATE Reservation_Room 
SET check_out_date = '2024-08-17' 
WHERE reservation_id = 23 AND room_id = 34;
SELECT * FROM Change_Log WHERE table_name = 'Reservation_Room';

-- Create Trigger for When Staff Member Stops Working
DELIMITER $$

CREATE TRIGGER staff_status_update
AFTER UPDATE ON Staff
FOR EACH ROW
BEGIN
    -- Check if the status of the staff member has changed
    IF OLD.status <> NEW.status THEN
        -- Insert a log entry into Change_Log if the staff member's status changes
        INSERT INTO Change_Log (table_name, operation_type, record_id, changed_column, old_value, new_value)
        VALUES ('Staff', 'UPDATE', NEW.staff_id, 'status', OLD.status, NEW.status);
    END IF;
END $$

DELIMITER ;

INSERT INTO Staff (staff_role, first_name, last_name, address, email, date_hire, contact_number, shift_schedule, status)
VALUES ('Manager', 'John', 'Doe', '1234 Elm Street', 'john.doe@example.com', '2020-01-01', '555-1234', '9AM-5PM', 'Active');
UPDATE Staff 
SET status = 'Inactive' 
WHERE staff_id = 41;
SELECT * FROM Change_Log WHERE table_name = 'Staff';