create database HotelDMS
use HotelDMS
/*create table TD(
id_TD int ,
nombre_Hotel varchar(85) not null ,
nombre_area varchar(125) not null,
tipo_habitacion varchar(125) not null,
Nrohabitacion varchar(125) not null CONSTRAINT Nrohabitacion PRIMARY KEY,
)

create table TH(
nro_habitacion varchar(125) not null CONSTRAINT nro_habitacion_pk PRIMARY KEY,
cant_dias_ocupados int,
cant_dias_total int,
costo money,
ingresos money,
	CONSTRAINT nro_habitacion_fk FOREIGN KEY (nro_habitacion) REFERENCES TD(Nrohabitacion) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
);
drop table td
drop table th
select * from TH
select * from Td
/*
SELECT Hotel.Hotels.hotel_name, Room_type.roomtp_name, Room.room_number, Sector.sec_name
FROM     Hotel.Hotels INNER JOIN
                  Sector ON Hotel.Hotels.hotel_id = Sector.sec_hotel_id INNER JOIN
                  Room ON Sector.sec_id = Room.room_sector_id INNER JOIN
                  Room_type ON Room.room_rotp_id = Room_type.roomtp_id*/

SELECT Hotel.Hotels.hotel_name, Room_type.roomtp_name, Room.room_number, Sector.sec_name
FROM     Hotel_Realta.Hotel.Hotels INNER JOIN HotelDMS.DBO.TD
         Sector ON Hotel.Hotels.hotel_id = Sector.sec_hotel_id INNER JOIN
         Room ON Sector.sec_id = Room.room_sector_id INNER JOIN
         Room_type ON Room.room_rotp_id = Room_type.roomtp_id
where Hotel.Hotels.hotel_name is not null*/
--utilidad=ingreso - costo
CREATE TABLE TD (
    nombre_Hotel VARCHAR(85) NOT NULL,
    nombre_area VARCHAR(125) NOT NULL,
    tipo_habitacion VARCHAR(125) NOT NULL,
    Nrohabitacion VARCHAR(125) NOT NULL PRIMARY KEY
);

CREATE TABLE TH (
    nro_habitacion VARCHAR(125) NOT NULL PRIMARY KEY,
    cant_dias_ocupados INT,
    cant_dias_total INT,
    costo MONEY,
    ingresos MONEY,
    CONSTRAINT nro_habitacion_fk FOREIGN KEY (nro_habitacion) REFERENCES TD(Nrohabitacion)
    ON DELETE CASCADE
    ON UPDATE CASCADE
	--CONSTRAINT nombre_fk FOREIGN KEY (nombre) REFERENCES Huesped(Nombre)
 --   ON DELETE CASCADE
 --   ON UPDATE CASCADE
);
CREATE TABLE Huesped (
    Nombre VARCHAR(85) NOT NULL PRIMARY KEY,
    Genero nchar(1) not null,
    Edad varchar(85) not null, 
);

drop table TD
drop table TH

	SELECT Hotel.Hotels.hotel_name, Room_type.roomtp_name, Room.room_number, Sector.sec_name
	FROM     Hotel.Hotels INNER JOIN
					  Sector ON Hotel.Hotels.hotel_id = Sector.sec_hotel_id INNER JOIN
					  Room ON Sector.sec_id = Room.room_sector_id INNER JOIN
					  Room_type ON Room.room_rotp_id = Room_type.roomtp_id
	where room_number not in (select Nrohabitacion from HotelDMS.dbo.TD)



SELECT ha.hotel_name, rt.roomtp_name, ro.room_number, hr.sec_name
FROM     Hotel_Realta.Hotel.Hotels as ha
         INNER JOIN Hotel_Realta.Sector as hr ON ha.hotel_id = hr.sec_hotel_id 
		 INNER JOIN Hotel_Realta.Room as ro ON hr.sec_id = ro.room_sector_id 
		 INNER JOIN Hotel_Realta.Room_type as rt ON ro.room_rotp_id = rt.roomtp_id


