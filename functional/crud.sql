DROP PROCEDURE IF EXISTS #db#.createUser//
CREATE PROCEDURE IF EXISTS #db#.createUser (
	a_role INT UNSIGNED,
	a_username VARCHAR(1),
	a_email VARCHAR(100),
	a_password VARCHAR(32),
	a_timezone FLOAT,
	a_active INT UNSIGNED,
	a_lastturntime INT UNSIGNED,
	a_datecreated INT UNSIGNED,
	a_datebanned INT UNSIGNED,
	a_reason VARCHAR(1),
	a_nation INT UNSIGNED,
	a_commander INT UNSIGNED,
	a_clicks INT UNSIGNED,
	a_food INT UNSIGNED,
	a_steel INT UNSIGNED,
	a_oil INT UNSIGNED,
	a_exp INT UNSIGNED,
	a_gold INT UNSIGNED,
	a_morale INT UNSIGNED,
	a_rank INT UNSIGNED,
	a_civilains INT UNSIGNED,
	a_airforce INT UNSIGNED,
	a_army INT UNSIGNED,
	a_naval INT UNSIGNED,
	a_spies INT UNSIGNED,
	a_newmessage INT UNSIGNED,
	a_totalmessages INT UNSIGNED,
	a_ ,
	a_ 
) BEGIN
	INSERT INTO #db#.User SET
		`role` = a_role,
		`username` = a_username,
		`email` = a_email,
		`password` = a_password,
		`timezone` = a_timezone,
		`active` = a_active,
		`lastturntime` = a_lastturntime,
		`datecreated` = a_datecreated,
		`datebanned` = a_datebanned,
		`reason` = a_reason,
		`nation` = a_nation,
		`commander` = a_commander,
		`clicks` = a_clicks,
		`food` = a_food,
		`steel` = a_steel,
		`oil` = a_oil,
		`exp` = a_exp,
		`gold` = a_gold,
		`morale` = a_morale,
		`rank` = a_rank,
		`civilains` = a_civilains,
		`airforce` = a_airforce,
		`army` = a_army,
		`naval` = a_naval,
		`spies` = a_spies,
		`newmessage` = a_newmessage,
		`totalmessages` = a_totalmessages,
		`` = a_,
		`` = a_;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getUser//
CREATE PROCEDURE IF EXISTS #db#.getUser (
	a_id INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.User WHERE
		User.id = a_id;
END;//

DROP PROCEDURE IF EXISTS #db#.updateUser//
CREATE PROCEDURE IF EXISTS #db#.updateUser (
	a_id INT UNSIGNED,
	a_role INT UNSIGNED,
	a_username VARCHAR(1),
	a_email VARCHAR(100),
	a_password VARCHAR(32),
	a_timezone FLOAT,
	a_active INT UNSIGNED,
	a_lastturntime INT UNSIGNED,
	a_datecreated INT UNSIGNED,
	a_datebanned INT UNSIGNED,
	a_reason VARCHAR(1),
	a_nation INT UNSIGNED,
	a_commander INT UNSIGNED,
	a_clicks INT UNSIGNED,
	a_food INT UNSIGNED,
	a_steel INT UNSIGNED,
	a_oil INT UNSIGNED,
	a_exp INT UNSIGNED,
	a_gold INT UNSIGNED,
	a_morale INT UNSIGNED,
	a_rank INT UNSIGNED,
	a_civilains INT UNSIGNED,
	a_airforce INT UNSIGNED,
	a_army INT UNSIGNED,
	a_naval INT UNSIGNED,
	a_spies INT UNSIGNED,
	a_newmessage INT UNSIGNED,
	a_totalmessages INT UNSIGNED,
	a_ ,
	a_ 
) BEGIN
	UPDATE #db#.User SET
		User.`role` = a_role,
		User.`username` = a_username,
		User.`email` = a_email,
		User.`password` = a_password,
		User.`timezone` = a_timezone,
		User.`active` = a_active,
		User.`lastturntime` = a_lastturntime,
		User.`datecreated` = a_datecreated,
		User.`datebanned` = a_datebanned,
		User.`reason` = a_reason,
		User.`nation` = a_nation,
		User.`commander` = a_commander,
		User.`clicks` = a_clicks,
		User.`food` = a_food,
		User.`steel` = a_steel,
		User.`oil` = a_oil,
		User.`exp` = a_exp,
		User.`gold` = a_gold,
		User.`morale` = a_morale,
		User.`rank` = a_rank,
		User.`civilains` = a_civilains,
		User.`airforce` = a_airforce,
		User.`army` = a_army,
		User.`naval` = a_naval,
		User.`spies` = a_spies,
		User.`newmessage` = a_newmessage,
		User.`totalmessages` = a_totalmessages,
		User.`` = a_,
		User.`` = a_
	WHERE
		User.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteUser//
