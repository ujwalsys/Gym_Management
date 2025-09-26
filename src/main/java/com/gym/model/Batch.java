package com.gym.model;

import java.sql.Time;

public class Batch {
    private int batchId;
    private String batchName;
    private String instructor;
    private Time startTime;
    private Time endTime;
    private String timeSlot; // MORNING or EVENING
    private int maxCapacity;
    private int currentCount;
    
    // Constructors
    public Batch() {}
    
    public Batch(String batchName, String instructor, Time startTime, 
                 Time endTime, String timeSlot, int maxCapacity) {
        this.batchName = batchName;
        this.instructor = instructor;
        this.startTime = startTime;
        this.endTime = endTime;
        this.timeSlot = timeSlot;
        this.maxCapacity = maxCapacity;
        this.currentCount = 0;
    }
    
    // Getters and Setters
    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }
    
    public String getBatchName() { return batchName; }
    public void setBatchName(String batchName) { this.batchName = batchName; }
    
    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }
    
    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }
    
    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
    
    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
    
    public int getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }
    
    public int getCurrentCount() { return currentCount; }
    public void setCurrentCount(int currentCount) { this.currentCount = currentCount; }
    
    public boolean isFullCapacity() {
        return currentCount >= maxCapacity;
    }
    
    @Override
    public String toString() {
        return "Batch{" +
                "batchId=" + batchId +
                ", batchName='" + batchName + '\'' +
                ", instructor='" + instructor + '\'' +
                ", timeSlot='" + timeSlot + '\'' +
                ", currentCount=" + currentCount + "/" + maxCapacity +
                '}';
    }
}