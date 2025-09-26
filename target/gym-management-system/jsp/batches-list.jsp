<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.gym.model.Batch" %>
<%@ page import="com.gym.repository.BatchRepository" %>

<%
    BatchRepository batchRepo = new BatchRepository();
    List<Batch> batches = batchRepo.findAllBatches();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Batches - Gym Management System</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .header h1 { margin: 0; font-size: 2.2em; }
        .nav { padding: 20px 30px; background: #f8f9fa; border-bottom: 1px solid #ddd; }
        .nav a { color: #007bff; text-decoration: none; margin-right: 15px; }
        .nav a:hover { text-decoration: underline; }
        .controls { padding: 20px 30px; display: flex; justify-content: space-between; align-items: center; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #007bff; color: white; }
        .btn-primary:hover { background: #0056b3; }
        .btn-danger { background: #dc3545; color: white; padding: 5px 10px; font-size: 12px; }
        .btn-danger:hover { background: #c82333; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; padding: 15px; text-align: left; border-bottom: 2px solid #dee2e6; font-weight: 600; }
        td { padding: 15px; border-bottom: 1px solid #dee2e6; }
        tbody tr:hover { background: #f8f9fa; }
        .batch-name { font-weight: 600; color: #28a745; font-size: 1.1em; }
        .time-slot { background: #e7f3ff; padding: 5px 10px; border-radius: 15px; font-size: 0.9em; color: #0056b3; display: inline-block; }
        .morning { background: #fff3cd; color: #856404; }
        .evening { background: #d1ecf1; color: #0c5460; }
        .capacity { text-align: center; }
        .capacity-full { color: #dc3545; font-weight: bold; }
        .capacity-available { color: #28a745; }
        .no-batches { text-align: center; padding: 60px; color: #6c757d; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>📅 All Batches</h1>
            <p>View and manage all training batches</p>
        </div>
        
        <!-- Navigation -->
        <div class="nav">
            <a href="../html/welcome.html">← Back to Home</a>
            <a href="participants-list.jsp">View All Participants</a>
            <a href="../html/add-batch.html">Add New Batch</a>
        </div>
        
        <!-- Controls -->
        <div class="controls">
            <div>
                <strong>Total Batches: <%= batches.size() %></strong>
            </div>
            <a href="../html/add-batch.html" class="btn btn-primary">+ Add New Batch</a>
        </div>
        
        <!-- Batches Table -->
        <% if (batches.isEmpty()) { %>
            <div class="no-batches">
                <h3>No Batches Available</h3>
                <p>No training batches are currently configured.</p>
                <a href="../html/add-batch.html" class="btn btn-primary">Create First Batch</a>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Batch Details</th>
                        <th>Instructor</th>
                        <th>Schedule</th>
                        <th>Capacity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Batch batch : batches) { 
                        String timeSlotClass = batch.getTimeSlot().equalsIgnoreCase("MORNING") ? "morning" : "evening";
                        boolean isFull = batch.getCurrentCount() >= batch.getMaxCapacity();
                    %>
                    <tr>
                        <td>
                            <div class="batch-name"><%= batch.getBatchName() %></div>
                            <div style="font-size: 0.9em; color: #6c757d;">ID: #<%= batch.getBatchId() %></div>
                        </td>
                        
                        <td>
                            <strong><%= batch.getInstructor() %></strong>
                        </td>
                        
                        <td>
                            <div><strong><%= batch.getStartTime() %> - <%= batch.getEndTime() %></strong></div>
                            <span class="time-slot <%= timeSlotClass %>">
                                <%= batch.getTimeSlot().substring(0,1) + batch.getTimeSlot().substring(1).toLowerCase() %>
                            </span>
                        </td>
                        
                        <td class="capacity">
                            <div class="<%= isFull ? "capacity-full" : "capacity-available" %>">
                                <strong><%= batch.getCurrentCount() %>/<%= batch.getMaxCapacity() %></strong>
                            </div>
                            <div style="font-size: 0.8em; margin-top: 5px;">
                                <% if (isFull) { %>
                                    <span style="color: #dc3545;">🔴 Full</span>
                                <% } else { %>
                                    <span style="color: #28a745;">
                                        🟢 <%= (batch.getMaxCapacity() - batch.getCurrentCount()) %> spots
                                    </span>
                                <% } %>
                            </div>
                        </td>
                        
                        <td>
                            <a href="batch-participants.jsp?batchId=<%= batch.getBatchId() %>" 
                               style="color: #007bff; text-decoration: none; font-size: 0.9em; margin-right: 10px;">
                               👥 View Members
                            </a>
                            <button class="btn btn-danger" 
                                    onclick="deleteBatch(<%= batch.getBatchId() %>, '<%= batch.getBatchName() %>')">
                                🗑️ Delete
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
    
    <script>
        function deleteBatch(batchId, batchName) {
            if (confirm(`Delete "${batchName}"?\n\nThis will remove the batch and unassign all participants.`)) {
                fetch(`../batches/${batchId}`, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        alert(`${batchName} deleted successfully.`);
                        location.reload();
                    } else {
                        alert('Error deleting batch. Please try again.');
                    }
                })
                .catch(error => {
                    alert('Error deleting batch. Please try again.');
                });
            }
        }
    </script>
</body>
</html>