CREATE PROCEDURE IF EXISTS #db#.deleteUser (
	a_id INT UNSIGNED
) BEGIN
	DELETE FROM #db#.User WHERE
		User.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createUserSignup//
CREATE PROCEDURE IF EXISTS #db#.createUserSignup (
	a_activationkey VARCHAR(1),
	a_username VARCHAR(1),
	a_email VARCHAR(1),
	a_timezone FLOAT,
	a_datecreated INT UNSIGNED,
	a_nation INT UNSIGNED
) BEGIN
	INSERT INTO #db#.UserSignup SET
		`activationkey` = a_activationkey,
		`username` = a_username,
		`email` = a_email,
		`timezone` = a_timezone,
		`datecreated` = a_datecreated,
		`nation` = a_nation;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getUserSignup//
CREATE PROCEDURE IF EXISTS #db#.getUserSignup (
	a_activationkey VARCHAR(1)
) BEGIN
	SELECT * FROM #db#.UserSignup WHERE
		UserSignup.activationkey = a_activationkey;
END;//

DROP PROCEDURE IF EXISTS #db#.updateUserSignup//
CREATE PROCEDURE IF EXISTS #db#.updateUserSignup (
	a_activationkey VARCHAR(1),
	a_username VARCHAR(1),
	a_email VARCHAR(1),
	a_timezone FLOAT,
	a_datecreated INT UNSIGNED,
	a_nation INT UNSIGNED
) BEGIN
	UPDATE #db#.UserSignup SET
		UserSignup.`username` = a_username,
		UserSignup.`email` = a_email,
		UserSignup.`timezone` = a_timezone,
		UserSignup.`datecreated` = a_datecreated,
		UserSignup.`nation` = a_nation
	WHERE
		UserSignup.activationkey = a_activationkey;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteUserSignup//
CREATE PROCEDURE IF EXISTS #db#.deleteUserSignup (
	a_activationkey VARCHAR(1)
) BEGIN
	DELETE FROM #db#.UserSignup WHERE
		UserSignup.activationkey = a_activationkey;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createStats//
CREATE PROCEDURE IF EXISTS #db#.createStats (
	a_aerial INT UNSIGNED,
	a_terrestrial INT UNSIGNED,
	a_marine INT UNSIGNED,
	a_covert INT UNSIGNED,
	a_retaliation INT UNSIGNED
) BEGIN
	INSERT INTO #db#.Stats SET
		`aerial` = a_aerial,
		`terrestrial` = a_terrestrial,
		`marine` = a_marine,
		`covert` = a_covert,
		`retaliation` = a_retaliation;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getStats//
CREATE PROCEDURE IF EXISTS #db#.getStats (
	a_id INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.Stats WHERE
		Stats.id = a_id;
END;//

DROP PROCEDURE IF EXISTS #db#.updateStats//
CREATE PROCEDURE IF EXISTS #db#.updateStats (
	a_id INT UNSIGNED,
	a_aerial INT UNSIGNED,
	a_terrestrial INT UNSIGNED,
	a_marine INT UNSIGNED,
	a_covert INT UNSIGNED,
	a_retaliation INT UNSIGNED
) BEGIN
	UPDATE #db#.Stats SET
		Stats.`aerial` = a_aerial,
		Stats.`terrestrial` = a_terrestrial,
		Stats.`marine` = a_marine,
		Stats.`covert` = a_covert,
		Stats.`retaliation` = a_retaliation
	WHERE
		Stats.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteStats//
CREATE PROCEDURE IF EXISTS #db#.deleteStats (
	a_id INT UNSIGNED
) BEGIN
	DELETE FROM #db#.Stats WHERE
		Stats.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createRanks//
