-- Procedure add new room
DELIMITER //
	CREATE PROCEDURE add_new_room(
	    IN bed_count INT,
	    IN floor_number INT,
	    IN price_per_night DECIMAL(10,2),
	    IN room_type VARCHAR(100),
	    IN discount DECIMAL(4,2),
	    IN status VARCHAR(50)
	)
	BEGIN
	    INSERT INTO Room (bed_count, floor_number, price_per_night, room_type, discount, status)
	    VALUES (bed_count, floor_number, price_per_night, room_type, discount, status);
	END //
DELIMITER ;

-- Procedure update room status
DELIMITER //
	CREATE PROCEDURE update_room_status(IN room_id INT, IN new_status VARCHAR(50))
	BEGIN
	    UPDATE Room r 
	    SET status = new_status 
	    WHERE r.room_id = room_id;
	END //
DELIMITER ;
call update_room_status(1, "Occupied");
-- Procedure delete room
DELIMITER //
	CREATE PROCEDURE delete_room(IN room_id INT)
	BEGIN
	    DELETE FROM Room WHERE room_id = room_id;
	END //
DELIMITER ;

-- Procedure add new GUEST
	desc guest;
delimiter //
	create procedure add_new_guest(
		in first_name varchar(50),
		in last_name varchar(50),
		in address varchar(100),
		in date_of_birth date,
		in phone_number varchar(20),
		in email varchar(50)
	)
	begin
		insert into guest (first_name, last_name, address, date_of_birth, date_of_register, phone_number, email)
		values(first_name, last_name, address, date_of_birth, curdate(), phone_number, email);
	end //
delimiter ;
	call add_new_guest('Leng', 'Menghan', 'Kandal', '2005-03-24', '012345678', 'han@gmail.com');

-- Procedure to update guest
DELIMITER //
	CREATE PROCEDURE update_guest(
	    IN guest_id INT,
	    IN first_name VARCHAR(50),
	    IN last_name VARCHAR(50),
	    IN address VARCHAR(100),
	    IN phone_number VARCHAR(20),
	    IN email VARCHAR(50),
	    IN date_of_birth DATE
	)
	BEGIN
	    UPDATE Guest 
	    SET first_name = first_name, 
	        last_name = last_name, 
	        address = address, 
	        phone_number = phone_number, 
	        email = email,
	        date_of_birth = date_of_birth
	    WHERE guest_id = guest_id;
	END //
DELIMITER ;

-- Procedure to delete guest
DELIMITER //
	CREATE PROCEDURE delete_guest(IN guest_id INT)
	BEGIN
	    DELETE FROM guest g where g.guest_id = guest_id;
	END //
DELIMITER ;
call delete_guest(8);
-- Procedure to add RESERVATION
	desc reservation;
DELIMITER //
	CREATE PROCEDURE MakeReservation(
	    IN guest_id INT, 
	    IN staff_id INT, 
	    IN partner_id INT, 
	    OUT new_reservation_id INT
	)
	BEGIN
	    INSERT INTO Reservation (reservation_date, guest_id, staff_id, partner_id)
	    VALUES (CURDATE(), guest_id, staff_id, partner_id);
	    
	    SET new_reservation_id = LAST_INSERT_ID();
	END //
DELIMITER ;

-- procedure to Assign Room to Reservation
DELIMITER //
	CREATE PROCEDURE AssignRoom(
	    IN res_id INT, 
	    IN room_id INT, 
	    IN check_in DATE, 
	    IN check_out DATE, 
	    IN member_count INT
	)
	BEGIN
	    DECLARE nights INT;
	    
	    SET nights = DATEDIFF(check_out, check_in);
	    
	    INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status)
	    VALUES (res_id, room_id, check_in, check_out, nights, member_count, 'Booked');
	    
	    UPDATE Room SET status = 'Occupied' WHERE Room.room_id = room_id;
	END //
