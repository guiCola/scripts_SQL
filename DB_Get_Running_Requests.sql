USE [AdventureWorks2008R2]
GO
DECLARE @s TABLE(
	 spid		SMALLINT	
	--,kpid		SMALLINT		--ID de thread Windows.
	,blocked	SMALLINT	/*ID de la session qui bloque la demande. Si cette colonne est NULL, la demande n'est pas bloqu�e, ou les informations de session de la session bloquant la demande ne sont pas disponibles (ou ne peuvent pas �tre identifi�es).
								-2 = La ressource qui bloque la demande appartient � une transaction distribu�e orpheline.
								-3 = La ressource qui bloque la demande appartient � une transaction de r�cup�ration diff�r�e.
								-4 = L'ID de session du propri�taire du verrou qui bloque la demande n'a pas pu �tre d�termin� en raison de transitions d'�tat de verrou interne.
								*/
	--,waittype	BINARY(2)		--R�serv�.
	--,waittime	BIGINT			--Temps d'attente total (en millisecondes).	0 = Le processus n'est pas en attente.
	--,lastwaittype	NCHAR(32)	--Cha�ne indiquant le nom du dernier type d'attente ou celui du type d'attente actuel.
	,waitresource	NCHAR(256)	--Description textuelle d'une ressource de verrouillage.
	--,[dbid]	SMALLINT			--ID de la base de donn�es actuellement utilis�e par le processus.
	--,[uid]	SMALLINT			--ID de l'utilisateur qui a ex�cut� la commande. Effectue un d�passement de capacit� ou retourne la valeur NULL si le nombre d'utilisateurs et de r�les d�passe 32 767. Pour plus d'informations, consultez�Interrogation des catalogues syst�me de SQL�Server.
	,cpu	INTEGER				--Temps UC cumul� pour l'ex�cution du processus. L'entr�e est mise � jour pour tous les processus, ind�pendamment de la valeur de l'option SET STATISTICS TIME (ON ou OFF).
	,physical_io	BIGINT		--Nombre total d'op�rations d'�criture et de lecture sur disque pour le processus.
	--,memusage	INTEGER			--Nombre de pages du cache de proc�dure actuellement allou�es � ce processus. Un nombre n�gatif indique que le processus lib�re de la m�moire allou�e par un autre processus.
	,login_time	DATETIME		--Heure � laquelle le processus client s'est connect� au serveur. Pour les processus syst�me, il s'agit du moment auquel le lancement de SQL Server est enregistr�.
	--,last_batch	DATETIME		--Derni�re ex�cution par un processus client d'un appel de proc�dure stock�e distante ou d'une instruction EXECUTE. Pour les processus syst�me, il s'agit du moment auquel le lancement de SQL Server est enregistr�.
	--,ecid	SMALLINT			--ID du contexte d'ex�cution utilis� pour identifier de fa�on unique les sous-threads ex�cut�s pour le compte d'un seul et m�me processus.
	--,open_tran	SMALLINT		--Nombre de transactions en cours pour le processus.
	,[status]	NCHAR(30)		/*�tat de l'ID processus. Les valeurs possibles sont les suivantes :
								dormant�= SQL Server est en train de r�initialiser la session.
								running�= la session est en train d'ex�cuter un ou plusieurs traitements. Lorsque la fonctionnalit� MARS (Multiple Active Result Sets) est activ�e, une session peut ex�cuter plusieurs traitements. Pour plus d'informations, consultezUtilisation de MARS (Multiple Active Result Sets).
								background�= la session est en train d'ex�cuter une t�che en arri�re-plan, comme par exemple une d�tection de blocage.
								rollback�= un processus de restauration de transaction est en cours dans la session.
								pending�= la session attend qu'un thread de travail soit disponible.
								runnable�= la t�che de la session se trouve dans la file d'attente ex�cutable d'un planificateur en attendant d'obtenir un quantum de temps.
								spinloop�= la t�che de la session attend qu'un verrouillage spinlock se lib�re.
								suspended�= la session attend la fin d'un �v�nement, tel qu'une E/S.
								*/
	--,[sid]	BINARY(86)			--GUID (Globally Unique Identifier) de l'utilisateur.
	,hostname	NCHAR(128)		--Nom de la station de travail.
	,[program_name]	NCHAR(128)	--Nom du logiciel d'application.
	--,hostprocess	NCHAR(10)	--Num�ro d'identification du processus de la station de travail.
	,cmd	NCHAR(16)			--Commande actuellement ex�cut�e.
	--,nt_domain	NCHAR(128)		--Domaine Windows du client (s'il utilise l'authentification Windows) ou d'une connexion approuv�e.
	--,nt_username	NCHAR(128)	--Nom d'utilisateur Windows pour le processus (s'il utilise l'authentification Windows) ou une connexion approuv�e.
	--,net_address	NCHAR(12)	--Identificateur unique affect� � la carte r�seau de la station de travail de chaque utilisateur. Lorsque un utilisateur se connecte, cet identificateur est ins�r� dans la colonne net_address.
	--,net_library	NCHAR(12)	--Colonne dans laquelle est enregistr�e la biblioth�que r�seau du client. Chaque processus client arrive sur une connexion r�seau. Les connexions r�seau ont une biblioth�que r�seau associ�e qui leur permet de se connecter. Pour plus d'informations, consultez�Protocoles r�seau et points de terminaison TDS.
	,loginame	NCHAR(128)		--Nom de la connexion.
	--,[context_info]	BINARY(128)	--Donn�es stock�es dans un traitement � l'aide de l'instruction SET CONTEXT_INFO.
	/*,[sql_handle]	BINARY(20)	Repr�sente le traitement ou l'objet en cours d'ex�cution.
	,							Remarque���Cette valeur est d�riv�e du traitement ou de l'adresse m�moire de l'objet. Cette valeur n'est pas calcul�e � l'aide de l'algorithme de hachage de SQL Server.
	,							*/
	,stmt_start	INTEGER			--D�calage de d�but de l'instruction SQL en cours pour la colonne sql_handle sp�cifi�e.
	,stmt_end	INTEGER			--D�calage de fin de l'instruction SQL actuelle pour la colonne sql_handle sp�cifi�e.-1 = L'instruction en cours s'ex�cute jusqu'� la fin des r�sultats renvoy�s par la fonction fn_get_sql pour la colonne sql_handle sp�cifi�e.
	--,request_id	INTEGER			--ID de la requ�te. Utilis� pour identifier les requ�tes qui s'ex�cutent dans une session sp�cifique.
	,[text] TEXT				--requete SQL execut�e
	)

