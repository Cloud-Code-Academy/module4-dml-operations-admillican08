/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */

public with sharing class DMLOperations {
  /**
   * Question 1
   * Create a new Account object and inserts it into the database.
   * The Account will have a random name for uniqueness.
   * @return The Id of the newly created Account.
   */
  public static Id insertNewAccount() {
    // Create a new Account instance
    Account newAcct = new Account(name = 'newAcct');
    // Set some fields on the Account
    newAcct.BillingStreet = '123 Larimer St';
    newAcct.BillingCity = 'Denver';
    newAcct.BillingState = 'CO';
    newAcct.BillingPostalCode = '80202';
    newAcct.BillingCountry = 'US';
    newAcct.Industry = 'IT';
    // Insert the Account into the database
    insert as user newAcct;
    // Return the Id of the newly created Account
    return newAcct.Id;
  }

  /**
   * Question 2
   * Create a new Account with the specified name and industry provided.
   * @param name The name of the account to be created.
   * @param industry The industry of the account to be created.
   */
  public static void createAccount(String name, String industry) {
    // Create a new Account and set the fields inline
    Account newAcct = new Account(Name = name, Industry = industry);
    // Insert the Account
    insert as user newAcct;
  }

  /**
   * Question 3
   * Create a new Contact and link it to the Account id provided then inserts it into the database.
   * @param accountId The Id of the Account to link the Contact to.
   * @return The Id of the newly created Contact.
   */
  public static Id insertNewContact(Id accountId) {
    // Create a new Contact instance
    Contact newCtct = new Contact(Firstname = 'Jane', Lastname = 'Bloggs');
    // Set some fields on the Contact
    newCtct.Email = 'jbloggs@iwishihadajob.com';
    newCtct.Title = 'Chief Shoe Tester';
    newCtct.Phone = '1-303=555-1212';
    newCtct.Department = 'Purchasing';
    // Set the AccountId field to the given accountId
    newCtct.AccountId = accountId;
    // Insert the Contact into the database
    insert as user newCtct;
    // Return the Id of the newly created Contact
    return newCtct.Id;
  }

  /**
   * Question 4
   * Update the last name of a Contact in the database.
   * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
   * @param contactId The Id of the Contact to update.
   * @param newLastName The new last name for the Contact.
   */
  public static void updateContactLastName(Id contactId, String newLastName) {
    // Retrieve the Contact from the database
    // [SELECT Id FROM Contact WHERE Id = :contactId]
    Contact ctct = [
      SELECT Id, LastName
      FROM Contact
      WHERE Id = :contactId
      LIMIT 1
    ];
    // Update the Contact's last name
    ctct.LastName = newLastName;
    // Update the Contact in the database
    update as user ctct;
  }

  /**
   * Question 5
   * Update the stage of an Opportunity in the database.
   * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
   * @param oppId The Id of the Opportunity to update.
   * @param newStage The new stage for the Opportunity.
   */
  public static void updateOpportunityStage(Id oppId, String newStage) {
    // Retrieve the Opportunity from the database
    // [SELECT Id FROM Opportunity WHERE Id = :oppId]
    Opportunity opp = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Id = :oppId
      LIMIT 1
    ];
    // Update the Opportunity's stage
    opp.StageName = newStage;
    // Update the Opportunity in the database
    update as user opp;
  }

  /**
   * Question 6
   * Update the Account's Name and Industry given an Account Id.
   * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
   * @param accountId The Id of the account to be updated.
   * @param newName The new name for the account.
   * @param newIndustry The new industry for the account.
   */
  public static void updateAccountFields(
    Id accountId,
    String newName,
    String newIndustry
  ) {
    // Query the account
    // [SELECT Id FROM Account WHERE Id = :accountId]
    Account acct = [
      SELECT Id, Name, Industry
      FROM Account
      WHERE Id = :accountId
      LIMIT 1
    ];
    // Update the Account with the given Id with the new name and industry
    acct.Name = newName;
    acct.Industry = newIndustry;
    update as user acct;
  }

  /**
   * Question 7
   * Create or updates an Opportunities
   * The Opportunity's Stage is set to Qualification.
   * The Opportunity's Close Date is set to 3 months from today.
   * The Opportunity's Amount is set to 50000.
   * @param list of Opportunities to be changed then upserted.
   */
  public static void upsertOpportunityList(List<Opportunity> opportunities) {
    // Loop through each Opportunity in the list
    // Set the Opportunity's Stage to Qualification
    // Set the Opportunity's Close Date to 3 months from today
    // Set the Opportunity's Amount to 50000
    for (Opportunity opp : opportunities) {
      opp.StageName = 'Qualification';
      opp.CloseDate = System.today().addMonths(3);
      opp.Amount = 50000;
    }
    // Upsert the opportunities List so that records are either updated or created
    upsert as user opportunities;
  }

  /**
   * Question 8
   * Insert or updates opportunities from list of names.
   * Associate the Opportunities with account that has the name accountName.
   * There should be an Opportunity for each name provided in the list.
   * @param accountName The name of the Account.
   * @param oppNames The list of Opportunity names.
   */
  public static void upsertOpportunities(
    String accountName,
    List<String> oppNames
  ) {
    List<Opportunity> oppsToUpsert = new List<Opportunity>();
    Set<Opportunity> oppsToUpsertSet = new Set<Opportunity>();
    List<Account> acctLst = [
      SELECT Id
      FROM Account
      WHERE Name = :accountName
      LIMIT 1
    ];
    Account acct;
    if (acctLst.isEmpty()) {
      acct = new Account(name = accountName);
      insert as user acct;
    } else {
      acct = acctLst[0];
    }
    List<Opportunity> existingOpps = [
      SELECT Id, Name, AccountId
      FROM Opportunity
      WHERE Name IN :oppNames AND AccountId = :acct.Id
    ];
    // Loop through each Opportunity name
    // Add the Opportunity to the list
    for (Integer i = 0; i < oppNames.size(); i++) {
      String oppName = oppNames[i];
      Boolean match = false;
      for (Integer j = 0; j < existingOpps.size(); j++) {
        String existingName = existingOpps[j].Name;
        if (oppName.equals(existingName)) {
          oppsToUpsertSet.add(existingOpps.remove(j));
          match = true;
          break;
        }
      }
      if (match == false) {
        oppsToUpsert.add(
          new Opportunity(
            Name = oppName,
            AccountId = acct.Id,
            StageName = 'Qualification',
            CloseDate = System.today().addMonths(3),
            Amount = 50000
          )
        );
      }
    }
    upsert as user oppsToUpsert;
  }

  /**
   * Question 9
   * Upserts an Account with the specified name.
   * If an Account with the given name already exists, update the description to "Updated Account".
   * If no such Account exists, it creates a new one and sets the description to "New Account".
   * @param accountName The name of the Account to be upserted.
   * @return The Account that was upserted.
   */
  public static Account upsertAccount(String accountName) {
    // Query for the Account
    List<Account> accounts = [
      SELECT Id, Description
      FROM Account
      WHERE Name = :accountName
      LIMIT 1
    ];
    Account acct;
    // if the Account exists, update the description
    if (!accounts.isEmpty()) {
      acct = accounts[0];
      acct.Description = 'Updated Account';
      // otherwise, create a new Account and set the description
    } else {
      acct = new Account(Name = accountName, Description = 'New Account');
    }
    // Upsert the Account
    upsert as user acct;
    return acct;
  }

  /**
   * Question 10
   * Manage the association between Contacts and Accounts
   * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
   * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
   * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe'
   * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
   * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
   */
  public static void upsertAccountsWithContacts(
    List<Contact> contactsToUpsert
  ) {
    Set<String> acctNamesSet = new Set<String>();
    Map<String, Id> acctNameToIdMap = new Map<String, Id>();
    List<Account> acctsToInsert = new List<Account>();
    // Loop through each Contact
    for (Contact ctct : contactsToUpsert) {
      // Extract the Account Name from Contact's LastName
      acctNamesSet.add(ctct.LastName);
    }
    List<Account> existingAcctLst = [
      SELECT Id, Name
      FROM Account
      WHERE Name IN :acctNamesSet
    ];
    String name;
    List<String> acctNamesLst = new List<String>(acctNamesSet);
    // Get the account based on the name or create one if it doesn't exist
    for (Integer i = 0; i < acctNamesLst.size(); i++) {
      name = acctNamesLst[i];
      Boolean match = false;
      for (Integer j = 0; j < existingAcctLst.size(); j++) {
        String acctName = existingAcctLst[j].Name;
        if (name.equals(acctName)) {
          match = true;
          acctNameToIdMap.put(name, existingAcctLst[j].Id);
          break;
        }
      }
      if (match == false) {
        acctsToInsert.add(new Account(Name = name));
      }
    }
    insert as user acctsToInsert;
    for (Account acct : acctsToInsert) {
      acctNameToIdMap.put(acct.Name, acct.Id);
    }
    for (Contact ctct : contactsToUpsert) {
      if (acctNameToIdMap.keySet().contains(ctct.LastName)) {
        Id acctId = acctNameToIdMap.get(ctct.LastName);
        ctct.AccountId = acctId;
      } else {
        System.debug('**Account name found that doesn\'t match a last name');
      }
    }
    // Upsert the Contacts
    upsert contactsToUpsert;
  }

  /**
   * Question 11
   * Insert a list of Leads and then deletes them.
   * @param leadNames The list of Lead names to be inserted.
   */
  public static void insertAndDeleteLeads(List<String> leadNames) {
    List<Lead> newLeadsLst = new List<Lead>();
    // Loop through each Lead name
    for (String name : leadNames) {
      newLeadsLst.add(new Lead(LastName = name, Company = 'Fake Company'));
    }
    // Insert the Leads
    insert as user newLeadsLst;
    // Delete the Leads
    delete as user newLeadsLst;
  }

  /**
   * Question 12
   * Dynamically create the number of cases and relate it to the accountId, then deletes them.
   * @param accountId The account for which the cases will be created and then deleted.
   * @param numOfCases The number of cases to create.
   */
  public static void createAndDeleteCases(
    String accountId,
    Integer numOfCases
  ) {
    List<Case> newCaseLst = new List<Case>();
    // Insert the cases
    for (Integer i = 0; i < numOfCases; i++) {
      newCaseLst.add(
        new Case(
          Subject = 'New Case #' + String.valueOf(i + 1),
          AccountId = accountId
        )
      );
    }
    insert as user newCaseLst;
    // Delete the cases
    delete as user newCaseLst;
  }
}
