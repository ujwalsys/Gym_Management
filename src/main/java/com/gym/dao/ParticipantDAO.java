package com.gym.dao;

import com.gym.model.Participant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParticipantDAO {
    
    public boolean addParticipant(Participant participant) {
        String sql = "INSERT INTO participants (first_name, last_name, email, phone, address, batch_id, registration_date) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, participant.getFirstName());
            stmt.setString(2, participant.getLastName());
            stmt.setString(3, participant.getEmail());
            stmt.setString(4, participant.getPhone());
            stmt.setString(5, participant.getAddress());
            stmt.setInt(6, participant.getBatchId());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding participant: " + e.getMessage());
            return false;
        }
    }
    
    public Participant getParticipantById(int participantId) {
        String sql = "SELECT * FROM participants WHERE participant_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, participantId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToParticipant(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error fetching participant: " + e.getMessage());
        }
        
        return null;
    }
    
    public List<Participant> getAllParticipants() {
        List<Participant> participants = new ArrayList<>();
        String sql = "SELECT * FROM participants ORDER BY registration_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                participants.add(mapResultSetToParticipant(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error fetching all participants: " + e.getMessage());
        }
        
        return participants;
    }
    
    public List<Participant> getParticipantsByBatch(int batchId) {
        List<Participant> participants = new ArrayList<>();
        String sql = "SELECT * FROM participants WHERE batch_id = ? ORDER BY first_name, last_name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, batchId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                participants.add(mapResultSetToParticipant(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error fetching participants by batch: " + e.getMessage());
        }
        
        return participants;
    }
    
    public boolean updateParticipant(Participant participant) {
        String sql = "UPDATE participants SET first_name = ?, last_name = ?, email = ?, phone = ?, address = ?, batch_id = ? WHERE participant_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, participant.getFirstName());
            stmt.setString(2, participant.getLastName());
            stmt.setString(3, participant.getEmail());
            stmt.setString(4, participant.getPhone());
            stmt.setString(5, participant.getAddress());
            stmt.setInt(6, participant.getBatchId());
            stmt.setInt(7, participant.getParticipantId());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating participant: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteParticipant(int participantId) {
        String sql = "DELETE FROM participants WHERE participant_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, participantId);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting participant: " + e.getMessage());
            return false;
        }
    }
    
    private Participant mapResultSetToParticipant(ResultSet rs) throws SQLException {
        Participant participant = new Participant();
        participant.setParticipantId(rs.getInt("participant_id"));
        participant.setFirstName(rs.getString("first_name"));
        participant.setLastName(rs.getString("last_name"));
        participant.setEmail(rs.getString("email"));
        participant.setPhone(rs.getString("phone"));
        participant.setAddress(rs.getString("address"));
        participant.setBatchId(rs.getInt("batch_id"));
        participant.setRegistrationDate(rs.getTimestamp("registration_date"));
        return participant;
    }
}