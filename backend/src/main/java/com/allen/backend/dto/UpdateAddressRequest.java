package com.allen.backend.dto;

import jakarta.validation.constraints.NotBlank;

public class UpdateAddressRequest {
    @NotBlank
    private String address;

    public UpdateAddressRequest() { }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
