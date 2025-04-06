-- 1. Insert Data into `Staff` Table
INSERT INTO Staff (staff_role, first_name, last_name, address, email, date_hire, contact_number, shift_schedule, admin_id) 
VALUES 
('Manager', 'John', 'Doe', '123 Main St, City', 'john.doe@example.com', '2021-01-15', '555-1234', 'Morning', NULL),
('Receptionist', 'Jane', 'Smith', '456 Oak St, City', 'jane.smith@example.com', '2022-03-10', '555-5678','Morning', 1),
('Manager', 'Alice', 'Johnson', '789 Pine St, City', 'alice.johnson@example.com', '2023-05-22', '555-9101','Morning', NULL),
('Housekeeper', 'Emily', 'Brown', '101 Maple St, City', 'emily.brown@example.com', '2020-11-01', '555-1122','Morning', 3),
('Concierge', 'Robert', 'Wilson', '202 Elm St, City', 'robert.wilson@example.com', '2019-07-12', '555-2233','Morning', 3),
('Security', 'David', 'Martinez', '303 Birch St, City', 'david.martinez@example.com', '2018-08-25', '555-3344','Morning', 3);

-- 2. Insert Data into `Guest` Table
INSERT INTO Guest (first_name, last_name, address, date_of_birth, date_of_register, phone_number, email)
VALUES
('Michael', 'Taylor', '123 Elm St, City', '1985-06-23', '2024-02-10', '555-1122', 'michael.taylor@example.com'),
('Sarah', 'Brown', '321 Birch St, City', '1990-11-17', '2024-03-01', '555-3344', 'sarah.brown@example.com'),
('Emily', 'Davis', '202 Oak St, City', '1978-05-12', '2024-01-05', '555-5566', 'emily.davis@example.com'),
('John', 'Martinez', '123 Pine St, City', '1982-02-09', '2024-02-12', '555-7788', 'john.martinez@example.com'),
('Sophia', 'Gonzalez', '789 Cedar St, City', '1995-08-22', '2024-03-10', '555-9900', 'sophia.gonzalez@example.com'),
('Lucas', 'Rodriguez', '456 Maple St, City', '1980-10-30', '2024-03-05', '555-2233', 'lucas.rodriguez@example.com');

-- 3. Insert Data into `Room` Table
INSERT INTO Room (bed_count, floor_number, price_per_night, room_type, discount, status)
VALUES
(1, 1, 100.00, 'Single', 0.10, 'Available'),
(2, 2, 150.00, 'Double', 0.05, 'Available'),
(3, 3, 200.00, 'Suite', 0.15, 'Occupied'),
(1, 4, 120.00, 'Single', 0.05, 'Available'),
(2, 1, 180.00, 'Double', 0.10, 'Available'),
(3, 2, 250.00, 'Suite', 0.20, 'Occupied');

-- 4. Insert Data into `Partner_ship` Table
INSERT INTO Partner_ship (partner_name, contact_number, partner_type, commision_rate, email, contact_person)
VALUES
('TravelAgencyA', '555-1123', 'Travel Agent', 0.10, 'agencyA@example.com', 'Alice Green'),
('CorporateB', '555-2234', 'Corporate Partner', 0.12, 'corporateB@example.com', 'Bob White'),
('HotelX', '555-3345', 'Hotel Chain', 0.08, 'hotelX@example.com', 'Charlie Black'),
('TourismCo', '555-4456', 'Tour Operator', 0.15, 'tourismCo@example.com', 'Debbie Blue'),
('FlightHub', '555-5567', 'Flight Provider', 0.05, 'flighthub@example.com', 'Eva Yellow'),
('LuxuryTravel', '555-6678', 'Luxury Travel', 0.18, 'luxurytravel@example.com', 'Frank Gold');

-- 5. Insert Data into `Reservation` Table
INSERT INTO Reservation (reservation_date, staff_id, guest_id, partner_id)
VALUES
('2024-03-15', 1, 1, 1),
('2024-03-16', 1, 2, 2),
('2024-03-17', 1, 3, 3),
('2024-03-18', 1, 4, 4),
('2024-03-19', 1, 5, 5),
('2024-03-20', 1, 6, 6);

