use hotel_reservation;

-- Q1: retrieves the total number of reservations made by each guest in 2024
select 
    guest_id,
    count(*) as total_reservations
from 
    reservation
where 
    year(reservation_date) = 2024
group by 
    guest_id;

-- Q2: select all staff members
select * from staff;

-- Q3: find all guests who registered after january 1, 2024
select * from guest
where date_of_register > '2024-01-01';

-- Q4: get the details of reservations and related guests
select r.reservation_id, r.reservation_date, g.first_name as guest_first_name, g.last_name as guest_last_name
from reservation r
join guest g on r.guest_id = g.guest_id;

-- Q5: find available rooms with price below 150
select * from room
where status = 'available' and price_per_night < 150;

-- Q6: list all reviews for room 1
select review_id, submission_date, comment, rating
from review
where room_id = 1;

-- Q7: list all review
select review_id, submission_date, comment, rating, room_id
from review;

-- Q8: get special requests pending approval
select * from special_request
where status = 'pending';

-- Q9: find reservations made by guest 'michael taylor'
select r.reservation_id, r.reservation_date, r.staff_id, r.partner_id
from reservation r
join guest g on r.guest_id = g.guest_id
where g.first_name = 'michael' and g.last_name = 'taylor';

-- Q10: get payments for completed reservations
select p.payment_id, p.payment_date, p.amount_paid, p.payment_method
from payment p
join reservation r on p.reservation_id = r.reservation_id
where p.status = 'completed';

-- Q11: get room amenities for room 2
select a.amenity_name
from room_amenity ra
join amenities a on ra.amenity_id = a.amenity_id
where ra.room_id = 2;

-- Q12: find all special requests for room 1
select * from special_request
where reservation_id in (select reservation_id from reservation_room where room_id = 1);

-- Q13: get reservations with special requests for early check-out
select r.reservation_id, r.reservation_date, sr.request_type, sr.description
from reservation r
join special_request sr on r.reservation_id = sr.reservation_id
where sr.request_type = 'early check-out';

-- Q14: list all staff with their roles and shift schedules
select staff_id, staff_role, shift_schedule
from staff;

-- Q15: get all reviews for a specific guest (e.g., guest id 1)
select * from review
where guest_id = 1;

-- Q16: find all reservations by partner 'travelagencya'
select r.reservation_id, r.reservation_date
from reservation r
join partner_ship p on r.partner_id = p.partner_id
where p.partner_name = 'travelagencya';

-- Q17: retrieves the payment records where the payment was made before the guest checked out
select 
    p.payment_id,
    p.payment_date,
    p.payment_method,
    p.amount_paid,
    p.trancation_id,
    p.status as payment_status,
    rr.check_out_date,
    rr.room_id,
    g.first_name as guest_first_name,
    g.last_name as guest_last_name
from 
    payment p
join 
    reservation r on p.reservation_id = r.reservation_id
join 
    reservation_room rr on r.reservation_id = rr.reservation_id
join 
    guest g on r.guest_id = g.guest_id
where 
    p.payment_date > rr.check_out_date;

-- q18: list available rooms
select * from room r where  r.status ='available';

-- Q19: get booking details for a guest
select 
    g.guest_id,
    g.first_name,
    g.last_name,
    r.reservation_id,
    rr.check_in_date,  
    rr.check_out_date, 
    (rr.number_night * rm.price_per_night) as calculated_total_amount,  
    rr.room_id,
    rm.room_type,  
    rev.rating,  
    rr.check_in_date as room_check_in,
    rr.check_out_date as room_check_out
from guest g
join reservation r on g.guest_id = r.guest_id
join reservation_room rr on r.reservation_id = rr.reservation_id
join review rev on rr.room_id = rev.room_id and rev.guest_id = g.guest_id  
join room rm on rr.room_id = rm.room_id  
where g.guest_id = 1;

-- Q20: total revenue from bookings
select sum(rr.number_night * r.price_per_night * (1 - r.discount / 100)) as total_revenue
from reservation_room rr
join room r on rr.room_id = r.room_id;

