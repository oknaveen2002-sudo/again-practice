package com.example.portal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import java.time.Instant;
import org.junit.jupiter.api.Test;

class HealthPayloadTest {
    @Test
    void createsExpectedHealthyResponse() {
        Instant fixed = Instant.parse("2026-01-01T00:00:00Z");
        assertEquals(
            "{\"status\":\"UP\",\"application\":\"enterprise-portal\",\"timestamp\":\"2026-01-01T00:00:00Z\"}",
            HealthPayload.create(fixed)
        );
    }
}
