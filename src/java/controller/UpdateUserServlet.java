package controller;

import connect.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/update-user")
public class UpdateUserServlet
extends HttpServlet {

    protected void doPost(
    HttpServletRequest request,
    HttpServletResponse response)

    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

        try{

            int id =
            Integer.parseInt(
            request.getParameter("id"));

            String hoten =
            request.getParameter("hoten");

            String email =
            request.getParameter("email");
            

            String sodienthoai =
            request.getParameter("sodienthoai");
            
            String password =
            request.getParameter("password");
            
            String role =
            request.getParameter("role");
            

            Connection conn =
            DBConnection.getConnection();

            String sql =
            "UPDATE users SET hoten=?,email=?,sodienthoai=?,password=?,role=? WHERE id=?";

            PreparedStatement ps =
            conn.prepareStatement(sql);

        ps.setString(1, hoten);
        ps.setString(2, email);
        ps.setString(3, sodienthoai);
        ps.setString(4, password);
        ps.setString(5, role);
        ps.setInt(6, id);

            ps.executeUpdate();

            response.sendRedirect(
            "users.jsp");

        }catch(Exception e){

            e.printStackTrace();
        }
    }
}