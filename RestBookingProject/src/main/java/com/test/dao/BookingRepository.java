package com.test.dao;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.test.bean.BookingRecord;

public interface BookingRepository extends JpaRepository<BookingRecord, Integer>{
	
	@Query("SELECT b FROM BookingRecord b WHERE b.bookingRest.id = :restId AND b.bookingDate = :bookingDate")
	public List<BookingRecord> findBookingRecordsByBookingRest_id(@Param("restId") Integer restId
			,@Param("bookingDate") Date bookingDate);
	@Query(value="SELECT sum(b.guest_num) FROM booking b WHERE b.booking_rest_id = :restId "
			+ "AND b.booking_date = :bookingDate AND b.booking_time=:bookingTime", nativeQuery = true)
	public int findAvalibleSeatByRestId(@Param("restId") Integer restId,@Param("bookingDate") Date bookingDate
			,@Param("bookingTime") Time bookingTime);
}
