package com.test.dao;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.test.bean.BookingRecord;
import com.test.bean.Restaurant;

@Repository
public class RestRepositoryByJPA{
	@Autowired
	private EntityManager entityManager;

    public List<Restaurant> findRestsByDistrictJoinImage(String district){
		Query query = entityManager.createQuery
				("SELECT r.name,r.address,r.phoneNum FROM Restaurant r JOIN r.imageList i WHERE r.address like :district");       
		
        query.setParameter("district", "%" + district + "%");

        return query.getResultList();
	}
    
    public Restaurant queryRestActiveTime(Integer restId){
    	Query query = entityManager.createQuery
				("select r from Restaurant r where r.id=:restId");
    	query.setParameter("restId", restId);

        List<Restaurant> objList = query.getResultList();
        Restaurant obj = objList.get(0);
        return obj;
    }

    public Object[] queryRestAvalibleSeat(Integer restId,Date bookingDate,Time bookingTime){
    	Query query = entityManager.createNativeQuery
				("SELECT COALESCE(sum(b.guest_num),0) FROM booking b"
						+ " WHERE b.booking_rest_id = :restId"
						+ " AND b.booking_date = :bookingDate AND b.booking_time=:bookingTime"
						+ "");
    	query.setParameter("restId", restId);
    	query.setParameter("bookingDate", bookingDate);
    	query.setParameter("bookingTime", bookingTime);

        List<Object[]> objList = query.getResultList();
        Object guestNum = objList.get(0);
        
        query =  entityManager.createNativeQuery
				("SELECT r.seat FROM  web.restdetail r WHERE r.rest_id = :restId");
        query.setParameter("restId", restId);
        objList = query.getResultList();
        Object seatNum = objList.get(0);
        
        Object[] result = new Object[2];
        result[0]=guestNum;
        result[1]=seatNum;
        return result;
    }
    @Transactional
    public void addBookingData(Integer restId, Date bookingDate
			, Time bookingTime,Integer seat,Integer guestId) {
    	//bookingId已透過SQL，設置為AUTO_INCREMENT，不須在此額外做設定
    	BookingRecord bookingRecord = new BookingRecord();
    	bookingRecord.setBookingDate(bookingDate);
    	bookingRecord.setBookingTime(bookingTime);
    	
    	Restaurant rest = queryRestByRestId(restId);
    	bookingRecord.setBookingRest(rest);
    	bookingRecord.setGuestNum(seat);
    	
    	bookingRecord.setGuestId(guestId);
    	
    	entityManager.persist(bookingRecord);
    	return;
    }
    
    public Restaurant queryRestByRestId(Integer restId) {
    	Query query = entityManager.createQuery
				("SELECT r FROM Restaurant r where r.id=:restId");
    	query.setParameter("restId", restId);
    	List<Object> objList = query.getResultList();
    	Restaurant rest = (Restaurant)objList.get(0);
        return rest;
    }
}
