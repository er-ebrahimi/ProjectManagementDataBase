--query:
--	deletes all completed tasks from all projects 
delete  from task 
where task.flag=1