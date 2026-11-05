package com.example.portal;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.Instant;

@WebServlet("/")
public class HomeServlet extends HttpServlet {
  @Override protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
    res.setContentType("text/html;charset=UTF-8");
    res.setHeader("X-Content-Type-Options", "nosniff");
    res.getWriter().write("<!doctype html><html><head><meta charset='utf-8'><title>Enterprise Portal</title>" +
      "<style>body{font:16px Arial;background:#f2f5fa;color:#18243a;margin:8vh auto;max-width:760px}" +
      "main{background:white;padding:36px;border-radius:12px;box-shadow:0 5px 25px #0001}" +
      "h1{color:#174ea6}.ok{color:green;font-weight:bold}</style></head><body><main>" +
      "<h1>Enterprise Portal</h1><p class='ok'>Application is running.</p>" +
      "<p>Java web application deployed to Apache Tomcat using an automated CI/CD pipeline.</p>" +
      "<p>Server time (UTC): " + Instant.now() + "</p><p><a href='health'>Health endpoint</a></p>" +
      "</main></body></html>");
  }
}