DECLARE @sql_handle BINARY(20)
		,@spid SMALLINT;
		
DECLARE c1 CURSOR FOR 
	SELECT [sql_handle]
			,spid 
	FROM [master]..sysprocesses 
	WHERE spid >50;
	
OPEN c1;
FETCH NEXT FROM c1 INTO @sql_handle,@spid; 
WHILE (@@FETCH_STATUS =0) 
BEGIN 
      INSERT INTO @s
		SELECT spid
				--,kpid
				,blocked	
				--,waittype	
				--,waittime	
				--,lastwaittype
				,waitresource
				--,a.[dbid]	
				--,[uid]	
				,cpu	
				,physical_io	
				--,memusage	
				,login_time	
				--,last_batch	
				--,ecid	
				--,open_tran	
				,[status]	
				--,[sid]	
				,hostname	
				,[program_name]	
				--,hostprocess	
				,cmd	
				--,nt_domain	
				--,nt_username
				--,net_address
				--,net_library	
				,loginame	
				--,[context_info]
				--,[sql_handle]	
				,stmt_start	
				,stmt_end	
				--,request_id	
				,a.[text]
      FROM ::fn_get_sql(@sql_handle) a
		INNER JOIN [master]..sysprocesses b ON b.spid = @spid
		
FETCH NEXT FROM c1 INTO @sql_handle,@spid
END 
CLOSE c1
DEALLOCATE c1;

select * from @s
order by physical_io desc ,cpu desc

