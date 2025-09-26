<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.gym.model.Participant" %>
<%@ page import="com.gym.repository.ParticipantRepository" %>
<%@ page import="java.util.List" %>

<%
    ParticipantRepository repo = new ParticipantRepository();
    List<Participant> participants = repo.findAllParticipants();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Update Participant - Gym Management System</title>
<style>
    body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
    .container { max-width: 700px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .header { text-align: center; margin-bottom: 30px; color: #333; }
    .form-group { margin-bottom: 20px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
    input[type="text"], input[type="email"], input[type="tel"], select, textarea, input[type="search"] { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; box-sizing: border-box; }
    select { height: 45px; }
    textarea { height: 80px; resize: vertical; }
    .btn { background-color: #17a2b8; color: white; padding: 12px 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin-right: 10px; }
    .btn:hover { background-color: #138496; }
    .btn-secondary { background-color: #6c757d; }
    .btn-secondary:hover { background-color: #5a6268; }
    .form-actions { text-align: center; margin-top: 30px; }
    .back-link { display: inline-block; margin-bottom: 20px; color: #007bff; text-decoration: none; }
    .back-link:hover { text-decoration: underline; }
    .required { color: red; }
    .name-group { display: flex; gap: 10px; }
    .name-group .form-group { flex: 1; }
    .current-info { background: #e7f3ff; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #17a2b8; }
    #updateForm { display: none; }
    .search-results { background: white; border: 1px solid #ddd; border-radius: 5px; max-height: 200px; overflow-y: auto; display: none; position: absolute; z-index: 100; width: 100%; }
    .search-item { padding: 10px; cursor: pointer; border-bottom: 1px solid #eee; }
    .search-item:hover { background: #f8f9fa; }
    .search-container { position: relative; }
</style>
</head>
<body>
<div class="container">
    <a href="welcome.html" class="back-link">← Back to Home</a>
    <div class="header">
        <h1>✏️ Update Participant</h1>
        <p>Modify existing participant information</p>
    </div>

    <!-- Search Section -->
    <div class="form-group">
        <label for="searchParticipant">Search by Name or Email</label>
        <div class="search-container">
            <input type="search" id="searchParticipant" placeholder="Type participant name or email..." oninput="searchParticipants(this.value)">
            <div id="searchResults" class="search-results"></div>
        </div>
    </div>

    <!-- Dynamic Participant Dropdown -->
    <div class="form-group">
        <label for="participantSelect">Or select from list</label>
        <select id="participantSelect" onchange="selectParticipant(this.value)">
            <option value="">Select a participant...</option>
            <% for (Participant p : participants) { %>
                <option value="<%= p.getParticipantId() %>">
                    <%= p.getFirstName() %> <%= p.getLastName() %> (<%= p.getEmail() %>)
                </option>
            <% } %>
        </select>
    </div>

    <!-- Update Form -->
    <form id="updateForm" onsubmit="updateParticipant(event)">
        <div class="current-info">
            <h4>Current Participant Information</h4>
            <div id="currentParticipantInfo">Participant details will appear here...</div>
        </div>

        <input type="hidden" id="participantId" name="participantId">
        
        <div class="name-group">
            <div class="form-group">
                <label for="firstName">First Name <span class="required">*</span></label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name <span class="required">*</span></label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email">Email <span class="required">*</span></label>
            <input type="email" id="email" name="email" required>
        </div>

        <div class="form-group">
            <label for="phone">Phone <span class="required">*</span></label>
            <input type="tel" id="phone" name="phone" required pattern="[0-9]{10}">
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address"></textarea>
        </div>

        <div class="form-group">
            <label for="batchId">Select Batch <span class="required">*</span></label>
            <select id="batchId" name="batchId" required>
                <option value="">Select a batch...</option>
                <%-- You can also populate batches dynamically from DB similarly --%>
                <option value="1">Morning Bench Press (06:00 - 07:00)</option>
                <option value="2">Morning Deadlift Training (07:30 - 08:30)</option>
                <option value="3">Evening Squats & Legs (18:00 - 19:00)</option>
                <option value="4">Evening Full Body Workout (19:30 - 20:30)</option>
            </select>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn">Update Participant</button>
            <button type="button" class="btn btn-secondary" onclick="cancelUpdate()">Cancel</button>
        </div>
    </form>
</div>

<script>
// Build participant data object dynamically from JSP
const participantData = {
<% for (Participant p : participants) { %>
    <%= p.getParticipantId() %>: {
        id: <%= p.getParticipantId() %>,
        firstName: "<%= p.getFirstName() %>",
        lastName: "<%= p.getLastName() %>",
        email: "<%= p.getEmail() %>",
        phone: "<%= p.getPhone() %>",
        address: "<%= p.getAddress() != null ? p.getAddress() : "" %>",
        batchId: <%= p.getBatchId() %>,
        batchName: "<%= p.getBatchName() != null ? p.getBatchName() : "" %>"
    },
<% } %>
};

function searchParticipants(query) {
    const resultsDiv = document.getElementById('searchResults');
    if (query.length < 2) { resultsDiv.style.display = 'none'; return; }
    const matches = Object.values(participantData).filter(p => 
        p.firstName.toLowerCase().includes(query.toLowerCase()) || 
        p.lastName.toLowerCase().includes(query.toLowerCase()) || 
        p.email.toLowerCase().includes(query.toLowerCase())
    );
    if(matches.length) {
        resultsDiv.innerHTML = matches.map(p => `<div class="search-item" onclick="selectParticipant(${p.id})">${p.firstName} ${p.lastName} - ${p.email}</div>`).join('');
        resultsDiv.style.display = 'block';
    } else {
        resultsDiv.innerHTML = '<div class="search-item">No participants found</div>';
        resultsDiv.style.display = 'block';
    }
}

function selectParticipant(id) {
    if(!id) return;
    const p = participantData[id];
    if(!p) return;
    
    document.getElementById('updateForm').style.display = 'block';
    document.getElementById('participantId').value = p.id;
    document.getElementById('firstName').value = p.firstName;
    document.getElementById('lastName').value = p.lastName;
    document.getElementById('email').value = p.email;
    document.getElementById('phone').value = p.phone;
    document.getElementById('address').value = p.address;
    document.getElementById('batchId').value = p.batchId;
    
    document.getElementById('currentParticipantInfo').innerHTML = `
        <strong>Name:</strong> ${p.firstName} ${p.lastName}<br>
        <strong>Email:</strong> ${p.email}<br>
        <strong>Phone:</strong> ${p.phone}<br>
        <strong>Address:</strong> ${p.address}<br>
        <strong>Current Batch:</strong> ${p.batchName}
    `;
    document.getElementById('searchResults').style.display = 'none';
}

function updateParticipant(e) {
    e.preventDefault();
    const id = document.getElementById('participantId').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if(!emailRegex.test(email)){ alert('Enter a valid email'); return; }
    if(phone.length !== 10){ alert('Phone must be 10 digits'); return; }
    alert(`Participant ${id} updated! (In real app, send PUT request)`); 
    cancelUpdate();
}

function cancelUpdate() {
    document.getElementById('updateForm').style.display = 'none';
    document.getElementById('participantId').value = '';
    document.getElementById('searchParticipant').value = '';
    document.getElementById('participantSelect').value = '';
}
</script>
</body>
</html>