--  Q21: room occupancy report
select r.room_type,
count(distinct rr.room_id) as occupancy_count
from reservation_room rr
join room r on rr.room_id = r.room_id
where rr.check_in_date is not null 
and rr.check_out_date is not null
group by r.room_type
order by occupancy_count desc;

--  Q22: retrieve information about payments made for reservations
select 
    p.payment_id,
    p.payment_date,
    p.payment_method,
    p.amount_paid,
    p.trancation_id,
    p.status as payment_status,
    r.reservation_id,
    g.first_name as guest_first_name,
    g.last_name as guest_last_name
from payment p
join reservation r on p.reservation_id = r.reservation_id
join guest g on r.guest_id = g.guest_id
order by p.payment_date desc;

-- Q23: calculate occupancy rate for each room type
select 
    r.room_type,
    count(rr.room_id) as total_bookings,
    (count(rr.room_id) * 100.0 / nullif(count(rm.room_id), 0)) as occupancy_rate
from room r
left join reservation_room rr on r.room_id = rr.room_id
left join room rm on r.room_type = rm.room_type  -- ensure correct total rooms per type
group by 
r.room_type
order by 
    occupancy_rate desc;
-- q24: find all guests with multiple bookings
select 
    g.guest_id,
    g.first_name,
    g.last_name,
    count(r.reservation_id) as total_bookings
from  guest g
join reservation r on g.guest_id = r.guest_id
group by g.guest_id, g.first_name, g.last_name
having count(r.reservation_id) > 1
order by total_bookings desc;

-- Q25: calculate average booking duration by room type
select 
    r.room_type,
    avg(rr.number_night) as average_booking_duration
from reservation_room rr
join room r on rr.room_id = r.room_id
group by r.room_type
order by average_booking_duration desc;

-- Q26: total revenue per room type
select 
    r.room_type,
    sum(rr.number_night * r.price_per_night) as total_revenue
from 
    reservation_room rr
join 
    room r on rr.room_id = r.room_id
group by 
    r.room_type
order by 
    total_revenue desc;

-- Q27: identify high-spending guests (guests who have spent more than a given amount)
select 
    g.guest_id,
    g.first_name,
    g.last_name,
    sum(p.amount_paid) as total_spent
from 
    guest g
join 
    reservation r on g.guest_id = r.guest_id
join 
    payment p on r.reservation_id = p.reservation_id
group by 
    g.guest_id
having 
    total_spent > 1000  
order by 
    total_spent desc;

-- Q28: find most popular room type based on bookings
select 
    r.room_type,
    count(rr.room_id) as bookings_count
from 
    reservation_room rr
join 
    room r on rr.room_id = r.room_id
group by 
    r.room_type
order by 
    bookings_count desc
limit 1;

-- Q29: identify top 5 guests by spending
select 
    g.guest_id,
    g.first_name,
    g.last_name,
    sum(p.amount_paid) as total_spent
from 
    guest g
join 
    reservation r on g.guest_id = r.guest_id
join 
    payment p on r.reservation_id = p.reservation_id
group by 
    g.guest_id, g.first_name, g.last_name
order by 
    total_spent desc
limit 5;

-- Q30: total revenue from bookings
select sum(amount_paid) from payment ;

-- Q31 :calculate occupancy rate for each room type
select r.room_type, 
       count(rr.reservation_id) / count(distinct r.room_id) * 100 as occupancy_rate
from room r
left join reservation_room rr on r.room_id = rr.room_id
group by r.room_type;

-- Q32 :generate monthly revenue report for the current year
select month(p.payment_date) as month, sum(p.amount_paid) as total_revenue
from payment p
where year(p.payment_date) = year(curdate())
group by month(p.payment_date)
order by month;

-- Q33 :calculate room occupancy for each month
select month(rr.check_in_date) as month, count(distinct rr.room_id) as occupied_rooms
from reservation_room rr
group by month(rr.check_in_date)
order by month;

-- Q34: find all payments with late payments status (payments made after check-out)
select p.*, rr.check_out_date
from payment p
join reservation r on p.reservation_id = r.reservation_id
join reservation_room rr on r.reservation_id = rr.reservation_id
where p.payment_date > rr.check_out_date;


















































