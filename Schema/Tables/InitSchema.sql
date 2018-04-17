-- =================================================
-- Sean Lee
-- 17 Tables created for SQL Saturday Event
-- =================================================

CREATE PROCEDURE sp_initschema
AS
BEGIN

	create table region
	(
		zip_code varchar(20) not null,
		city varchar(128) not null,
		state varchar(50) not null
	)

	create unique index region_zip_code_uindex
		on region (zip_code)

	create table address
	(
		id_address int not null identity
			primary key,
		address_street varchar(128) not null,
		zip_code varchar(20) not null
			constraint address_region_zip_code_fk
				references region (zip_code)
	)

	create unique index address_id_address_uindex
		on address (id_address)

	create table venue
	(
		id_venue int not null identity
			primary key,
		user_group varchar(128) not null,
		id_address int
			constraint venue_address_id_address_fk
				references address (id_address)
	)

	create unique index venue_id_venue_uindex
		on venue (id_venue)

	create table room
	(
		id_room int not null,
		id_venue int not null
			constraint room_venue_id_venue_fk
				references venue (id_venue),
		capacity int default 0 not null,
		primary key (id_room, id_venue)
	)

	create table event
	(
		id_event int not null identity
			constraint event_id_event_pk
				primary key,
		id_venue int
			constraint event_venue_id_venue_fk
				references venue (id_venue),
		name varchar(128),
		region varchar(128),
		eventDate datetime,
		eventYear int,
		city varchar(50)
	)

	create unique index event_id_event_uindex
		on event (id_event)

	create table person
	(
		id_person int not null identity
			primary key,
		first_name nvarchar(60) not null,
		last_name nvarchar(60) not null,
		email varchar(128),
		id_address int
	)

	create unique index person_id_person_uindex
		on person (id_person)

	create table attendee
	(
		id_event int
			constraint attendee_event_id_event_fk
				references event (id_event),
		id_person int not null
			constraint attendee_id_person_pk
				primary key
			constraint attendee_person_id_person_fk
				references person (id_person)
	)

	create table vendorAssociation
	(
		id_vendor int not null identity,
		companyName varchar(128),
		id_person int not null
			constraint vendorAssociation_person_id_person_fk
				references person (id_person),
		primary key (id_vendor, id_person)
	)

	create unique index vendorAssociation_id_vendor_uindex
		on vendorAssociation (id_vendor)

	create table booth  --table is a protected word, hence table == booth in my naming schema
	(
		id_table int not null identity,
		id_venue int not null,
		id_person int not null
			constraint booth_person_id_person_fk
				references person (id_person),
		id_event int not null
			constraint booth_event_id_event_fk
				references event (id_event),
		id_vendor int not null
			constraint booth_vendorAssociation_id_vendor_fk
				references vendorAssociation (id_vendor),
		primary key (id_table, id_venue)
	)

	create table track
	(
		id_track int not null identity
			primary key,
		content varchar(128)
	)

	create unique index track_id_track_uindex
		on track (id_track)

	create table lecture -- class is a protected word, hence class == lecture in my naming schema
	(
		id_lecture int not null
			constraint lecture_id_lecture_pk
				primary key,
		id_presentation int not null identity,
		id_track int not null
			constraint lecture_track_id_track_fk
				references track (id_track),
		description text not null
	)

	create unique index resentations_id_presentation_uindex
		on lecture (id_presentation)

	create table grade
	(
		id_presentation int not null,
		id_person int not null
			constraint grade_person_id_person_fk
				references person (id_person),
		grade varchar(50) not null,
		primary key (id_presentation, id_person)
	)

	create table schedule
	(
		id_presentation int not null
			constraint schedule_id_presentation_pk
				primary key,
		id_room int not null,
		start_time datetime not null,
		duration int default 60 not null
	)

	create table sponsor
	(
		id_sponsor int not null identity
			primary key,
		sponsor_name varchar(50),
		sponsor_type varchar(50)
	)

	create unique index sponsor_id_sponsor_uindex
		on sponsor (id_sponsor)

	create table presentation
	(
		id_presentation int not null identity
			primary key,
		speaker int,
		name varchar(128),
		complexity varchar(50),
		id_event int
			constraint presentation_event_id_event_fk
				references event (id_event)
	)

	create unique index presentation_id_presentation_uindex
		on presentation (id_presentation)

	alter table lecture
		add constraint lecture_presentation_id_presentation_fk
			foreign key (id_presentation) references presentation (id_presentation)

	alter table lecture
		add constraint presentation_ClassDetails_id_lecture_fk
			foreign key (id_presentation) references presentation (id_presentation)

	alter table grade
		add constraint grade_presentation_id_presentation_fk
			foreign key (id_presentation) references presentation (id_presentation)

	alter table schedule
		add constraint schedule_presentation_id_presentation_fk
			foreign key (id_presentation) references presentation (id_presentation)

	create table organizer
	(
		id_person int not null
			primary key
			constraint organizer_person_id_person_fk
				references person (id_person),
		id_event int
			constraint organizer_event_id_event_fk
				references event (id_event)
	)

	create table volunteer
	(
		id_person int not null
			primary key
			constraint volunteer_person_id_person_fk
				references person (id_person),
		id_event int
			constraint volunteer_event_id_event_fk
				references event (id_event)
	)

END
go
