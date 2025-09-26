<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.gym.model.Participant" %>
<%@ page import="com.gym.repository.ParticipantRepository" %>
<%@ page import="com.gym.repository.BatchRepository" %>
<%@ page import="com.gym.model.Batch" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Initialize repositories
    ParticipantRepository participantRepo = new ParticipantRepository();
    BatchRepository batchRepo = new BatchRepository();
    
    // Get all participants
    List<Participant> participants = participantRepo.findAllParticipants();
    
    // Date formatter
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Participants - Gym Management System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
            color: #333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            margin: 0;
            font-size: 2.5em;
        }
        
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.1em;
        }
        
        .nav-section {
            padding: 20px 30px;
            background: #e9ecef;
            border-bottom: 1px solid #ddd;
        }
        
        .nav-links {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .nav-links a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .nav-links a:hover {
            text-decoration: underline;
        }
        
        .stats-section {
            padding: 20px 30px;
            background: #f8f9fa;
            border-bottom: 1px solid #ddd;
        }
        
        .stats {
            display: flex;
            gap: 30px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .stat-item {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #007bff;
            margin: 0;
        }
        
        .stat-label {
            margin: 5px 0 0 0;
            color: #6c757d;
            font-size: 0.9em;
        }
        
        .controls {
            padding: 20px 30px;
            background: white;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .search-box input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 250px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #0056b3;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #218838;
        }
        
        .table-container {
            padding: 0;
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        th {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: top;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .participant-name {
            font-weight: 600;
            color: #007bff;
        }
        
        .participant-email {
            color: #6c757d;
            font-size: 0.9em;
        }
        
        .batch-info {
            background: #e7f3ff;
            padding: 8px 12px;
            border-radius: 5px;
            font-size: 0.9em;
            color: #0056b3;
            text-align: center;
        }
        
        .registration-date {
            font-size: 0.9em;
            color: #6c757d;
        }
        
        .no-participants {
            text-align: center;
            padding: 60px 30px;
            color: #6c757d;
        }
        
        .no-participants i {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
        }
        
        .actions {
            display: flex;
            gap: 5px;
            justify-content: center;
        }
        
        .refresh-btn {
            background: none;
            border: 1px solid #ddd;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            color: #6c757d;
        }
        
        .refresh-btn:hover {
            background: #f8f9fa;
            border-color: #007bff;
            color: #007bff;
        }
        
        @media (max-width: 768px) {
            .header h1 { font-size: 2em; }
            .stats { flex-direction: column; gap: 15px; }
            .controls { flex-direction: column; align-items: stretch; }
            .search-box { flex-direction: column; }
            .search-box input { width: 100%; }
            .nav-links { flex-direction: column; gap: 10px; }
            
            table, th, td { font-size: 14px; }
            th, td { padding: 10px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>👥 All Participants</h1>
            <p>Manage and view all registered gym members</p>
        </div>
        
        <!-- Navigation -->
        <div class="nav-section">
            <div class="nav-links">
                <a href="../html/welcome.html">← Back to Home</a>
                <span>|</span>
                <a href="batches-list.jsp">View All Batches</a>
                <span>|</span>
                <a href="../html/add-participant.html">Add New Participant</a>
                <span>|</span>
                <a href="../html/update-participant.html">Update Participant</a>
            </div>
        </div>
        
        <!-- Statistics -->
        <div class="stats-section">
            <div class="stats">
                <div class="stat-item">
                    <div class="stat-number"><%= participants.size() %></div>
                    <div class="stat-label">Total Participants</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <%= participants.stream().mapToInt(p -> p.getBatchId()).distinct().toArray().length %>
                    </div>
                    <div class="stat-label">Active Batches</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <%= participants.stream().filter(p -> p.getRegistrationDate() != null && 
                            System.currentTimeMillis() - p.getRegistrationDate().getTime() < 7 * 24 * 60 * 60 * 1000).count() %>
                    </div>
                    <div class="stat-label">New This Week</div>
                </div>
            </div>
        </div>
        
        <!-- Controls -->
        <div class="controls">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search participants by name, email, or phone..." 
                       onkeyup="filterParticipants()">
                <button class="refresh-btn" onclick="location.reload()" title="Refresh Data">
                    🔄 Refresh
                </button>
            </div>
            <div>
                <a href="../html/add-participant.html" class="btn btn-primary">+ Add New Participant</a>
            </div>
        </div>
        
        <!-- Participants Table -->
        <div class="table-container">
            <% if (participants.isEmpty()) { %>
                <div class="no-participants">
                    <i>😔</i>
                    <h3>No Participants Found</h3>
                    <p>No participants are currently registered in the system.</p>
                    <a href="../html/add-participant.html" class="btn btn-success">Add First Participant</a>
                </div>
            <% } else { %>
                <table id="participantsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Participant Details</th>
                            <th>Contact Information</th>
                            <th>Address</th>
                            <th>Batch Assignment</th>
                            <th>Registration Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        for (Participant participant : participants) {
                            // Get batch information
                            Batch batch = batchRepo.findBatchById(participant.getBatchId());
                            String batchName = (batch != null) ? batch.getBatchName() : "No Batch Assigned";
                            String batchTime = "";
                            if (batch != null) {
                                batchTime = batch.getStartTime() + " - " + batch.getEndTime() + " (" + batch.getTimeSlot() + ")";
                            }
                        %>
                        <tr class="participant-row">
                            <td><strong>#<%= participant.getParticipantId() %></strong></td>
                            
                            <td>
                                <div class="participant-name">
                                    <%= participant.getFirstName() %> <%= participant.getLastName() %>
                                </div>
                                <div class="participant-email">
                                    <%= participant.getEmail() %>
                                </div>
                            </td>
                            
                            <td>
                                <div><strong>Phone:</strong> <%= participant.getPhone() %></div>
                                <div><strong>Email:</strong> <%= participant.getEmail() %></div>
                            </td>
                            
                            <td>
                                <%= (participant.getAddress() != null && !participant.getAddress().trim().isEmpty()) 
                                    ? participant.getAddress() : "<em>Not provided</em>" %>
                            </td>
                            
                            <td>
                                <div class="batch-info">
                                    <div><strong><%= batchName %></strong></div>
                                    <% if (batch != null) { %>
                                        <div style="margin-top: 5px; font-size: 0.8em;">
                                            <%= batchTime %>
                                        </div>
                                        <div style="margin-top: 5px; font-size: 0.8em;">
                                            Instructor: <%= batch.getInstructor() %>
                                        </div>
                                    <% } %>
                                </div>
                            </td>
                            
                            <td>
                                <div class="registration-date">
                                    <%= (participant.getRegistrationDate() != null) 
                                        ? dateFormat.format(participant.getRegistrationDate()) 
                                        : "Not available" %>
                                </div>
                            </td>
                            
                            <td>
                                <div class="actions">
                                    <button class="btn btn-danger" 
                                            onclick="deleteParticipant(<%= participant.getParticipantId() %>, '<%= participant.getFirstName() %> <%= participant.getLastName() %>')">
                                        🗑️ Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
    
    <script>
        // Search functionality
        function filterParticipants() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('.participant-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Update visible count
            const visibleRows = document.querySelectorAll('.participant-row[style=""]').length;
            const totalRows = rows.length;
            
            if (searchTerm && visibleRows === 0) {
                if (!document.getElementById('noResults')) {
                    const tbody = document.querySelector('tbody');
                    const noResultsRow = document.createElement('tr');
                    noResultsRow.id = 'noResults';
                    noResultsRow.innerHTML = `
                        <td colspan="7" style="text-align: center; padding: 40px; color: #6c757d;">
                            <div>🔍 No participants found matching "<strong>${searchTerm}</strong>"</div>
                            <div style="margin-top: 10px; font-size: 0.9em;">Try searching with different keywords</div>
                        </td>
                    `;
                    tbody.appendChild(noResultsRow);
                }
            } else {
                const noResultsRow = document.getElementById('noResults');
                if (noResultsRow) {
                    noResultsRow.remove();
                }
            }
        }
        
        // Delete participant function
        function deleteParticipant(participantId, participantName) {
            if (confirm(`Are you sure you want to delete "${participantName}"?\n\nThis action cannot be undone.`)) {
                // In real application, this would make an AJAX call to delete
                fetch(`../participants/${participantId}`, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        alert(`${participantName} has been successfully deleted.`);
                        location.reload(); // Refresh the page
                    } else {
                        alert('Error deleting participant. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting participant. Please try again.');
                });
            }
        }
        
        // Auto-refresh every 30 seconds (optional)
        // setInterval(() => location.reload(), 30000);
        
        // Add loading state
        window.addEventListener('beforeunload', function() {
            document.body.style.opacity = '0.7';
        });
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(event) {
            // Ctrl/Cmd + F for search
            if ((event.ctrlKey || event.metaKey) && event.key === 'f') {
                event.preventDefault();
                document.getElementById('searchInput').focus();
            }
            
            // Escape to clear search
            if (event.key === 'Escape') {
                document.getElementById('searchInput').value = '';
                filterParticipants();
            }
        });
        
        // Initialize search focus
        document.getElementById('searchInput').addEventListener('focus', function() {
            this.select();
        });
    </script>
</body>
</html>