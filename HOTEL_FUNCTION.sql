-- Function calculate total cost of reservation
DELIMITER //
CREATE FUNCTION get_total_reservation_cost(res_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_cost DECIMAL(10,2);
    
    SELECT SUM(r.price_per_night * rr.number_night * (1 - r.discount)) 
    INTO total_cost
    FROM Reservation_Room rr
    JOIN Room r ON rr.room_id = r.room_id
    WHERE rr.reservation_id = res_id;

    RETURN IFNULL(total_cost, 0);
END //
DELIMITER ;
SELECT get_total_reservation_cost(2);

-- Function get total reservation by staff
DELIMITER //
CREATE FUNCTION get_staff_reservation_count(staff_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE reservation_count INT;
    
    SELECT COUNT(*) INTO reservation_count
    FROM Reservation r
    WHERE r.staff_id = staff_id;

    RETURN reservation_count;
END //
DELIMITER ;
SELECT get_staff_reservation_count(1);

-- Function find cost partner earn between two dates
delimiter //
create function partner_ship_cost (partner_id int, start_date date, end_date date) returns decimal(10,2)
begin
	declare cost decimal(10,2) default 0;
	select sum(ps.commision_rate * (r2.price_per_night*(1 - r2.discount)) * rr.number_night) into cost from reservation r 
		join reservation_room rr on r.reservation_id = rr.reservation_id 
		join room r2 on r2.room_id = rr.room_id 
		join partner_ship ps on ps.partner_id = r.partner_id 
	where r.partner_id = partner_id and r.reservation_date between start_date and end_date;
	return cost;
end //
delimiter ;

select partner_ship_cost(1, '2025-03-31', '2025-04-30');

-- function check room available or not
delimiter //
create function check_available_room (room_id int) returns int
begin
	declare result_ int default 0;
	if exists (select 1 from room r where r.status = 'available' and r.room_id = room_id) then set result_ = 1;
	end if;
	return result_;
end //
delimiter ;

select check_available_room(4);

-- Function get total price between two date
delimiter //
create function get_total_price_reservation (start_date date, end_date date) returns decimal(10,2)
begin
	declare total decimal(10,2) default 0;
	select sum(r.price_per_night * rr.number_night * (1 - r.discount)) into total
    from Reservation_Room rr
    join reservation r1 on rr.reservation_id = r1.reservation_id 
    join Room r on rr.room_id = r.room_id
    where r1.reservation_date between start_date and end_date ;
	return total;
end //
delimiter ;
select get_total_price_reservation('2024-03-01', '2024-03-16');

-- Function get room which is mostly booked
delimiter //
create function get_room_most_book () returns int
begin
	declare room_ int default 0;
	select rr.room_id into room_ from reservation_room rr group by rr.room_id order by count(*) desc limit 1;
	return room_;
end //
delimiter ;
select get_room_most_book();

-- Function get guest which mostly book
delimiter //
create function get_guest_most_book () returns varchar(100)
begin
	declare guest varchar(100) default '';
	select concat("ID : ",r.guest_id, " Name : ", g.first_name, " ", g.last_name) into guest from reservation r 
	join guest g on r.guest_id = g.guest_id 
	group by r.guest_id order by count(*) desc limit 1;
	return guest;
end //
delimiter ;
select get_guest_most_book();




































