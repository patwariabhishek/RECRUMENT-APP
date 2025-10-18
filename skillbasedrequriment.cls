// Apex Class: CandidateSkillMatcher.cls
public with sharing class CandidateSkillMatcher {
    
    public static List<Candidate__c> getMatchingCandidates(Id positionId) {
        // Fetch Position details
        Position__c pos = [SELECT Id, Skills_Required__c FROM Position__c WHERE Id = :positionId LIMIT 1];
        
        // Split required skills
        Set<String> requiredSkills = new Set<String>();
        if (pos.Skills_Required__c != null) {
            for (String s : pos.Skills_Required__c.split(',', 0)) {
                requiredSkills.add(s.trim().toLowerCase());
            }
        }
        
        // Query all candidates
        List<Candidate__c> allCandidates = [SELECT Id, Name, Skill_Set__c, Candidate_Score__c FROM Candidate__c];
        List<Candidate__c> matchingCandidates = new List<Candidate__c>();
        
        // Check skill match
        for (Candidate__c cand : allCandidates) {skill
            if (cand.Skill_Set__c != null) {
                for (String skill : cand.Skill_Set__c.split(',', 0)) {
                    if (requiredSkills.contains(skill.trim().toLowerCase())) {
                        matchingCandidates.add(cand);
                        break;
                    }
                }
            }
        }
        
        return matchingCandidates;
    }
}