CREATE PROCEDURE IF EXISTS #db#.createRanks (
	a_aerial INT UNSIGNED,
	a_terrestrial INT UNSIGNED,
	a_marine INT UNSIGNED,
	a_covert INT UNSIGNED,
	a_retaliation INT UNSIGNED
) BEGIN
	INSERT INTO #db#.Ranks SET
		`aerial` = a_aerial,
		`terrestrial` = a_terrestrial,
		`marine` = a_marine,
		`covert` = a_covert,
		`retaliation` = a_retaliation;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getRanks//
CREATE PROCEDURE IF EXISTS #db#.getRanks (
	a_id INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.Ranks WHERE
		Ranks.id = a_id;
END;//

DROP PROCEDURE IF EXISTS #db#.updateRanks//
CREATE PROCEDURE IF EXISTS #db#.updateRanks (
	a_id INT UNSIGNED,
	a_aerial INT UNSIGNED,
	a_terrestrial INT UNSIGNED,
	a_marine INT UNSIGNED,
	a_covert INT UNSIGNED,
	a_retaliation INT UNSIGNED
) BEGIN
	UPDATE #db#.Ranks SET
		Ranks.`aerial` = a_aerial,
		Ranks.`terrestrial` = a_terrestrial,
		Ranks.`marine` = a_marine,
		Ranks.`covert` = a_covert,
		Ranks.`retaliation` = a_retaliation
	WHERE
		Ranks.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteRanks//
CREATE PROCEDURE IF EXISTS #db#.deleteRanks (
	a_id INT UNSIGNED
) BEGIN
	DELETE FROM #db#.Ranks WHERE
		Ranks.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createInfrastructure//
CREATE PROCEDURE IF EXISTS #db#.createInfrastructure (
	a_houses INT UNSIGNED,
	a_hospitals INT UNSIGNED,
	a_laboratories INT UNSIGNED,
	a_farms INT UNSIGNED,
	a_mines INT UNSIGNED,
	a_barracks INT UNSIGNED,
	a_airfields INT UNSIGNED
) BEGIN
	INSERT INTO #db#.Infrastructure SET
		`houses` = a_houses,
		`hospitals` = a_hospitals,
		`laboratories` = a_laboratories,
		`farms` = a_farms,
		`mines` = a_mines,
		`barracks` = a_barracks,
		`airfields` = a_airfields;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getInfrastructure//
CREATE PROCEDURE IF EXISTS #db#.getInfrastructure (
	a_id INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.Infrastructure WHERE
		Infrastructure.id = a_id;
END;//

DROP PROCEDURE IF EXISTS #db#.updateInfrastructure//
CREATE PROCEDURE IF EXISTS #db#.updateInfrastructure (
	a_id INT UNSIGNED,
	a_houses INT UNSIGNED,
	a_hospitals INT UNSIGNED,
	a_laboratories INT UNSIGNED,
	a_farms INT UNSIGNED,
	a_mines INT UNSIGNED,
	a_barracks INT UNSIGNED,
	a_airfields INT UNSIGNED
) BEGIN
	UPDATE #db#.Infrastructure SET
		Infrastructure.`houses` = a_houses,
		Infrastructure.`hospitals` = a_hospitals,
		Infrastructure.`laboratories` = a_laboratories,
		Infrastructure.`farms` = a_farms,
		Infrastructure.`mines` = a_mines,
		Infrastructure.`barracks` = a_barracks,
		Infrastructure.`airfields` = a_airfields
	WHERE
		Infrastructure.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteInfrastructure//
CREATE PROCEDURE IF EXISTS #db#.deleteInfrastructure (
	a_id INT UNSIGNED
) BEGIN
	DELETE FROM #db#.Infrastructure WHERE
		Infrastructure.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createDivisionArtillery//
CREATE PROCEDURE IF EXISTS #db#.createDivisionArtillery (
	a_userid INT UNSIGNED,
	a_divisionid INT UNSIGNED,
	a_what INT UNSIGNED,
	a_count INT UNSIGNED,
	a_damage INT UNSIGNED,
	a_strength INT UNSIGNED
) BEGIN
	INSERT INTO #db#.DivisionArtillery SET
		`userid` = a_userid,
		`divisionid` = a_divisionid,
		`what` = a_what,
		`count` = a_count,
		`damage` = a_damage,
		`strength` = a_strength;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getDivisionArtillery//
CREATE PROCEDURE IF EXISTS #db#.getDivisionArtillery (
	a_userid INT UNSIGNED,
	a_divisionid INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.DivisionArtillery WHERE
		DivisionArtillery.userid = a_userid AND
		DivisionArtillery.divisionid = a_divisionid;
