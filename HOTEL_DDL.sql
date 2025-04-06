create database Hotel_Reservation;
use Hotel_Reservation;

create table Staff(
	staff_id int primary key auto_increment,
	staff_role varchar(50) not null,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	address varchar(100) not null,
	email varchar(50) not null,
	date_hire date not null,
	contact_number varchar(20) not null,
	shift_schedule varchar(50) not null,
	admin_id int null 
);

alter table Staff add constraint staff_fk1 foreign key (admin_id) references Staff(staff_id) on delete set null;

create table Guest(
	guest_id int primary key auto_increment,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	address varchar(100) not null,
	date_of_birth date not null,
	date_of_register date not null,
	phone_number varchar(20) not null,
	email varchar(50) not null
);

create table Room(
	room_id int primary key auto_increment,
	bed_count int not null,
	floor_number int not null,
	price_per_night decimal(10,2) not null,
	room_type varchar(100) not null,
	discount decimal(4,2) default 0 not null,
	status varchar(50) not null
);

create table Partner_ship(
	partner_id int primary key auto_increment,
	partner_name varchar(100) not null,
	contact_number varchar(20) not null,
	partner_type varchar(100) not null,
	commision_rate decimal(4,2) default 0 not null,
	email varchar(50) not null,
	contact_person varchar(100) not null
);

create table Reservation(
	reservation_id int primary key auto_increment,
	reservation_date date not null,
	staff_id int,
	guest_id int,
	partner_id int
);

alter table Reservation add constraint reservation_fk1 foreign key (staff_id) references Staff(staff_id) on delete set null;
alter table Reservation add constraint reservation_fk2 foreign key (guest_id) references Guest(guest_id) on delete set null;
alter table Reservation add constraint reservation_fk3 foreign key (partner_id) references Partner_ship(partner_id) on delete set null;

create table Reservation_Room(
	reservation_id int,
	room_id int,
	check_in_date date not null,
	check_out_date date not null,
	number_night int not null,
	member int not null,
	status varchar(50) not null
);

alter table Reservation_Room add constraint reservation_room_fk1 foreign key (reservation_id) references Reservation(reservation_id) on delete cascade;
alter table Reservation_Room add constraint reservation_room_fk2 foreign key (room_id) references Room(room_id) on delete cascade;
alter table Reservation_Room add constraint primary key (reservation_id, room_id);

create table Special_Request(
	request_id int primary key auto_increment,
	reservation_id int,
	request_type varchar(100) not null,
	date_request date not null,
	description text not null,
	status varchar(50) not null
);

alter table Special_Request add constraint special_request_fk1 foreign key (reservation_id) references Reservation(reservation_id) on delete set null;

create table Payment(
	payment_id int primary key auto_increment,
	payment_date date not null, 
	payment_method varchar(100) not null,
	amount_paid decimal(10,2) not null,
	trancation_id varchar(50) not null,
	status varchar(50) not null,
	reservation_id int
);

alter table Payment add constraint payment_fk foreign key (reservation_id) references Reservation(reservation_id) on delete set null;

create table Review(
	review_id int primary key auto_increment,
	submission_date date not null,
	comment text null,
	rating int check (rating >= 0 and rating <=5) not null,
	guest_id int,
	room_id int
);

alter table Review add constraint review_fk1 foreign key (guest_id) references Guest(guest_id) on delete set null;
alter table Review add constraint review_fk2 foreign key (room_id) references Room(room_id) on delete set null;

create table Amenities(
	amenity_id int primary key auto_increment,
	amenity_name varchar(100) not null
);

create table Room_amenity(
	room_id int not null,
	amenity_id int not null,
	primary key (room_id, amenity_id)
);

alter table Room_amenity add constraint room_amenity_fk1 foreign key (room_id) references Room(room_id) on delete cascade;
alter table Room_amenity add constraint room_amenity_fk2 foreign key (amenity_id) references Amenities(amenity_id) on delete cascade;

