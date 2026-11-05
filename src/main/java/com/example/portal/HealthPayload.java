package com.example.portal;

import java.time.Instant;

public final class HealthPayload {
    private HealthPayload() {}

    public static String create(Instant timestamp) {
        return String.format(
            "{\"status\":\"UP\",\"application\":\"enterprise-portal\",\"timestamp\":\"%s\"}",
            timestamp
        );
    }
}
