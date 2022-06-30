--query:
--	 Show accounts list and their name sorted by number of projects they attended 
SELECT a.accountID,concat(a.firstName,' ', a.lastName) as fullName , COUNT(p.ProjectID) AS TotalProjects
FROM account a
INNER JOIN member m ON m.accountID=a.accountID
LEFT JOIN project p
    ON p.projectID = m.ProjectID 
group by a.accountID , a.firstName ,a.lastName
order by count(p.projectID)