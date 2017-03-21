USE [AdventureWorks2008R2]
GO
DECLARE @s TABLE(
	 spid		SMALLINT	
	--,kpid		SMALLINT		--ID de thread Windows.
	,blocked	SMALLINT	/*ID de la session qui bloque la demande. Si cette colonne est NULL, la demande n'est pas bloquée, ou les informations de session de la session bloquant la demande ne sont pas disponibles (ou ne peuvent pas être identifiées).
								-2 = La ressource qui bloque la demande appartient à une transaction distribuée orpheline.
								-3 = La ressource qui bloque la demande appartient à une transaction de récupération différée.
								-4 = L'ID de session du propriétaire du verrou qui bloque la demande n'a pas pu être déterminé en raison de transitions d'état de verrou interne.
								*/
	--,waittype	BINARY(2)		--Réservé.
	--,waittime	BIGINT			--Temps d'attente total (en millisecondes).	0 = Le processus n'est pas en attente.
	--,lastwaittype	NCHAR(32)	--Chaîne indiquant le nom du dernier type d'attente ou celui du type d'attente actuel.
	,waitresource	NCHAR(256)	--Description textuelle d'une ressource de verrouillage.
	--,[dbid]	SMALLINT			--ID de la base de données actuellement utilisée par le processus.
	--,[uid]	SMALLINT			--ID de l'utilisateur qui a exécuté la commande. Effectue un dépassement de capacité ou retourne la valeur NULL si le nombre d'utilisateurs et de rôles dépasse 32 767. Pour plus d'informations, consultez Interrogation des catalogues système de SQL Server.
	,cpu	INTEGER				--Temps UC cumulé pour l'exécution du processus. L'entrée est mise à jour pour tous les processus, indépendamment de la valeur de l'option SET STATISTICS TIME (ON ou OFF).
	,physical_io	BIGINT		--Nombre total d'opérations d'écriture et de lecture sur disque pour le processus.
	--,memusage	INTEGER			--Nombre de pages du cache de procédure actuellement allouées à ce processus. Un nombre négatif indique que le processus libère de la mémoire allouée par un autre processus.
	,login_time	DATETIME		--Heure à laquelle le processus client s'est connecté au serveur. Pour les processus système, il s'agit du moment auquel le lancement de SQL Server est enregistré.
	--,last_batch	DATETIME		--Dernière exécution par un processus client d'un appel de procédure stockée distante ou d'une instruction EXECUTE. Pour les processus système, il s'agit du moment auquel le lancement de SQL Server est enregistré.
	--,ecid	SMALLINT			--ID du contexte d'exécution utilisé pour identifier de façon unique les sous-threads exécutés pour le compte d'un seul et même processus.
	--,open_tran	SMALLINT		--Nombre de transactions en cours pour le processus.
	,[status]	NCHAR(30)		/*État de l'ID processus. Les valeurs possibles sont les suivantes :
								dormant = SQL Server est en train de réinitialiser la session.
								running = la session est en train d'exécuter un ou plusieurs traitements. Lorsque la fonctionnalité MARS (Multiple Active Result Sets) est activée, une session peut exécuter plusieurs traitements. Pour plus d'informations, consultezUtilisation de MARS (Multiple Active Result Sets).
								background = la session est en train d'exécuter une tâche en arrière-plan, comme par exemple une détection de blocage.
								rollback = un processus de restauration de transaction est en cours dans la session.
								pending = la session attend qu'un thread de travail soit disponible.
								runnable = la tâche de la session se trouve dans la file d'attente exécutable d'un planificateur en attendant d'obtenir un quantum de temps.
								spinloop = la tâche de la session attend qu'un verrouillage spinlock se libère.
								suspended = la session attend la fin d'un événement, tel qu'une E/S.
								*/
	--,[sid]	BINARY(86)			--GUID (Globally Unique Identifier) de l'utilisateur.
	,hostname	NCHAR(128)		--Nom de la station de travail.
	,[program_name]	NCHAR(128)	--Nom du logiciel d'application.
	--,hostprocess	NCHAR(10)	--Numéro d'identification du processus de la station de travail.
	,cmd	NCHAR(16)			--Commande actuellement exécutée.
	--,nt_domain	NCHAR(128)		--Domaine Windows du client (s'il utilise l'authentification Windows) ou d'une connexion approuvée.
	--,nt_username	NCHAR(128)	--Nom d'utilisateur Windows pour le processus (s'il utilise l'authentification Windows) ou une connexion approuvée.
	--,net_address	NCHAR(12)	--Identificateur unique affecté à la carte réseau de la station de travail de chaque utilisateur. Lorsque un utilisateur se connecte, cet identificateur est inséré dans la colonne net_address.
	--,net_library	NCHAR(12)	--Colonne dans laquelle est enregistrée la bibliothèque réseau du client. Chaque processus client arrive sur une connexion réseau. Les connexions réseau ont une bibliothèque réseau associée qui leur permet de se connecter. Pour plus d'informations, consultez Protocoles réseau et points de terminaison TDS.
	,loginame	NCHAR(128)		--Nom de la connexion.
	--,[context_info]	BINARY(128)	--Données stockées dans un traitement à l'aide de l'instruction SET CONTEXT_INFO.
	/*,[sql_handle]	BINARY(20)	Représente le traitement ou l'objet en cours d'exécution.
	,							Remarque   Cette valeur est dérivée du traitement ou de l'adresse mémoire de l'objet. Cette valeur n'est pas calculée à l'aide de l'algorithme de hachage de SQL Server.
	,							*/
	,stmt_start	INTEGER			--Décalage de début de l'instruction SQL en cours pour la colonne sql_handle spécifiée.
	,stmt_end	INTEGER			--Décalage de fin de l'instruction SQL actuelle pour la colonne sql_handle spécifiée.-1 = L'instruction en cours s'exécute jusqu'à la fin des résultats renvoyés par la fonction fn_get_sql pour la colonne sql_handle spécifiée.
	--,request_id	INTEGER			--ID de la requête. Utilisé pour identifier les requêtes qui s'exécutent dans une session spécifique.
	,[text] TEXT				--requete SQL executée
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

