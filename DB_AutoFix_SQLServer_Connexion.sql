/*create login if not exists*/
EXEC sp_change_users_login 'Auto_Fix', 'domain\user'