-- 6. Insert Data into `Reservation_Room` Table
INSERT INTO Reservation_Room (reservation_id, room_id, check_in_date, check_out_date, number_night, member, status)
VALUES
(1, 1, '2024-03-20', '2024-03-25', 5, 1, 'Confirmed'),
(1, 2, '2024-03-20', '2024-03-23', 3, 2, 'Confirmed'),
(2, 3, '2024-03-17', '2024-03-22', 5, 1, 'Confirmed'),
(3, 4, '2024-03-19', '2024-03-22', 3, 1, 'Confirmed'),
(4, 5, '2024-03-21', '2024-03-24', 3, 2, 'Confirmed'),
(5, 6, '2024-03-22', '2024-03-27', 5, 1, 'Confirmed');

-- 7. Insert Data into `Special_Request` Table
INSERT INTO Special_Request (reservation_id, request_type, date_request, description, status)
VALUES
(1, 'Extra Bed', '2024-03-20', 'Request for an extra bed in Room 1', 'Approved'),
(2, 'Late Check-in', '2024-03-16', 'Request for a late check-in at 11 PM', 'Pending'),
(3, 'Early Check-out', '2024-03-17', 'Request for early check-out at 9 AM', 'Approved'),
(4, 'Additional Towels', '2024-03-18', 'Request for additional towels in Room 2', 'Pending'),
(5, 'Room Upgrade', '2024-03-19', 'Request for a room upgrade to Suite', 'Approved'),
(6, 'Extra Pillows', '2024-03-20', 'Request for extra pillows in Room 3', 'Approved');

-- 8. Insert Data into `Payment` Table
INSERT INTO Payment (payment_date, payment_method, amount_paid, trancation_id, status, reservation_id)
VALUES
('2024-03-18', 'Credit Card', 500.00, 'TXN12345', 'Completed', 1),
('2024-03-17', 'Debit Card', 600.00, 'TXN12346', 'Completed', 2),
('2024-03-20', 'Credit Card', 700.00, 'TXN12347', 'Completed', 3),
('2024-03-21', 'PayPal', 800.00, 'TXN12348', 'Completed', 4),
('2024-03-22', 'Cash', 750.00, 'TXN12349', 'Completed', 5),
('2024-03-23', 'Credit Card', 950.00, 'TXN12350', 'Completed', 6);

-- 9. Insert Data into `Review` Table
INSERT INTO Review (submission_date, comment, rating, guest_id, room_id)
VALUES
('2024-03-22', 'Great stay! Clean room and friendly staff.', 5, 1, 1),
('2024-03-23', 'Good, but room was a bit noisy.', 3, 2, 2),
('2024-03-24', 'Room was comfortable, but bathroom needs improvement.', 4, 3, 3),
('2024-03-25', 'Excellent service and great location.', 5, 4, 4),
('2024-03-26', 'The room was very clean, but a bit small.', 4, 5, 5),
('2024-03-27', 'Overall, a nice stay. Would recommend!', 4, 6, 6);

-- 10. Insert Data into `Amenities` Table
INSERT INTO Amenities (amenity_name)
VALUES
('Wi-Fi'),
('Air Conditioning'),
('Swimming Pool'),
('Gym'),
('Spa'),
('Parking');

-- 11. Insert Data into `Room_amenity` Table
INSERT INTO Room_amenity (room_id, amenity_id)
VALUES
(1, 1),  -- Room 1 has Wi-Fi
(1, 2),  -- Room 1 has Air Conditioning
(2, 3),  -- Room 2 has Swimming Pool
(2, 4),  -- Room 2 has Gym
(3, 5),  -- Room 3 has Spa
(4, 6),  -- Room 4 has Parking
(5, 1),  -- Room 5 has Wi-Fi
(6, 2);  -- Room 6 has Air Conditioning
