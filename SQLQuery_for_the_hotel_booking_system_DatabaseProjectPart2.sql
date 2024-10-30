﻿--                                       Database Project Part 2 

-- 1. Indexing Requirements 
--    • Hotel Table Indexes 
--      ✓ Add a non-clustered index on the Name column to 
--         optimize queries that search for hotels by name. 
           create nonclustered index idx_hotel_name
           on hotel (Hotel_Name)


--      ✓ Add a non-clustered index on the Rating column 
--         to speed up queries that filter hotels by rating. 
           create nonclustered index idx_hotel_rating
           on hotel (Rating)



--    • Room Table Indexes 
--      ✓ Add a clustered index on the HotelID and RoomNumber 
--         columns to optimize room lookup within a hotel 
		   create nonclustered index idx_Room_HotelID_RoomNumber
           on Room (HotelID, RoomNumber)


--      ✓ Add a non-clustered index on the RoomType column 
--         to improve searches filtering by room type. 
           create nonclustered index idx_Room_RoomType
           on Room (Type)



--    • Booking Table Indexes 
--      ✓ Add a non-clustered index on GuestID to optimize 
--         guest-related booking searches. 
           create nonclustered index idx_Booking_Guestid 
           on Booking (Guestid)


--      ✓ Add a non-clustered index on the Status column to 
--         improve filtering of bookings by status. 
           create nonclustered index idx_Booking_Status 
           on Booking (status)
		   

--      ✓ Add a composite index on RoomID, CheckInDate, and 
--         CheckOutDate for efficient querying of booking schedules.
           create nonclustered index idx_Booking_Roomid_Checkin_Checkout 
		   on Booking (RoomID, CheckinDate, CheckoutDate)

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

-- 2. Views 
--    • View 1: ViewTopRatedHotels 
--      ✓Create a view that displays the top-rated hotels (rating above 4.5)
--        along with the total number of rooms and average room price for each hotel. 

         create view viewTopRatedHotels as
         select h.HotelID, h.Hotel_Name as HotelName,h.Rating,
                count(r.RoomID) as TotalRooms,
                avg(r.PricePerNight) as AverageRoomPrice
         from Hotel h join 
              Room r on h.HotelID = r.HotelID
         where h.Rating > 4.5
         group by h.HotelID, h.Hotel_Name, h.Rating

		 select * from ViewTopRatedHotels

--    • View 2: ViewGuestBookings 
--      ✓Create a view that lists each guest along with their total number of bookings
--        and the total amount spent on all bookings. 
        create view ViewGuestBookings as
        select g.GuestID, g.Guest_Name,
		      count(b.BookingID) as TotalBookings,
              sum(b.TotalCost) as TotalAmountSpent
        from Guest g left join 
             Booking b on g.GuestID = b.GuestID
        group by g.GuestID, g.Guest_Name

		select * from ViewGuestBookings

--    • View 3: ViewAvailableRooms 
--      ✓Create a view that lists available rooms for each hotel, grouped by room type 
--        and sorted by price in ascending order. 
        create view ViewAvailableRooms as
        select r.RoomID,r.RoomNumber,r.Type,r.PricePerNight,h.HotelID,h.Hotel_Name
        from Room r join 
             Hotel h on r.HotelID = h.HotelID
         where r.AvailabilityStatus = 1 

		 select *
         from ViewAvailableRooms
         order by HotelID, Type, PricePerNight asc



--    • View 4: ViewBookingSummary 
--      ✓Create a view that summarizes bookings by hotel, showing the total number 
--        of bookings, confirmed bookings, pending bookings, and canceled bookings. 

        create view ViewBookingSummary as
        select h.HotelID, h.Hotel_Name,
               count(b.BookingID) AS TotalBookings,
               sum(case when b.Status = 'Confirmed' then 1 else 0 end) as ConfirmedBookings,
               sum(case when b.Status = 'Pending' then 1 else 0 end) as PendingBookings,
               sum(case when b.Status = 'Canceled' then 1 else 0 end) as CanceledBookings
        from Booking b join 
             Hotel h on b.RoomID in (select RoomID 
			                         from Room 
									 where HotelID = h.HotelID)
        group by  h.HotelID, h.Hotel_Name
		
		
		select *
         from ViewBookingSummary

--    • View 5: ViewPaymentHistory 
--      ✓Create a view that lists all payment records along with the guest name, 
--        hotel name, booking status, and total payment made by each guest for each booking. 
        create view ViewPaymentHistory as
        select g.Guest_Name, h.Hotel_Name,
               b.Status as BookingStatus,
               p.Amount as TotalPayment,
               p.Date as PaymentDate
        from Payment p 
		     join
             Booking b on p.BookingID = b.BookingID
			 join
			 Guest g on b.GuestID = g.GuestID
			 join 
			 Room r on b.RoomID = r.RoomID
			 join 
			 Hotel h ON r.HotelID = h.HotelID

		select *
         from ViewPaymentHistory

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- 3. Functions 
--    • Function 1: GetHotelAverageRating 
--      ✓Create a function that takes HotelID as an input and returns 
--        the average rating of that hotel based on guest reviews. 

         create function GetHotelAverageRating (@HotelID int)
         returns decimal(3, 2)
         as
         begin
              declare @AverageRating DECIMAL(3, 2)

             select @AverageRating = avg(rev.Rating)
             from Review rev join 
	              Hotel_Review hr on rev.ReviewID = hr.ReviewID
             where hr.HotelID = @HotelID

             return @AverageRating
         end

		 --test
		 select dbo.GetHotelAverageRating(5) AS AverageRatingForHotel1
		 
		 select HotelID, Hotel_Name,
		        dbo.GetHotelAverageRating(HotelID) AS AverageRating
		 from Hotel 

--    • Function 2: GetNextAvailableRoom 
--      ✓Create a function that finds the next available room of 
--        a specific type within a given hotel. 



--    • Function 3: CalculateOccupancyRate 
--      ✓Create a function that takes HotelID as input and returns 
--        the occupancy rate of that hotel based on bookings made within the last 30 days. 