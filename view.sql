-- 1. guest reservation summary view

create view vw_guest_reservations as
select 
    g.guest_id,
    concat(g.first_name, ' ', g.last_name) as guest_name,
    g.email,
    g.phone_number,
    count(r.reservation_id) as total_reservations,
    sum(datediff(rr.check_out_date, rr.check_in_date)) as total_nights_stayed,
    max(rr.check_in_date) as last_visit_date
from guest g
left join reservation r on g.guest_id = r.guest_id
left join reservation_room rr on r.reservation_id = rr.reservation_id
group by g.guest_id, guest_name, g.email, g.phone_number;


-- 2. room occupancy view

create view vw_room_occupancy as
select 
    r.room_id,
    r.room_type,
    r.floor_number,
    r.price_per_night,
    count(rr.reservation_id) as bookings_count,
    sum(rr.number_night) as occupied_nights,
    round(count(rr.reservation_id) * 100.0 / 
        (select count(*) from reservation_room where year(check_in_date) = year(curdate())), 2) as booking_percentage
from room r
left join reservation_room rr on r.room_id = rr.room_id
where year(rr.check_in_date) = year(curdate()) or rr.reservation_id is null
group by r.room_id, r.room_type, r.floor_number, r.price_per_night;


-- 3. revenue analysis view

create view vw_revenue_analysis as
select 
    month(p.payment_date) as month,
    year(p.payment_date) as year,
    sum(p.amount_paid) as total_revenue,
    sum(case when r.partner_id is not null then p.amount_paid else 0 end) as partner_revenue,
    sum(case when r.partner_id is null then p.amount_paid else 0 end) as direct_revenue,
    count(distinct r.guest_id) as unique_guests,
    count(distinct r.reservation_id) as total_reservations
from payment p
join reservation r on p.reservation_id = r.reservation_id
group by year(p.payment_date), month(p.payment_date);


-- 4. staff performance view

create view vw_staff_performance as
select 
    s.staff_id,
    concat(s.first_name, ' ', s.last_name) as staff_name,
    s.staff_role,
    count(r.reservation_id) as reservations_handled,
    sum(p.amount_paid) as revenue_generated,
    count(distinct r.guest_id) as unique_guests_served,
    avg(rev.rating) as avg_guest_rating
from staff s
left join reservation r on s.staff_id = r.staff_id
left join payment p on r.reservation_id = p.reservation_id
left join review rev on r.guest_id = rev.guest_id
group by s.staff_id, staff_name, s.staff_role;



-- 5. room amenities view

create view vw_room_amenities as
select 
    r.room_id,
    r.room_type,
    r.price_per_night,
    group_concat(a.amenity_name order by a.amenity_name separator ', ') as amenities
from room r
left join room_amenity ra on r.room_id = ra.room_id
left join amenities a on ra.amenity_id = a.amenity_id
group by r.room_id, r.room_type, r.price_per_night;



-- 6. partner performance view

create view vw_partner_performance as
select 
    p.partner_id,
    p.partner_name,
    p.partner_type,
    count(r.reservation_id) as bookings_referred,
    sum(py.amount_paid) as revenue_generated,
    sum(py.amount_paid * p.commision_rate / 100) as commission_earned,
    count(distinct r.guest_id) as unique_guests_referred
from partner_ship p
left join reservation r on p.partner_id = r.partner_id
left join payment py on r.reservation_id = py.reservation_id
group by p.partner_id, p.partner_name, p.partner_type;


-- 7. upcoming reservations view

create view vw_upcoming_reservations as
select 
    r.reservation_id,
    concat(g.first_name, ' ', g.last_name) as guest_name,
    rm.room_id,
    rm.room_type,
    rr.check_in_date,
    rr.check_out_date,
    rr.number_night,
    rr.status as reservation_status,
    concat(s.first_name, ' ', s.last_name) as staff_handling
from reservation r
join guest g on r.guest_id = g.guest_id
join reservation_room rr on r.reservation_id = rr.reservation_id
join room rm on rr.room_id = rm.room_id
left join staff s on r.staff_id = s.staff_id
where rr.check_in_date >= curdate()
order by rr.check_in_date;



-- view to get guest reviews along with room details
create view guest_reviews as
select 
    g.first_name, g.last_name, r.comment, r.rating, rm.room_type
from review r
join guest g on r.guest_id = g.guest_id
join room rm on r.room_id = rm.room_id;



