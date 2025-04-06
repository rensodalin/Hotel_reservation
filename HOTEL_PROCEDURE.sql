-- Procedure add new room
DELIMITER //
	CREATE PROCEDURE add_new_room(
	    IN bed_count_in INT,
	    IN floor_number_in INT,
	    IN price_per_night_in DECIMAL(10,2),
	    IN room_type_in VARCHAR(100),
	    IN discount_in DECIMAL(4,2),
	    IN status_in VARCHAR(50)
	)
	BEGIN
	    INSERT INTO Room (bed_count, floor_number, price_per_night, room_type, discount, status)
	    VALUES (bed_count_in, floor_number_in, price_per_night_in, room_type_in, discount_in, status_in);
	END //
DELIMITER ;

-- Procedure update room status
DELIMITER //
	CREATE PROCEDURE update_room_status(IN room_id_in INT, IN new_status_in VARCHAR(50))
	BEGIN
	    UPDATE Room r 
	    SET r.status = new_status_in 
	    WHERE r.room_id = room_id_in;
	END //
DELIMITER ;
call update_room_status(1, "Occupied");

-- Procedure delete room
DELIMITER //
	CREATE PROCEDURE delete_room(IN room_id_in INT)
	BEGIN
	    DELETE FROM Room r WHERE r.room_id = room_id_in;
	END //
DELIMITER ;

-- Procedure add new GUEST
delimiter //
	create procedure add_new_guest(
		in first_name_in varchar(50),
		in last_name_in varchar(50),
		in address_in varchar(100),
		in date_of_birth_in date,
		in phone_number_in varchar(20),
		in email_in varchar(50)
	)
	begin
		insert into guest (first_name, last_name, address, date_of_birth, date_of_register, phone_number, email)
		values(first_name_in, last_name_in, address_in, date_of_birth_in, curdate(), phone_number_in, email_in);
	end //
delimiter ;
-- call add_new_guest('Leng', 'Menghan', 'Kandal', '2005-03-24', '012345678', 'han@gmail.com');

-- Procedure to update guest
DELIMITER //
	CREATE PROCEDURE update_guest(
	    IN guest_id_in INT,
	    IN first_name_in VARCHAR(50),
	    IN last_name_in VARCHAR(50),
	    IN address_in VARCHAR(100),
	    IN phone_number_in VARCHAR(20),
	    IN email_in VARCHAR(50),
	    IN date_of_birth_in DATE
	)
	BEGIN
	    UPDATE Guest 
	    SET first_name = first_name_in, 
	        last_name = last_name_in, 
	        address = address_in, 
	        phone_number = phone_number_in, 
	        email = email_in,
	        date_of_birth = date_of_birth_in
	    WHERE guest_id = guest_id_in;
	END //
DELIMITER ;
-- call update_guest(7,'LENG','MENGHAN','KANDAL','0123456789','HAN@GMAIL.COM','2005-03-03');

-- Procedure to delete guest
DELIMITER //
	CREATE PROCEDURE delete_guest(IN guest_id_in INT)
	BEGIN
	    DELETE FROM guest g where g.guest_id = guest_id_in;
	END //
DELIMITER ;
-- call delete_guest(8);

-- Procedure to add RESERVATION
DELIMITER //
	CREATE PROCEDURE MakeReservation(
	    IN guest_id_in INT, 
	    IN staff_id_in INT, 
	    IN partner_id_in INT, 
	    OUT new_reservation_id INT
	)
	BEGIN
	    INSERT INTO Reservation (reservation_date, guest_id, staff_id, partner_id)
	    VALUES (CURDATE(), guest_id_in, staff_id_in, partner_id_in);
	    
	    SET new_reservation_id = LAST_INSERT_ID();
	END //
DELIMITER ;

-- procedure to Assign Room to Reservation
DELIMITER //
	CREATE PROCEDURE AssignRoom(
	    IN res_id_in INT, 
	    IN room_id_in INT, 
	    IN check_in_in DATE, 
	    IN check_out_in DATE, 
	    IN member_count_in INT
	)
	BEGIN
	    DECLARE nights_in INT;
	    
	    SET nights_in = DATEDIFF(check_out_in, check_in_in);
	    
	    INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status)
	    VALUES (res_id_in, room_id_in, check_in_in, check_out_in, nights_in, member_count_in, 'Booked');
	    
	    UPDATE Room SET status = 'Occupied' WHERE room_id = room_id_in;
	END //
