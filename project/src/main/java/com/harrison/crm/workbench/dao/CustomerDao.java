package com.harrison.crm.workbench.dao;

import com.harrison.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    int saveCustomer(Customer customer);

    Customer getCustomerByName(String company);

    List<String> getCustomersByName(String name);
}