DELIMITER ;
	set @new_reservation_id = '';
	call MakeReservation(8, 2, 1, @new_reservation_id);
	call AssignRoom(@new_reservation_id, 1, '2025-03-31', '2025-04-03', 5);
	call AssignRoom(@new_reservation_id, 2, '2025-03-31', '2025-04-03', 5);

-- Procedure to cancel reservation
DELIMITER //
	CREATE PROCEDURE cancel_reservation(IN reservation_id INT)
	BEGIN
	    -- Step 1: Update the status of rooms back to "Available"
	    UPDATE Room 
	    SET status = 'Available' 
	    WHERE room_id IN (
	        SELECT room_id FROM Reservation_Room WHERE reservation_id = reservation_id
	    );
	
	    -- Step 2: Delete entries from Reservation_Room (since they are linked to the reservation)
	    DELETE FROM Reservation_Room WHERE reservation_id = reservation_id;
	
	    -- Step 3: Delete the reservation itself
	    DELETE FROM Reservation WHERE reservation_id = reservation_id;
	END //
DELIMITER ;

-- Delete assign Room in reservation
DELIMITER //
	CREATE PROCEDURE delete_assigned_room(
	    IN res_id INT,
	    IN room_id INT
	)
	BEGIN
	    -- Step 1: Update room status to "Available"
	    UPDATE Room 
	    SET status = 'Available' 
	    WHERE room_id = room_id;
	
	    -- Step 2: Delete the room from the reservation
	    DELETE FROM Reservation_Room 
	    WHERE reservation_id = res_id AND room_id = room_id;
	END //
DELIMITER ;

-- Procedure to proccess PAYMENT
DELIMITER //
	CREATE PROCEDURE ProcessPayment(
	    IN res_id INT, 
	    IN payment_method VARCHAR(100), 
	    IN amount DECIMAL(10,2), 
	    IN trans_id VARCHAR(50)
	)
	BEGIN
	    INSERT INTO Payment (payment_date, payment_method, amount_paid, trancation_id, status, reservation_id)
	    VALUES (CURDATE(), payment_method, amount, trans_id, 'Completed', res_id);
	END //
DELIMITER ;
	
	call ProcessPayment(@new_reservation_id, 'Cash', '100', 'TEST12345');

-- Procedure refund payment
DELIMITER //
	CREATE PROCEDURE refund_payment(IN payment_id INT)
	BEGIN
	    UPDATE Payment 
	    SET status = 'Refunded' 
	    WHERE payment_id = payment_id;
	END //
DELIMITER ;

-- Procedure add review
DELIMITER //
	CREATE PROCEDURE add_review(
	    IN guest_id INT,
	    IN room_id INT,
	    IN comment TEXT,
	    IN rating INT
	)
	BEGIN
	    INSERT INTO Review (submission_date, guest_id, room_id, comment, rating)
	    VALUES (CURDATE(), guest_id, room_id, comment, rating);
	END //
DELIMITER ;
-- Procedure delete review
DELIMITER //
	CREATE PROCEDURE delete_review(IN review_id INT)
	BEGIN
	    DELETE FROM Review WHERE review_id = review_id;
	END //
DELIMITER ;

-- Procedure add special request
DELIMITER //
	CREATE PROCEDURE add_special_request(
	    IN res_id INT,
	    IN request_type VARCHAR(100),
	    IN request_description TEXT
	)
	BEGIN
	    INSERT INTO Special_Request (reservation_id, request_type, date_request, description, status)
	    VALUES (res_id, request_type, CURDATE(), request_description, 'Pending');
	END //
DELIMITER ;

-- Procedure update special_request status
DELIMITER //
	CREATE PROCEDURE update_special_request(
	    IN request_id INT,
	    IN new_status VARCHAR(50)
	)
	BEGIN
	    UPDATE Special_Request 
	    SET status = new_status
	    WHERE request_id = request_id;
	END //
