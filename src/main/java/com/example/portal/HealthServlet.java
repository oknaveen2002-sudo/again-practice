package com.example.portal;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.Instant;

@WebServlet("/health")
public class HealthServlet extends HttpServlet {
  @Override protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
    res.setStatus(HttpServletResponse.SC_OK);
    res.setContentType("application/json;charset=UTF-8");
    res.getWriter().println(HealthPayload.create(Instant.now()));
  }
}