DELIMITER ;

-- 	set @new_reservation_id = '';
-- 	call MakeReservation(7, 2, 1, @new_reservation_id);
-- 	call AssignRoom(@new_reservation_id, 1, '2025-03-31', '2025-04-03', 5);
-- 	call AssignRoom(@new_reservation_id, 2, '2025-03-31', '2025-04-03', 5);

-- Procedure to cancel reservation
DELIMITER //
	CREATE PROCEDURE cancel_reservation(IN reservation_id_in INT)
	BEGIN
	    -- Step 1: Update the status of rooms back to "Available"
	    UPDATE Room 
	    SET status = 'Available' 
	    WHERE room_id IN (
	        SELECT room_id FROM Reservation_Room rr WHERE rr.reservation_id = reservation_id_in
	    );
	
	    -- Step 2: Delete entries from Reservation_Room (since they are linked to the reservation)
	    DELETE FROM Reservation_Room rr WHERE rr.reservation_id = reservation_id_in;
	
	    -- Step 3: Delete the reservation itself
	    DELETE FROM Reservation r WHERE r.reservation_id = reservation_id_in;
	END //
DELIMITER ;
call cancel_reservation(8);

-- Delete assign Room in reservation
DELIMITER //
	CREATE PROCEDURE delete_assigned_room(
	    IN res_id_in INT,
	    IN room_id_in INT
	)
	BEGIN
	    -- Step 1: Update room status to "Available"
	    UPDATE Room r
	    SET status = 'Available' 
	    WHERE r.room_id = room_id_in;
	
	    -- Step 2: Delete the room from the reservation
	    DELETE FROM Reservation_Room rr
	    WHERE rr.reservation_id = res_id_in AND rr.room_id = room_id_in;
	END //
DELIMITER ;

-- Procedure to proccess PAYMENT
DELIMITER //
	CREATE PROCEDURE ProcessPayment(
	    IN res_id_in INT, 
	    IN payment_method_in VARCHAR(100), 
	    IN amount_in DECIMAL(10,2), 
	    IN trans_id_in VARCHAR(50)
	)
	BEGIN
	    INSERT INTO Payment (payment_date, payment_method, amount_paid, trancation_id, status, reservation_id)
	    VALUES (CURDATE(), payment_method_in, amount_in, trans_id_in, 'Completed', res_id_in);
	END //
DELIMITER ;
	
-- 	call ProcessPayment(@new_reservation_id, 'Cash', '100', 'TEST12345');

-- Procedure refund payment
DELIMITER //
	CREATE PROCEDURE refund_payment(IN payment_id_in INT)
	BEGIN
	    UPDATE Payment 
	    SET status = 'Refunded' 
	    WHERE payment_id = payment_id_in;
	END //
DELIMITER ;

-- Procedure add review
DELIMITER //
	CREATE PROCEDURE add_review(
	    IN guest_id_in INT,
	    IN room_id_in INT,
	    IN comment_in TEXT,
	    IN rating_in INT
	)
	BEGIN
	    INSERT INTO Review (submission_date, guest_id, room_id, comment, rating)
	    VALUES (CURDATE(), guest_id_in, room_id_in, comment_in, rating_in);
	END //
DELIMITER ;
-- Procedure delete review
DELIMITER //
	CREATE PROCEDURE delete_review(IN review_id_in INT)
	BEGIN
	    DELETE FROM Review WHERE review_id = review_id_in;
	END //
DELIMITER ;

-- Procedure add special request
DELIMITER //
	CREATE PROCEDURE add_special_request(
	    IN res_id_in INT,
	    IN request_type_in VARCHAR(100),
	    IN request_description_in TEXT
	)
	BEGIN
	    INSERT INTO Special_Request (reservation_id, request_type, date_request, description, status)
	    VALUES (res_id_in, request_type_in, CURDATE(), request_description_in, 'Pending');
	END //
DELIMITER ;