DELIMITER ;

-- Procedure delete special request
DELIMITER //
	CREATE PROCEDURE delete_special_request(IN request_id INT)
	BEGIN
	    DELETE FROM Special_Request WHERE request_id = request_id;
	END //
DELIMITER ;

-- Procedure add new staff
DELIMITER //
	CREATE PROCEDURE add_staff(
	    IN staff_role VARCHAR(50),
	    IN first_name VARCHAR(50),
	    IN last_name VARCHAR(50),
	    IN address VARCHAR(100),
	    IN email VARCHAR(50),
	    IN contact_number VARCHAR(20),
	    IN shift_schedule VARCHAR(50),
	    IN admin_id INT
	)
	BEGIN
	    INSERT INTO Staff (staff_role, first_name, last_name, address, email, date_hire, contact_number, shift_schedule, admin_id)
	    VALUES (staff_role, first_name, last_name, address, email, curdate(), contact_number, shift_schedule, admin_id);
	END //
DELIMITER ;

-- Procedure to update staff
DELIMITER //
	CREATE PROCEDURE update_staff(
	    IN staff_id INT,
	    IN staff_role VARCHAR(50),
	    IN first_name VARCHAR(50),
	    IN last_name VARCHAR(50),
	    IN address VARCHAR(100),
	    IN email VARCHAR(50),
	    IN contact_number VARCHAR(20),
	    IN shift_schedule VARCHAR(50),
	    in admin_id int
	)
	BEGIN
	    UPDATE Staff 
	    SET staff_role = staff_role, 
	        first_name = first_name, 
	        last_name = last_name, 
	        address = address, 
	        email = email, 
	        contact_number = contact_number, 
	        shift_schedule = shift_schedule,
	        admin_id = admin_id
	    WHERE staff_id = staff_id;
	END //
DELIMITER ;

-- Procedure to delete staff
DELIMITER //
	CREATE PROCEDURE delete_staff(IN staff_id INT)
	BEGIN
	    -- Directly delete the staff member; ON DELETE SET NULL will handle dependencies
	    DELETE FROM Staff WHERE staff_id = staff_id;
	END //
DELIMITER ;

-- Procedure add amenity
DELIMITER //
	CREATE PROCEDURE add_amenity(IN amenity_name VARCHAR(100))
	BEGIN
	    INSERT INTO Amenities (amenity_name) VALUES (amenity_name);
	END //
DELIMITER ;

-- Procedure update amenity
DELIMITER //
	CREATE PROCEDURE update_amenity(IN amenity_id INT, IN new_name VARCHAR(100))
	BEGIN
	    UPDATE Amenities 
	    SET amenity_name = new_name
	    WHERE amenity_id = amenity_id;
	END //
DELIMITER ;

-- Procedure delete amenity
DELIMITER //
	CREATE PROCEDURE delete_amenity(IN amenity_id INT)
	BEGIN
	    DELETE FROM Amenities WHERE amenity_id = amenity_id;
	END //
DELIMITER ;

-- Procedure add amenity to room
DELIMITER //
	CREATE PROCEDURE assign_amenity_to_room(IN room_id INT, IN amenity_id INT)
	BEGIN
	    INSERT INTO Room_Amenity (room_id, amenity_id) VALUES (room_id, amenity_id);
	END //
DELIMITER ;

-- Procedure delete amenity to room
DELIMITER //
	CREATE PROCEDURE remove_amenity_from_room(IN room_id INT, IN amenity_id INT)
	BEGIN
	    DELETE FROM Room_Amenity 
	    WHERE room_id = room_id AND amenity_id = amenity_id;
	END //
DELIMITER ;

-- Procedure to get available room
DELIMITER //
	CREATE PROCEDURE get_available_room()
	BEGIN
	    SELECT * FROM Room r WHERE r.status = 'available';
	END //
DELIMITER ;
call get_available_room();


















