CREATE DATABASE CyberSecureCloudSolutionsDB;
GO

USE CyberSecureCloudSolutionsDB;
GO

CREATE TABLE dbo.Client (
    ClientID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(255) NOT NULL UNIQUE,
    ContactPhone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE dbo.Account (
    AccountID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AccountName NVARCHAR(100) NOT NULL,
    ClientID INT NOT NULL,
    SubscriptionDate DATE NOT NULL,
    AccountStatus NVARCHAR(20) NOT NULL CONSTRAINT DF_AccountStatus DEFAULT ('Active'),
    LastModifiedDate DATETIME2(0) NOT NULL CONSTRAINT DF_AccountLastModifiedDate DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_Account_Client
        FOREIGN KEY (ClientID) REFERENCES dbo.Client(ClientID),
    CONSTRAINT CK_AccountStatus
        CHECK (AccountStatus IN ('Active', 'Suspended', 'Closed'))
);
GO

CREATE TABLE dbo.Services (
    ServiceID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL UNIQUE,
    ServiceDescription NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE dbo.Subscriptions (
    SubscriptionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AccountID INT NOT NULL,
    ServiceID INT NOT NULL,
    SubscriptionDate DATE NOT NULL,
    SubscriptionStatus NVARCHAR(20) NOT NULL CONSTRAINT DF_SubscriptionStatus DEFAULT ('Active'),
    CONSTRAINT FK_Subscriptions_Account
        FOREIGN KEY (AccountID) REFERENCES dbo.Account(AccountID),
    CONSTRAINT FK_Subscriptions_Service
        FOREIGN KEY (ServiceID) REFERENCES dbo.Services(ServiceID),
    CONSTRAINT UQ_Subscriptions_Account_Service_Date
        UNIQUE (AccountID, ServiceID, SubscriptionDate),
    CONSTRAINT CK_SubscriptionStatus
        CHECK (SubscriptionStatus IN ('Active', 'Suspended', 'Cancelled'))
);
GO

CREATE TABLE dbo.Billing (
    BillingID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SubscriptionID INT NOT NULL,
    BillingDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Billing_Subscription
        FOREIGN KEY (SubscriptionID) REFERENCES dbo.Subscriptions(SubscriptionID),
    CONSTRAINT CK_Billing_Amount
        CHECK (Amount > 0),
    CONSTRAINT CK_PaymentStatus
        CHECK (PaymentStatus IN ('Paid', 'Unpaid', 'Pending'))
);
GO

CREATE TABLE dbo.CybersecurityIncidents (
    IncidentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AccountID INT NOT NULL,
    IncidentDate DATE NOT NULL,
    IncidentType NVARCHAR(100) NOT NULL,
    IncidentStatus NVARCHAR(20) NOT NULL,
    SeverityLevel NVARCHAR(20) NOT NULL,
    Description NVARCHAR(500) NOT NULL,
    CONSTRAINT FK_Incidents_Account
        FOREIGN KEY (AccountID) REFERENCES dbo.Account(AccountID),
    CONSTRAINT CK_IncidentStatus
        CHECK (IncidentStatus IN ('Open', 'Investigating', 'Resolved')),
    CONSTRAINT CK_SeverityLevel
        CHECK (SeverityLevel IN ('Low', 'Medium', 'High', 'Critical'))
);
GO

CREATE INDEX IX_Account_ClientID
ON dbo.Account (ClientID);
GO

CREATE INDEX IX_Subscriptions_AccountID_ServiceID
ON dbo.Subscriptions (AccountID, ServiceID);
GO

CREATE INDEX IX_Billing_SubscriptionID_BillingDate
ON dbo.Billing (SubscriptionID, BillingDate);
GO

CREATE INDEX IX_Incidents_AccountID_IncidentDate_Status
ON dbo.CybersecurityIncidents (AccountID, IncidentDate, IncidentStatus);
GO

INSERT INTO dbo.Client (Name, ContactEmail, ContactPhone, Address)
VALUES
('Tech Corp', 'contact@techcorp.com', '555-1234', '123 Tech Lane'),
('BlueWave Ltd', 'admin@bluewave.com', '555-5678', '45 Ocean Road'),
('SecureBank', 'it@securebank.com', '555-9012', '77 Finance Ave'),
('GreenHealth', 'ops@greenhealth.com', '555-3456', '12 Wellness St'),
('EduNext', 'support@edunext.com', '555-7890', '88 Campus Dr');
GO


INSERT INTO dbo.Account (AccountName, ClientID, SubscriptionDate, AccountStatus)
VALUES
('Main Account', 1, '2024-01-15', 'Active'),
('Backup Account', 2, '2024-01-20', 'Active'),
('Finance Account', 3, '2024-01-25', 'Suspended'),
('Operations Account', 4, '2024-01-30', 'Active'),
('Training Account', 5, '2024-02-01', 'Closed');
GO

INSERT INTO dbo.Services (ServiceName, ServiceDescription)
VALUES
('Cloud Storage', 'Secure cloud storage with encrypted backups'),
('Virtual Machines', 'Scalable virtual machine hosting'),
('Cybersecurity Monitoring', '24/7 monitoring of security events and threats');
GO

INSERT INTO dbo.Subscriptions (AccountID, ServiceID, SubscriptionDate, SubscriptionStatus)
VALUES
(1, 1, '2024-02-15', 'Active'),
(1, 3, '2024-03-01', 'Active'),
(2, 2, '2024-02-20', 'Active'),
(3, 1, '2024-03-05', 'Suspended'),
(4, 3, '2024-03-10', 'Active');
GO


INSERT INTO dbo.Billing (SubscriptionID, BillingDate, Amount, PaymentStatus)
VALUES
(1, '2024-02-28', 100.00, 'Paid'),
(2, '2024-03-31', 150.00, 'Unpaid'),
(3, '2024-02-28', 200.00, 'Paid'),
(4, '2024-03-31', 120.00, 'Pending'),
(5, '2024-04-30', 175.00, 'Paid');
GO


INSERT INTO dbo.CybersecurityIncidents
(AccountID, IncidentDate, IncidentType, IncidentStatus, SeverityLevel, Description)
VALUES
(1, '2024-02-20', 'DDoS Attack', 'Investigating', 'High', 'Traffic spike detected and blocked'),
(2, '2024-02-25', 'Phishing Attempt', 'Resolved', 'Medium', 'Suspicious email quarantined'),
(3, '2024-03-02', 'Malware Detected', 'Open', 'Critical', 'Endpoint isolated for investigation'),
(4, '2024-03-15', 'Unauthorized Login', 'Resolved', 'High', 'Login attempts traced and blocked'),
(1, '2024-04-01', 'Port Scan', 'Open', 'Low', 'Repeated scan from external IP');
GO