package com.gym.repository;

import com.gym.dao.BatchDAO;
import com.gym.model.Batch;
import java.util.List;

public class BatchRepository {
    private BatchDAO batchDAO;
    
    public BatchRepository() {
        this.batchDAO = new BatchDAO();
    }
    
    public boolean createBatch(Batch batch) {
        return batchDAO.addBatch(batch);
    }
    
    public Batch findBatchById(int batchId) {
        return batchDAO.getBatchById(batchId);
    }
    
    public List<Batch> findAllBatches() {
        return batchDAO.getAllBatches();
    }
    
    public boolean updateBatch(Batch batch) {
        return batchDAO.updateBatch(batch);
    }
    
    public boolean deleteBatch(int batchId) {
        return batchDAO.deleteBatch(batchId);
    }
    
    public boolean refreshParticipantCount(int batchId) {
        return batchDAO.updateParticipantCount(batchId);
    }
}