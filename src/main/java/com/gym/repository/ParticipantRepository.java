package com.gym.repository;

import com.gym.dao.ParticipantDAO;
import com.gym.dao.BatchDAO;
import com.gym.model.Participant;
import java.util.List;

public class ParticipantRepository {
    private ParticipantDAO participantDAO;
    private BatchDAO batchDAO;
    
    public ParticipantRepository() {
        this.participantDAO = new ParticipantDAO();
        this.batchDAO = new BatchDAO();
    }
    
    public boolean createParticipant(Participant participant) {
        boolean success = participantDAO.addParticipant(participant);
        if (success) {
            // Update batch participant count
            batchDAO.updateParticipantCount(participant.getBatchId());
        }
        return success;
    }
    
    public Participant findParticipantById(int participantId) {
        return participantDAO.getParticipantById(participantId);
    }
    
    public List<Participant> findAllParticipants() {
        return participantDAO.getAllParticipants();
    }
    
    public List<Participant> findParticipantsByBatch(int batchId) {
        return participantDAO.getParticipantsByBatch(batchId);
    }
    
    public boolean updateParticipant(Participant participant) {
        Participant existing = participantDAO.getParticipantById(participant.getParticipantId());
        boolean success = participantDAO.updateParticipant(participant);
        
        if (success && existing != null) {
            // Update count for both old and new batch if batch changed
            if (existing.getBatchId() != participant.getBatchId()) {
                batchDAO.updateParticipantCount(existing.getBatchId());
                batchDAO.updateParticipantCount(participant.getBatchId());
            }
        }
        return success;
    }
    
    public boolean deleteParticipant(int participantId) {
        Participant participant = participantDAO.getParticipantById(participantId);
        boolean success = participantDAO.deleteParticipant(participantId);
        
        if (success && participant != null) {
            // Update batch participant count
            batchDAO.updateParticipantCount(participant.getBatchId());
        }
        return success;
    }
}