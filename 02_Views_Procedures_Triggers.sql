USE CyberSecureCloudSolutionsDB;
GO

/* =========================================
VIEW 1: Clients and their Accounts
========================================= */
CREATE OR ALTER VIEW dbo.vw_ClientsAccounts
AS
SELECT
    c.ClientID,
    c.Name AS ClientName,
    c.ContactEmail,
    a.AccountID,
    a.AccountName,
    a.AccountStatus
FROM dbo.Client c
LEFT JOIN dbo.Account a
    ON c.ClientID = a.ClientID;
GO

/* =========================================
VIEW 2: Accounts and subscribed Services
========================================= */
CREATE OR ALTER VIEW dbo.vw_AccountsServices
AS
SELECT
    a.AccountID,
    a.AccountName,
    s.ServiceID,
    s.ServiceName,
    sub.SubscriptionDate,
    sub.SubscriptionStatus
FROM dbo.Subscriptions sub
INNER JOIN dbo.Account a
    ON sub.AccountID = a.AccountID
INNER JOIN dbo.Services s
    ON sub.ServiceID = s.ServiceID;
GO

/* =========================================
VIEW 3: Billing Information
========================================= */
CREATE OR ALTER VIEW dbo.vw_BillingInformation
AS
SELECT
    b.BillingID,
    b.BillingDate,
    b.Amount,
    b.PaymentStatus,
    a.AccountName,
    s.ServiceName
FROM dbo.Billing b
INNER JOIN dbo.Subscriptions sub
    ON b.SubscriptionID = sub.SubscriptionID
INNER JOIN dbo.Account a
    ON sub.AccountID = a.AccountID
INNER JOIN dbo.Services s
    ON sub.ServiceID = s.ServiceID;
GO

/* =========================================
VIEW 4: Cybersecurity Incidents
========================================= */
CREATE OR ALTER VIEW dbo.vw_CybersecurityIncidents
AS
SELECT
    i.IncidentID,
    i.IncidentDate,
    i.IncidentType,
    i.IncidentStatus,
    i.SeverityLevel,
    a.AccountName
FROM dbo.CybersecurityIncidents i
INNER JOIN dbo.Account a
    ON i.AccountID = a.AccountID;
GO

/* =========================================
PROCEDURE 1: Insert Client
========================================= */
CREATE OR ALTER PROCEDURE dbo.usp_InsertClient
    @Name NVARCHAR(100),
    @ContactEmail NVARCHAR(255),
    @ContactPhone NVARCHAR(20),
    @Address NVARCHAR(255)
AS
BEGIN
    INSERT INTO dbo.Client
    (Name, ContactEmail, ContactPhone, Address)
    VALUES
    (@Name, @ContactEmail, @ContactPhone, @Address);
END;
GO

/* =========================================
PROCEDURE 2: Update Account
========================================= */
CREATE OR ALTER PROCEDURE dbo.usp_UpdateAccount
    @AccountID INT,
    @AccountName NVARCHAR(100),
    @AccountStatus NVARCHAR(20)
AS
BEGIN
    UPDATE dbo.Account
    SET
        AccountName = @AccountName,
        AccountStatus = @AccountStatus
    WHERE AccountID = @AccountID;
END;
GO

/* =========================================
PROCEDURE 3: Delete Cybersecurity Incident
========================================= */
CREATE OR ALTER PROCEDURE dbo.usp_DeleteCybersecurityIncident
    @IncidentID INT
AS
BEGIN
    DELETE FROM dbo.CybersecurityIncidents
    WHERE IncidentID = @IncidentID;
END;
GO

/* =========================================
TRIGGER 1:
Update LastModifiedDate automatically
========================================= */
CREATE OR ALTER TRIGGER dbo.trg_UpdateLastModifiedDate
ON dbo.Account
AFTER UPDATE
AS
BEGIN
    UPDATE dbo.Account
    SET LastModifiedDate = GETDATE()
    WHERE AccountID IN (SELECT AccountID FROM inserted);
END;
GO

/* =========================================
TRIGGER 2:
Prevent deleting client with active accounts
========================================= */
CREATE OR ALTER TRIGGER dbo.trg_PreventClientDelete
ON dbo.Client
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM dbo.Account a
        INNER JOIN deleted d
            ON a.ClientID = d.ClientID
        WHERE a.AccountStatus = 'Active'
    )
    BEGIN
        RAISERROR ('Cannot delete client with active accounts.', 16, 1);
        RETURN;
    END

    DELETE FROM dbo.Client
    WHERE ClientID IN (SELECT ClientID FROM deleted);
END;
GO