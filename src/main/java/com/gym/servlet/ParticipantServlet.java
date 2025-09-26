package com.gym.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import com.gym.model.Participant;
import com.gym.repository.ParticipantRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class ParticipantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ParticipantRepository participantRepository;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        participantRepository = new ParticipantRepository();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                List<Participant> participants = participantRepository.findAllParticipants();
                out.print(objectMapper.writeValueAsString(participants));
            } else {
                int id = Integer.parseInt(pathInfo.substring(1));
                Participant p = participantRepository.findParticipantById(id);
                if (p != null) out.print(objectMapper.writeValueAsString(p));
                else response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int batchId = Integer.parseInt(request.getParameter("batchId"));

            Participant p = new Participant(firstName, lastName, email, phone, address, batchId, address);
            boolean success = participantRepository.createParticipant(p);

            if (success) out.print("{\"status\":\"success\",\"message\":\"Participant created successfully\"}");
            else response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && !pathInfo.equals("/")) {
                int id = Integer.parseInt(pathInfo.substring(1));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) sb.append(line);
                Participant p = objectMapper.readValue(sb.toString(), Participant.class);
                p.setParticipantId(id);

                boolean success = participantRepository.updateParticipant(p);
                if (success) out.print("{\"status\":\"success\",\"message\":\"Participant updated successfully\"}");
                else response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && !pathInfo.equals("/")) {
                int id = Integer.parseInt(pathInfo.substring(1));
                boolean success = participantRepository.deleteParticipant(id);
                if (success) out.print("{\"status\":\"success\",\"message\":\"Participant deleted successfully\"}");
                else response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