END;//

DROP PROCEDURE IF EXISTS #db#.updateDivisionArtillery//
CREATE PROCEDURE IF EXISTS #db#.updateDivisionArtillery (
	a_userid INT UNSIGNED,
	a_divisionid INT UNSIGNED,
	a_what INT UNSIGNED,
	a_count INT UNSIGNED,
	a_damage INT UNSIGNED,
	a_strength INT UNSIGNED
) BEGIN
	UPDATE #db#.DivisionArtillery SET
		DivisionArtillery.`what` = a_what,
		DivisionArtillery.`count` = a_count,
		DivisionArtillery.`damage` = a_damage,
		DivisionArtillery.`strength` = a_strength
	WHERE
		DivisionArtillery.userid = a_userid AND
		DivisionArtillery.divisionid = a_divisionid;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteDivisionArtillery//
CREATE PROCEDURE IF EXISTS #db#.deleteDivisionArtillery (
	a_userid INT UNSIGNED,
	a_divisionid INT UNSIGNED
) BEGIN
	DELETE FROM #db#.DivisionArtillery WHERE
		DivisionArtillery.userid = a_userid AND
		DivisionArtillery.divisionid = a_divisionid;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createDivision//
CREATE PROCEDURE IF EXISTS #db#.createDivision (
	a_userid INT UNSIGNED,
	a_active INT UNSIGNED,
	a_name 
) BEGIN
	INSERT INTO #db#.Division SET
		`userid` = a_userid,
		`active` = a_active,
		`name` = a_name;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getDivision//
CREATE PROCEDURE IF EXISTS #db#.getDivision (
	a_id INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.Division WHERE
		Division.id = a_id;
END;//

DROP PROCEDURE IF EXISTS #db#.updateDivision//
CREATE PROCEDURE IF EXISTS #db#.updateDivision (
	a_id INT UNSIGNED,
	a_userid INT UNSIGNED,
	a_active INT UNSIGNED,
	a_name 
) BEGIN
	UPDATE #db#.Division SET
		Division.`userid` = a_userid,
		Division.`active` = a_active,
		Division.`name` = a_name
	WHERE
		Division.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteDivision//
CREATE PROCEDURE IF EXISTS #db#.deleteDivision (
	a_id INT UNSIGNED
) BEGIN
	DELETE FROM #db#.Division WHERE
		Division.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.createBuyQueue//
CREATE PROCEDURE IF EXISTS #db#.createBuyQueue (
	a_userid INT UNSIGNED,
	a_what INT UNSIGNED,
	a_ticks INT UNSIGNED,
	a_quantity INT UNSIGNED,
	a_civilians INT UNSIGNED
) BEGIN
	INSERT INTO #db#.BuyQueue SET
		`userid` = a_userid,
		`what` = a_what,
		`ticks` = a_ticks,
		`quantity` = a_quantity,
		`civilians` = a_civilians;
	SELECT last_insert_id() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.getBuyQueue//
CREATE PROCEDURE IF EXISTS #db#.getBuyQueue (
	a_id INT UNSIGNED
) BEGIN
	SELECT * FROM #db#.BuyQueue WHERE
		BuyQueue.id = a_id;
END;//

DROP PROCEDURE IF EXISTS #db#.updateBuyQueue//
CREATE PROCEDURE IF EXISTS #db#.updateBuyQueue (
	a_id INT UNSIGNED,
	a_userid INT UNSIGNED,
	a_what INT UNSIGNED,
	a_ticks INT UNSIGNED,
	a_quantity INT UNSIGNED,
	a_civilians INT UNSIGNED
) BEGIN
	UPDATE #db#.BuyQueue SET
		BuyQueue.`userid` = a_userid,
		BuyQueue.`what` = a_what,
		BuyQueue.`ticks` = a_ticks,
		BuyQueue.`quantity` = a_quantity,
		BuyQueue.`civilians` = a_civilians
	WHERE
		BuyQueue.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

DROP PROCEDURE IF EXISTS #db#.deleteBuyQueue//
CREATE PROCEDURE IF EXISTS #db#.deleteBuyQueue (
	a_id INT UNSIGNED
) BEGIN
	DELETE FROM #db#.BuyQueue WHERE
		BuyQueue.id = a_id;
	SELECT ROW_COUNT() as retCode;
END;//