-- Procedure update special_request status
DELIMITER //
	CREATE PROCEDURE update_special_request(
	    IN request_id_in INT,
	    IN new_status_in VARCHAR(50)
	)
	BEGIN
	    UPDATE Special_Request 
	    SET status = new_status_in
	    WHERE request_id = request_id_in;
	END //
DELIMITER ;

-- Procedure delete special request
DELIMITER //
	CREATE PROCEDURE delete_special_request(IN request_id_in INT)
	BEGIN
	    DELETE FROM Special_Request WHERE request_id = request_id_in;
	END //
DELIMITER ;

-- Procedure add new staff
DELIMITER //
	CREATE PROCEDURE add_staff(
	    IN staff_role_in VARCHAR(50),
	    IN first_name_in VARCHAR(50),
	    IN last_name_in VARCHAR(50),
	    IN address_in VARCHAR(100),
	    IN email_in VARCHAR(50),
	    IN contact_number_in VARCHAR(20),
	    IN shift_schedule_in VARCHAR(50),
	    IN admin_id_in INT
	)
	BEGIN
	    INSERT INTO Staff (staff_role, first_name, last_name, address, email, date_hire, contact_number, shift_schedule, admin_id)
	    VALUES (staff_role_in, first_name_in, last_name_in, address_in, email_in, curdate(), contact_number_in, shift_schedule_in, admin_id_in);
	END //
DELIMITER ;

-- Procedure to update staff
DELIMITER //
	CREATE PROCEDURE update_staff(
	    IN staff_id_in INT,
	    IN staff_role_in VARCHAR(50),
	    IN first_name_in VARCHAR(50),
	    IN last_name_in VARCHAR(50),
	    IN address_in VARCHAR(100),
	    IN email_in VARCHAR(50),
	    IN contact_number_in VARCHAR(20),
	    IN shift_schedule_in VARCHAR(50),
	    in admin_id_in int
	)
	BEGIN
	    UPDATE Staff 
	    SET staff_role = staff_role_in, 
	        first_name = first_name_in, 
	        last_name = last_name_in, 
	        address = address_in, 
	        email = email_in, 
	        contact_number = contact_number_in, 
	        shift_schedule = shift_schedule_in,
	        admin_id = admin_id_in
	    WHERE staff_id = staff_id_in;
	END //
DELIMITER ;

-- Procedure to delete staff
DELIMITER //
	CREATE PROCEDURE delete_staff(IN staff_id_in INT)
	BEGIN
	    -- Directly delete the staff member; ON DELETE SET NULL will handle dependencies
	    DELETE FROM Staff WHERE staff_id = staff_id_in;
	END //
DELIMITER ;

-- Procedure add amenity
DELIMITER //
	CREATE PROCEDURE add_amenity(IN amenity_name_in VARCHAR(100))
	BEGIN
	    INSERT INTO Amenities (amenity_name) VALUES (amenity_name_in);
	END //
DELIMITER ;

-- Procedure update amenity
DELIMITER //
	CREATE PROCEDURE update_amenity(IN amenity_id_in INT, IN new_name_in VARCHAR(100))
	BEGIN
	    UPDATE Amenities 
	    SET amenity_name = new_name_in
	    WHERE amenity_id = amenity_id_in;
	END //
DELIMITER ;

-- Procedure delete amenity
DELIMITER //
	CREATE PROCEDURE delete_amenity(IN amenity_id_in INT)
	BEGIN
	    DELETE FROM Amenities WHERE amenity_id = amenity_id_in;
	END //
DELIMITER ;

-- Procedure add amenity to room
DELIMITER //
	CREATE PROCEDURE assign_amenity_to_room(IN room_id_in INT, IN amenity_id_in INT)
	BEGIN
	    INSERT INTO Room_Amenity (room_id, amenity_id) VALUES (room_id_in, amenity_id_in);
	END //
DELIMITER ;

-- Procedure delete amenity to room
DELIMITER //
	CREATE PROCEDURE remove_amenity_from_room(IN room_id_in INT, IN amenity_id_in INT)
	BEGIN
	    DELETE FROM Room_Amenity 
	    WHERE room_id = room_id_in AND amenity_id = amenity_id_in;
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


















