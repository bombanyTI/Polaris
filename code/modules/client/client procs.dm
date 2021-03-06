	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.

//#define TOPIC_DEBUGGING 1

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	#if defined(TOPIC_DEBUGGING)
	world << "[src]'s Topic: [href] destined for [hsrc]."

	if(href_list["nano_err"]) //nano throwing errors
		world << "## NanoUI, Subject [src]: " + html_decode(href_list["nano_err"]) //NANO DEBUG HOOK

	#endif

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C,null)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			usr << "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you</span>"
			return
		if(mute_irc)
			usr << "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>"
			return
		cmd_admin_irc_pm(href_list["irc_msg"])
		return



	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["karmashop"])
		if("tab")
			karma_tab = text2num(href_list["tab"])
			karmashopmenu()
			return
		if("shop")
			if(href_list["KarmaBuy"])
				var/karma=verify_karma()
				switch(href_list["KarmaBuy"])
					if("1")
						if(karma <5)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Barber?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Barber",5)
							return
					if("2")
						if(karma <15)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Brig Physician?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Brig Physician",15)
							return
					if("3")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Nanotrasen Representative?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Nanotrasen Representative",30)
							return
					if("5")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Blueshield?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Blueshield",30)
							return
					if("6")
						if(karma <10)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Mechanic?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Mechanic",10)
							return
					if("7")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Magistrate?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Magistrate",30)
							return
					if("9")
						if(karma <15)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Security Pod Pilot?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_job_unlock("Security Pod Pilot",15)
							return
			if(href_list["KarmaBuy2"])
				var/karma=verify_karma()
				switch(href_list["KarmaBuy2"])
					if("1")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Machine People?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Machine",30)
							return
					if("2")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Kidan?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Kidan",30)
							return
					if("3")
						if(karma <60)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Grey?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Grey",60)
							return
					if("4")
						if(karma <40)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Vox?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Vox",40)
							return
					if("5")
						if(karma <50)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Slime People?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Slime People",50)
							return
					if("6")
						if(karma <40)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Plasmaman?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Plasmaman",40)
							return
					if("7")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							if(alert("Are you sure you want to unlock Drask?", "Confirmation", "No", "Yes") != "Yes")
								return
							DB_species_unlock("Drask",30)
							return
					if("8")
						if(karma <80)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Unathi",80)
							return
					if("9")
						if(karma <60)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Tajaran",60)
							return
					if("10")
						if(karma <25)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Diona",25)
							return
					if("11")
						if(karma <70)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Nucleation",70)
							return
					if("12")
						if(karma <30)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Wryn",30)
							return
					if("13")
						if(karma <45)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Skrell",45)
							return
					if("14")
						if(karma <70)
							to_chat(usr, "You do not have enough karma!")
							return
						else
							src.DB_species_unlock("Vulpkanin",75)
							return

			if(href_list["KarmaBuy3"])
				var/karma=verify_karma()
				switch(href_list["KarmaBuy3"])
					if("4001")
						if(karma < 5)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4001",5)
					if("4002")
						if(karma < 5)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4002",5)
					if("4003")
						if(karma < 5)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4003",5)
					if("4005")
						if(karma < 5)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4005",5)
					if("9001")
						if(karma < 10)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("9001",10)
					if("4006")
						if(karma < 10)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4006",10)
					if("4008")
						if(karma < 10)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4008",10)
					if("1")
						if(karma < 15)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("0001",3)
							src.DB_item_unlock("4007",3)
							src.DB_item_unlock("5001",3)
							src.DB_item_unlock("6001",3)
							src.DB_item_unlock("7001",3)
					if("0002")
						if(karma < 40)
							to_chat(usr, "IDIOT! You do not have enough karma!")
						else
							src.DB_item_unlock("0002", 40)

					if("2")
						if(karma < 15)
							to_chat(usr, "You do not have enough karma!")
						else
							src.DB_item_unlock("0003", 5)
							src.DB_item_unlock("5002", 5)
							src.DB_item_unlock("7002", 5)
					if("3")
						if(karma < 20)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("5008",5)
							src.DB_item_unlock("7003",5)
							src.DB_item_unlock("0004",5)
							src.DB_item_unlock("4012",5)
					if("4")
						if(karma < 20)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("0005",10)
							src.DB_item_unlock("5010",10)
					if("5")
						if(karma < 20)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("0006",5)
							src.DB_item_unlock("5011",5)
							src.DB_item_unlock("6002",5)
							src.DB_item_unlock("7004",5)
					if("5009")
						if(karma < 10)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("5009",10)
					if("5012")
						if(karma < 10)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("5012",10)
					if("4013")
						if(karma < 25)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4013",25)
					if("4014")
						if(karma < 10)
							to_chat(usr,"You do not have enough karma!")
						else
							src.DB_item_unlock("4014",10)
					if("0003")
						if(karma < 40)
							to_chat(usr, "What a pityful shame. Thou has not enough karma.")
						else
							src.DB_item_unlock("4009", 5)
							src.DB_item_unlock("4010", 5)
							src.DB_item_unlock("4011", 5)
							src.DB_item_unlock("5003", 5)
							src.DB_item_unlock("5004", 5)
							src.DB_item_unlock("5005", 5)
							src.DB_item_unlock("5006", 5)
							src.DB_item_unlock("5007", 5)


	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	..()	//redirect to hsrc.Topic()

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

	if(!config.guests_allowed && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return

	src << "<font color='red'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</font>"


	clients += src
	directory[ckey] = src

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()
	prefs.sanitize_preferences()

	if(custom_event_msg && custom_event_msg != "")
		src << "<h1 class='alert'>Custom Event</h1>"
		src << "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>"
		src << "<span class='alert'>[custom_event_msg]</span>"
		src << "<br>"


	if(holder)
		add_admin_verbs()
		admin_memo_show()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit more, possibly fixes hardware mode not re-activating right
			winset(src, null, "command=\".configure graphics-hwmode on\"")

	log_client_to_db()

	send_resources()
	nanomanager.send_resources(src)

	if(!void)
		void = new()
		void.MakeGreed()
	screen += void

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		src << "<span class='info'>You have unread updates in the changelog.</span>"
		winset(src, "rpane.changelog", "background-color=#eaeaea;font-style=bold")
		if(config.aggressive_changelog)
			src.changes()



	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(holder)
		holder.owner = null
		admins -= src
	directory -= ckey
	clients -= src
	return ..()

/client/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

// here because it's similar to below

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/proc/get_player_age(key)
	establish_db_connection()
	if(!dbcon.IsConnected())
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/DBQuery/query = dbcon.NewQuery("SELECT datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		return text2num(query.item[1])
	else
		return -1


/client/proc/log_client_to_db()

	if ( IsGuestKey(src.key) )
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	player_age = 0	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		break

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	//Panic bunker code
	if (isnum(player_age) && player_age == 0) //first connection
		if (config.panic_bunker && !holder && !deadmin_holder)
			log_adminwarn("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, "Sorry but the server is currently not accepting connections from never before seen players.")
			qdel(src)
			return 0

	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/DBQuery/query_update = dbcon.NewQuery("UPDATE erro_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE id = [sql_id]")
		query_update.Execute()
	else
		//New player!! Need to insert all the stuff
		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `erro_connection_log`(`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()

#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

/client/proc/is_in_whitelist()
	if(!prefs.whitelist)
		return 0
	return 1

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	. = ..()
	if (holder)
		sleep(1)
	else
		stoplag(5)

/client/proc/last_activity_seconds()
	return inactivity / 10

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()

	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/images/loading.gif',
		'html/images/ntlogo.png',
		'html/images/sglogo.png',
		'html/images/talisman.png',
		'html/images/paper_bg.png',
		'icons/pda_icons/pda_atmos.png',
		'icons/pda_icons/pda_back.png',
		'icons/pda_icons/pda_bell.png',
		'icons/pda_icons/pda_blank.png',
		'icons/pda_icons/pda_boom.png',
		'icons/pda_icons/pda_bucket.png',
		'icons/pda_icons/pda_crate.png',
		'icons/pda_icons/pda_cuffs.png',
		'icons/pda_icons/pda_eject.png',
		'icons/pda_icons/pda_exit.png',
		'icons/pda_icons/pda_flashlight.png',
		'icons/pda_icons/pda_honk.png',
		'icons/pda_icons/pda_mail.png',
		'icons/pda_icons/pda_medical.png',
		'icons/pda_icons/pda_menu.png',
		'icons/pda_icons/pda_mule.png',
		'icons/pda_icons/pda_notes.png',
		'icons/pda_icons/pda_power.png',
		'icons/pda_icons/pda_rdoor.png',
		'icons/pda_icons/pda_reagent.png',
		'icons/pda_icons/pda_refresh.png',
		'icons/pda_icons/pda_scanner.png',
		'icons/pda_icons/pda_signaler.png',
		'icons/pda_icons/pda_status.png',
		'icons/spideros_icons/sos_1.png',
		'icons/spideros_icons/sos_2.png',
		'icons/spideros_icons/sos_3.png',
		'icons/spideros_icons/sos_4.png',
		'icons/spideros_icons/sos_5.png',
		'icons/spideros_icons/sos_6.png',
		'icons/spideros_icons/sos_7.png',
		'icons/spideros_icons/sos_8.png',
		'icons/spideros_icons/sos_9.png',
		'icons/spideros_icons/sos_10.png',
		'icons/spideros_icons/sos_11.png',
		'icons/spideros_icons/sos_12.png',
		'icons/spideros_icons/sos_13.png',
		'icons/spideros_icons/sos_14.png'
		)


mob/proc/MayRespawn()
	return 0

client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

client/verb/character_setup()
	set name = "Character Setup"
	set category = "Preferences"
	if(prefs)
		prefs.ShowChoices(usr)
