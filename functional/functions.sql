DROP PROCEDURE #db#.User_login//
CREATE PROCEDURE #db#.User_login (
END;//

DROP PROCEDURE #db#.User_usernameEmailExists//
CREATE PROCEDURE #db#.User_usernameEmailExists (
	DECLARE uCount ;
	DECLARE uCount2 ;
	select count(*) into uCount from #db#.User u where u.username like username or u.email like email;
	select count(*) into uCount2 from #db#.UserSignup u where u.username like username or u.email like email;
	select (uCount + uCount2) as retCode;
END;//

