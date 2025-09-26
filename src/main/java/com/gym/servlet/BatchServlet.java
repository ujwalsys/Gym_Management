package com.gym.servlet;

import com.gym.model.Batch;
import com.gym.repository.BatchRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Time;
import java.util.List;


public class BatchServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BatchRepository batchRepository;
    private ObjectMapper objectMapper;
    
    @Override
    public void init() throws ServletException {
        batchRepository = new BatchRepository();
        objectMapper = new ObjectMapper();
    }
    
    // GET - Retrieve batches
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all batches
                List<Batch> batches = batchRepository.findAllBatches();
                String json = objectMapper.writeValueAsString(batches);
                out.print(json);
            } else {
                // Get batch by ID
                int batchId = Integer.parseInt(pathInfo.substring(1));
                Batch batch = batchRepository.findBatchById(batchId);
                
                if (batch != null) {
                    String json = objectMapper.writeValueAsString(batch);
                    out.print(json);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\":\"Batch not found\"}");
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
    
    // POST - Create new batch
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String batchName = request.getParameter("batchName");
            String instructor = request.getParameter("instructor");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String timeSlot = request.getParameter("timeSlot");
            int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));
            
            Time startTime = Time.valueOf(startTimeStr + ":00");
            Time endTime = Time.valueOf(endTimeStr + ":00");
            
            Batch batch = new Batch(batchName, instructor, startTime, endTime, timeSlot, maxCapacity);
            
            boolean success = batchRepository.createBatch(batch);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print("{\"status\":\"success\",\"message\":\"Batch created successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"Failed to create batch\"}");
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    // PUT - Update batch
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && !pathInfo.equals("/")) {
                int batchId = Integer.parseInt(pathInfo.substring(1));
                
                // Read JSON from request body
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) {
                    sb.append(line);
                }
                
                Batch batch = objectMapper.readValue(sb.toString(), Batch.class);
                batch.setBatchId(batchId);
                
                boolean success = batchRepository.updateBatch(batch);
                
                if (success) {
                    out.print("{\"status\":\"success\",\"message\":\"Batch updated successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"error\",\"message\":\"Failed to update batch\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"Batch ID required\"}");
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
    
    // DELETE - Delete batch
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && !pathInfo.equals("/")) {
                int batchId = Integer.parseInt(pathInfo.substring(1));
                
                boolean success = batchRepository.deleteBatch(batchId);
                
                if (success) {
                    out.print("{\"status\":\"success\",\"message\":\"Batch deleted successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"error\",\"message\":\"Failed to delete batch\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"Batch ID required\"}");
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}