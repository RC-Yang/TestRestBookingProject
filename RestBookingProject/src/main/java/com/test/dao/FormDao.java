package com.test.dao;

import java.util.HashMap;

import com.test.bean.District;

public interface FormDao {
	public HashMap<String,District> queryDistrictWithCountry(int countryId);
}
