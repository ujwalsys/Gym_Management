package com.gym.dao;

import com.gym.model.Batch;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatchDAO {
    
    public boolean addBatch(Batch batch) {
        String sql = "INSERT INTO batches (batch_name, instructor, start_time, end_time, time_slot, max_capacity, current_count) VALUES (?, ?, ?, ?, ?, ?, 0)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, batch.getBatchName());
            stmt.setString(2, batch.getInstructor());
            stmt.setTime(3, batch.getStartTime());
            stmt.setTime(4, batch.getEndTime());
            stmt.setString(5, batch.getTimeSlot());
            stmt.setInt(6, batch.getMaxCapacity());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding batch: " + e.getMessage());
            return false;
        }
    }
    
    public Batch getBatchById(int batchId) {
        String sql = "SELECT * FROM batches WHERE batch_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, batchId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBatch(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error fetching batch: " + e.getMessage());
        }
        
        return null;
    }
    
    public List<Batch> getAllBatches() {
        List<Batch> batches = new ArrayList<>();
        String sql = "SELECT * FROM batches ORDER BY time_slot, start_time";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                batches.add(mapResultSetToBatch(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error fetching all batches: " + e.getMessage());
        }
        
        return batches;
    }
    
    public boolean updateBatch(Batch batch) {
        String sql = "UPDATE batches SET batch_name = ?, instructor = ?, start_time = ?, end_time = ?, time_slot = ?, max_capacity = ? WHERE batch_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, batch.getBatchName());
            stmt.setString(2, batch.getInstructor());
            stmt.setTime(3, batch.getStartTime());
            stmt.setTime(4, batch.getEndTime());
            stmt.setString(5, batch.getTimeSlot());
            stmt.setInt(6, batch.getMaxCapacity());
            stmt.setInt(7, batch.getBatchId());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating batch: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteBatch(int batchId) {
        String sql = "DELETE FROM batches WHERE batch_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, batchId);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting batch: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateParticipantCount(int batchId) {
        String sql = "UPDATE batches SET current_count = (SELECT COUNT(*) FROM participants WHERE batch_id = ?) WHERE batch_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, batchId);
            stmt.setInt(2, batchId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating participant count: " + e.getMessage());
            return false;
        }
    }
    
    private Batch mapResultSetToBatch(ResultSet rs) throws SQLException {
        Batch batch = new Batch();
        batch.setBatchId(rs.getInt("batch_id"));
        batch.setBatchName(rs.getString("batch_name"));
        batch.setInstructor(rs.getString("instructor"));
        batch.setStartTime(rs.getTime("start_time"));
        batch.setEndTime(rs.getTime("end_time"));
        batch.setTimeSlot(rs.getString("time_slot"));
        batch.setMaxCapacity(rs.getInt("max_capacity"));
        batch.setCurrentCount(rs.getInt("current_count"));
        return batch;
    }
}