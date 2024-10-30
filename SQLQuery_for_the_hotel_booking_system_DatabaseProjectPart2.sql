--                                       Database Project Part 2 

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
               sum(CASE WHEN b.Status = 'Confirmed' THEN 1 ELSE 0 END) AS ConfirmedBookings,
               sum(CASE WHEN b.Status = 'Pending' THEN 1 ELSE 0 END) AS PendingBookings,
               sum(CASE WHEN b.Status = 'Canceled' THEN 1 ELSE 0 END) AS CanceledBookings
        from Booking b join 
             Hotel h on b.RoomID in (select RoomID 
			                         from Room 
									 where HotelID = h.HotelID)
        GROUP BY  h.HotelID, h.Hotel_Name
		
		
		select *
         from ViewBookingSummary

--    • View 5: ViewPaymentHistory 
--      ✓Create a view that lists all payment records along with the guest name, 
--        hotel name, booking status, and total payment made by each guest for each booking. 