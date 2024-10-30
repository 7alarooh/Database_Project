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

--      ✓ Add a non-clustered index on the Status column to 
--         improve filtering of bookings by status. 

--      ✓ Add a composite index on RoomID, CheckInDate, and 
--         CheckOutDate for efficient querying of booking schedules.