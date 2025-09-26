<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.gym.model.Participant" %>
<%@ page import="com.gym.model.Batch" %>
<%@ page import="com.gym.repository.ParticipantRepository" %>
<%@ page import="com.gym.repository.BatchRepository" %>

<%
    // Get batch ID from query parameter
    String batchIdParam = request.getParameter("batchId");
    int batchId = 0;
    
    if (batchIdParam != null && !batchIdParam.trim().isEmpty()) {
        try {
            batchId = Integer.parseInt(batchIdParam);
        } catch (NumberFormatException e) {
            batchId = 0;
        }
    }
    
    // Initialize repositories
    ParticipantRepository participantRepo = new ParticipantRepository();
    BatchRepository batchRepo = new BatchRepository();
    
    // Get batch and participants
    Batch batch = null;
    List<Participant> participants = null;
    
    if (batchId > 0) {
        batch = batchRepo.findBatchById(batchId);
        participants = participantRepo.findParticipantsByBatch(batchId);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Batch Participants - Gym Management System</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 900px; margin: 0 auto; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #6f42c1, #e83e8c); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .header h1 { margin: 0; font-size: 2em; }
        .nav { padding: 20px 30px; background: #f8f9fa; border-bottom: 1px solid #ddd; }
        .nav a { color: #007bff; text-decoration: none; margin-right: 15px; }
        .nav a:hover { text-decoration: underline; }
        .batch-info { background: #e7f3ff; padding: 20px 30px; border-left: 4px solid #007bff; margin: 0; }
        .batch-name { font-size: 1.5em; font-weight: bold; color: #007bff; margin-bottom: 10px; }
        .batch-details { display: flex; gap: 30px; flex-wrap: wrap; }
        .detail-item { font-size: 0.9em; }
        .detail-label { font-weight: bold; color: #495057; }
        .controls { padding: 20px 30px; display: flex; justify-content: space-between; align-items: center; }
        .capacity-status { font-weight: bold; }
        .full { color: #dc3545; }
        .available { color: #28a745; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; padding: 12px 15px; text-align: left; border-bottom: 2px solid #dee2e6; font-weight: 600; }
        td { padding: 12px 15px; border-bottom: 1px solid #dee2e6; }
        tbody tr:hover { background: #f8f9fa; }
        .participant-name { font-weight: 600; color: #6f42c1; }
        .no-participants { text-align: center; padding: 60px; color: #6c757d; }
        .error-message { background: #f8d7da; color: #721c24; padding: 20px; margin: 30px; border-radius: 5px; text-align: center; }
        .btn { padding: 8px 16px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 0.9em; }
        .btn-primary { background: #007bff; color: white; }
        .btn-primary:hover { background: #0056b3; }
        @media (max-width: 768px) {
            .batch-details { flex-direction: column; gap: 10px; }
            .controls { flex-direction: column; gap: 15px; align-items: stretch; }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>👥 Batch Participants</h1>
        </div>
        
        <!-- Navigation -->
        <div class="nav">
            <a href="../html/welcome.html">← Back to Home</a>
            <a href="batches-list.jsp">All Batches</a>
            <a href="participants-list.jsp">All Participants</a>
        </div>
        
        <% if (batchId == 0 || batch == null) { %>
            <!-- Error State -->
            <div class="error-message">
                <h3>❌ Invalid Batch</h3>
                <p>The requested batch could not be found or batch ID is missing.</p>
                <a href="batches-list.jsp" class="btn btn-primary">View All Batches</a>
            </div>
        <% } else { %>
            <!-- Batch Information -->
            <div class="batch-info">
                <div class="batch-name"><%= batch.getBatchName() %></div>
                <div class="batch-details">
                    <div class="detail-item">
                        <span class="detail-label">Instructor:</span> <%= batch.getInstructor() %>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Time:</span> <%= batch.getStartTime() %> - <%= batch.getEndTime() %>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Slot:</span> <%= batch.getTimeSlot().substring(0,1) + batch.getTimeSlot().substring(1).toLowerCase() %>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Batch ID:</span> #<%= batch.getBatchId() %>
                    </div>
                </div>
            </div>
            
            <!-- Controls -->
            <div class="controls">
                <div>
                    <span class="capacity-status <%= batch.getCurrentCount() >= batch.getMaxCapacity() ? "full" : "available" %>">
                        <strong><%= participants.size() %>/<%= batch.getMaxCapacity() %></strong> participants
                        <% if (batch.getCurrentCount() >= batch.getMaxCapacity()) { %>
                            (🔴 Full)
                        <% } else { %>
                            (🟢 <%= (batch.getMaxCapacity() - batch.getCurrentCount()) %> spots available)
                        <% } %>
                    </span>
                </div>
                <a href="../html/add-participant.html" class="btn btn-primary">+ Add Participant</a>
            </div>
            
            <!-- Participants Table -->
            <% if (participants.isEmpty()) { %>
                <div class="no-participants">
                    <h3>😔 No Participants Yet</h3>
                    <p>This batch doesn't have any registered participants.</p>
                    <a href="../html/add-participant.html" class="btn btn-primary">Add First Participant</a>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Participant Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Registration Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Participant participant : participants) { %>
                        <tr>
                            <td><strong>#<%= participant.getParticipantId() %></strong></td>
                            
                            <td>
                                <div class="participant-name">
                                    <%= participant.getFirstName() %> <%= participant.getLastName() %>
                                </div>
                            </td>
                            
                            <td><%= participant.getEmail() %></td>
                            
                            <td><%= participant.getPhone() %></td>
                            
                            <td>
                                <% if (participant.getRegistrationDate() != null) { %>
                                    <% 
                                        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("MMM dd, yyyy");
                                        String formattedDate = formatter.format(participant.getRegistrationDate());
                                    %>
                                    <%= formattedDate %>
                                <% } else { %>
                                    <em>Not available</em>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        <% } %>
    </div>
    
    <script>
        // Auto-refresh every 60 seconds (optional)
        // setInterval(() => location.reload(), 60000);
        
        // Add some interactivity
        document.addEventListener('DOMContentLoaded', function() {
            // Highlight current batch capacity status
            const capacityElement = document.querySelector('.capacity-status');
            if (capacityElement && capacityElement.classList.contains('full')) {
                capacityElement.style.animation = 'pulse 2s infinite';
            }
        });
        
        // Simple CSS animation for full capacity warning
        const style = document.createElement('style');
        style.textContent = `
            @keyframes pulse {
                0% { opacity: 1; }
                50% { opacity: 0.7; }
                100% { opacity: 1; }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>