SELECT ha.hotel_name, rt.roomtp_name, ro.room_number, hr.sec_name
FROM Hotel_Realta.Hotels as ha
INNER JOIN Hotel_Realta.Sector as hr ON ha.hotel_id = hr.sec_hotel_id 
INNER JOIN Hotel_Realta.Room as ro ON hr.sec_id = ro.room_sector_id 
INNER JOIN Hotel_Realta.Room_type as rt ON ro.room_rotp_id = rt.roomtp_id;





SELECT
   --pod.borde_id,
   concat(ho.hotel_id,ha.room_id,sec.sec_id) as numero_habitacion, -- numero habitacion concat
   --(hotel,habitacion,sector)
       DATEDIFF(day,ha.fecha_inagural,max(pod.borde_checkout)) as total_dias,--inaguracion - ultima checkout
       sum(DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)) as dias_ocupado, --detalle  chequin -chequot  
      sum( ha.costo*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)) as costo,-- 
      sum(pod.borde_price*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)  -ha.costo) as ingresos
    
FROM Hotel_Realta.dbo.Room  as ha
INNER JOIN Hotel_Realta.Hotel.Facilities as fa  on  fa.faci_room_id =ha.room_id
inner join Hotel_Realta.Hotel.Hotels as ho on ho.hotel_id=fa.faci_hotel_id
inner join Hotel_Realta.Booking.booking_order_detail pod on pod.borde_faci_id=fa.faci_id  
inner join Hotel_Realta.dbo.Sector as sec  on ha.room_sector_id=sec.sec_id

GROUP BY  
   -- pod.borde_id,
     ho.hotel_id,sec.sec_id,
     ha.room_id,
	 ha.fecha_inagural,
     --pod.borde_checkin,pod.borde_checkout,
	 ha.costo


ORDER BY 
   --pod.borde_id
	ha.room_id
