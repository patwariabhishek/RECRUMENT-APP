@isTest
private class CandidateTriggerTest {
    @isTest
    static void testCandidateScore() {
        Candidate__c cand = new Candidate__c(Name='John Doe', Experience__c=4, Skill_Set__c='Java, Apex, LWC');
        insert cand;

        Candidate__c result = [SELECT Candidate_Score__c FROM Candidate__c WHERE Id=:cand.Id];
        System.assert(result.Candidate_Score__c > 0);
    }
}