/*



SELECT
   --pod.borde_id,
   distinct concat(ho.hotel_id,ha.room_id,sec.sec_id) as numero_habitacion, -- numero habitacion concat
   --(hotel,habitacion,sector)
   DATEDIFF(day,ha.fecha_inagural,max(pod.borde_checkout))as total_dias,--inaguracion - ultima checkout
   DATEDIFF(day,pod.borde_checkin,pod.borde_checkout) as dias_ocupado, --detalle  chequin -chequot  

   ha.costo*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout) as costo,-- 
   sum(pod.borde_price*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)  -ha.costo) as ingresos

    
FROM Hotel_Realta.Booking.booking_order_detail pod
INNER JOIN Hotel_Realta.Hotel.Facilities as fa  on  fa.faci_id =pod.borde_faci_id
inner join Hotel_Realta.Hotel.Hotels as ho on ho.hotel_id=fa.faci_hotel_id
inner join Hotel_Realta.dbo.Room as ha  on  fa.faci_room_id =ha.room_id
inner join Hotel_Realta.dbo.Sector as sec  on ha.room_sector_id=sec.sec_id


WHERE NOT EXISTS (
    SELECT 1
    FROM HotelDMS.dbo.th   fac
    WHERE  concat(ho.hotel_id,ha.room_id,sec.sec_id)= fac.nro_habitacion
)


GROUP BY  
    pod.borde_id,
   ho.hotel_id,sec.sec_id,
     ha.room_id,
	 ha.fecha_inagural,
     pod.borde_checkin,pod.borde_checkout,
	 ha.costo


ORDER BY 
   --pod.borde_id
	ha.room_id

--SELECT Hotel.Hotels.hotel_name, Room_type.roomtp_name, Room.room_number, Sector.sec_name
--FROM     Hotel.Hotels INNER JOIN
--                  Sector ON Hotel.Hotels.hotel_id = Sector.sec_hotel_id INNER JOIN
--                  Room ON Sector.sec_id = Room.room_sector_id INNER JOIN
--                  Room_type ON Room.room_rotp_id = Room_type.roomtp_id

SELECT
   --pod.borde_id,
   concat(ho.hotel_id,ha.room_id,sec.sec_id) as numero_habitacion, -- numero habitacion concat
   --(hotel,habitacion,sector)
   --ho. as numero_habitacion,
   DATEDIFF(day,ha.fecha_inagural,max(pod.borde_checkout))as total_dias,--inaguracion - ultima checkout
   DATEDIFF(day,pod.borde_checkin,pod.borde_checkout) as dias_ocupado, --detalle  chequin -chequot  

   ha.costo*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout) as costo,-- 
   sum(pod.borde_price*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)  -ha.costo) as ingresos

    
FROM Hotel_Realta.Booking.booking_order_detail pod
INNER JOIN Hotel_Realta.Hotel.Facilities as fa  on  fa.faci_id =pod.borde_faci_id
inner join Hotel_Realta.Hotel.Hotels as ho on ho.hotel_id=fa.faci_hotel_id
inner join Hotel_Realta.dbo.Room as ha  on  fa.faci_room_id =ha.room_id
inner join Hotel_Realta.dbo.Sector as sec  on ha.room_sector_id=sec.sec_id

WHERE NOT EXISTS (
    SELECT 1
    FROM HotelDMS.dbo.th   fac
    WHERE  concat(ho.hotel_id,ha.room_id,sec.sec_id)= fac.nro_habitacion
)
GROUP BY  
    pod.borde_id,
   ho.hotel_id,sec.sec_id,
     ha.room_id,
	 ha.fecha_inagural,
     pod.borde_checkin,pod.borde_checkout,
	 ha.costo


ORDER BY 
   --pod.borde_id
	ha.room_id

-- La consulta con errores corregidos y utilizando alias adecuadamente
--SELECT H.hotel_name, RT.roomtp_name, R.room_number, S.sec_name
--FROM Hotel_Realta.Hotel.Hotels H
--INNER JOIN HotelDMS.DBO.TD T ON H.hotel_id = T.id_TD
--INNER JOIN Sector S ON T.id_TD = S.sec_hotel_id
--INNER JOIN Room R ON S.sec_id = R.room_sector_id
--INNER JOIN Room_type RT ON R.room_rotp_id = RT.roomtp_id

--
--SELECT
--   --pod.borde_id,
--   concat(ho.hotel_id,ha.room_id,sec.sec_id) as numero_habitacion,
--   --ho.hotel_id as numero_habitacion,
--   DATEDIFF(day,ha.fecha_inagural,max(pod.borde_checkout))as total_dias,
--   DATEDIFF(day,pod.borde_checkin,pod.borde_checkout) as dias_ocupado,
   
--   --sum(ha.fecha_inagural*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)) as costo,
--   sum(pod.borde_price*DATEDIFF(day,pod.borde_checkin,pod.borde_checkout)  -ha.costo) as ingresos

    
--FROM Hotel_Realta.Booking.booking_order_detail pod
--INNER JOIN Hotel_Realta.Hotel.Facilities as fa  on  fa.faci_id =pod.borde_faci_id
--inner join Hotel_Realta.Hotel.Hotels as ho on ho.hotel_id=fa.faci_hotel_id
--inner join Hotel_Realta.dbo.Room as ha  on  fa.faci_room_id =ha.room_id
--inner join Hotel_Realta.dbo.Sector as sec  on ha.room_sector_id=sec.sec_id


----WHERE NOT EXISTS (
----    SELECT 1
----    FROM Hotel_RealtaE.dbo.th   fac
----    WHERE  concat(ho.hotel_id,ha.room_id,sec.sec_id)= fac.numero_habitacion
----)

--GROUP BY  
--    pod.borde_id,
--   ho.hotel_id,sec.sec_id,
--     ha.room_id,
--	 ha.fecha_inagural,
--     pod.borde_checkin,pod.borde_checkout,
--	 ha.costo


--ORDER BY 
--   --pod.borde_id
--	ha.room_id
