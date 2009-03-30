<?
require_once('config/Config.php');

class DbHandler {
	private $link;
	private $result;

	private $canDie = true;

	public static $debug = false;

	public function
	__construct(DbHandler $dbc = NULL) {
		if (DEBUG) {
			DbHandler::$debug = true;
		}
		if ($dbc) {
			$this->link = $dbc->link;
// 			// to stop double freeing
			$this->canDie = false;
		} else {
			$this->link = new mysqli('localhost', DB_USER, DB_PASS, DB_DB);
			if (mysqli_connect_errno()) {
				throw new DBConnectionError(
					mysqli_connect_errno(),
					mysqli_connect_error()
				);
			}
		}
		return $this->link;
	}

	public function
	__destruct() {
		if($this->canDie and $this->link){
			$this->link->close();
		}
	}

	public function
	autocommit($val = true) {
		$this->link->autocommit($val);
	}

	public function
	close() {
		$this->__destruct();
	}

	public function
	commit() {
		$this->link->commit();
	}

	public function
	encode($str) {
		return $this->link->real_escape_string($str);
	}

	public function
	fetchobj($class = null) {
		return ($class) ?
			 $this->result->fetch_object($class) :
			 $this->result->fetch_object();
	}

	private function
	getRow($class = null) {
		$ret = $this->fetchobj($class = null);
		while ($this->fetchobj()) {
			continue;
		}
		return $ret;
	}

	private function
	getRows($class = null) {
		$ret = array();
		while ($row = $this->fetchobj($class)) {
			$ret[] = $row;
		}

		return $ret;
	}


	public function
	multiquery($str) {
		try {
			global $MSQL_NUM_QUERIES;
			$MSQL_NUM_QUERIES++;
			//XXX remove me XXX
			if (DbHandler::$debug) {
				debug($str);
			}
			$ret = $this->link->multi_query($str);
			if (mysqli_error($this->link)) {
				throw new DBException($this->link);
			}
			return $ret;
		} catch (Exception $e) {
			throw $e;
		} catch (mysqli_sql_exception $e) {
			die($e->getMessage());
		}
	}


	public function
	nextresult() {
		if ($this->result) {
			$this->result->close();
		}
		if ($this->link->more_results()) {
			return $this->link->next_result();
		}
	}

	public function
	resultGetRow($class = null) {
		$ret = null;
		if ($this->storeresult()) {
			$ret = $this->getRow($class);
		}

		//eat the rest of the results
		while ($this->nextresult()) {
			$this->resultGetRows();
		}

		return $ret;
	}
	public function
	resultGetRows($class = null) {
		$ret = array();
		if ($this->storeresult()) {
			$ret = $this->getRows($class);
		}

		//eat the rest of the results
		while ($this->nextresult()) {
			$this->resultGetRows();
		}

		return $ret;
	}

	public function
	resultGetRowsMulti() {
		$ret = array();

		do {
			if ($this->storeresult()) {
				$ret[] = $this->getRows();
			}

		} while ($this->nextresult());


		return $ret;
	}


	public function
	rollback() {
		$this->link->rollback();
	}

	public function
	storeresult() {
		return ($this->result = $this->link->store_result());
	}

}

class Db {
	public static $dbc = null;
	private static function
	argList(&$db, $argc, array $argv, $offset = 1) {
		$arglist = array();
		for ($i = $offset; $i < $argc; $i++) {
			$arglist[] = '"' . $db->encode($argv[$i]) . '"';
		}

		return implode(', ', $arglist);
	}

	//call a stored proc, and don't expect anything back
	public static function
	callSP($sp) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = func_num_args();
			$argv = func_get_args();
			$arglist = Db::argList($db, $argc, $argv);

			$db->multiquery("call {$sp}($arglist);");

			//eat the results because this function does return anything
			$ret = $db->resultGetRowsMulti();
			if ($ret[0][0]->retCode) {
				return $ret[0][0]->retCode;
			}

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	//call a stored proc, and don't expect anything back
	public static function
	callSPArgs($sp, array $argv) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = count($argv);
			$arglist = Db::argList($db, $argc, $argv, 0);

			$db->multiquery("call {$sp}($arglist);");

			//eat the results because this function does return anything
			$ret = $db->resultGetRowsMulti();

			if ($ret[0][0]->retCode) {
				return $ret[0][0]->retCode;

			} else if ($ret[0]->retCode) {
				return $ret[0]->retCode;

			} else if ($ret->retCode) {
				return $ret->retCode;
			}
			return null;

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	// returns one row of objects
	public static function
	getClass($fn, $class = null) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = func_num_args();
			$argv = func_get_args();
			$arglist = Db::argList($db, $argc, $argv, 2);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRow($class);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	// returns one row of objects
	public static function
	getClassArgs($fn, $class = null, array $argv) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = count($argv);
			$arglist = Db::argList($db, $argc, $argv, 0);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRow($class);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	//returns one result set of classes
	public static function
	getClasses($fn, $class = null) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = func_num_args();
			$argv = func_get_args();
			$arglist = Db::argList($db, $argc, $argv, 2);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRows($class);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	//returns one result set of classes
	public static function
	getClassesArgs($fn, $class = null, array $argv) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = count($argv);
			$arglist = Db::argList($db, $argc, $argv, 0);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRows($class);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	// returns one row of objects
	public static function
	getRow($fn) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = func_num_args();
			$argv = func_get_args();
			$arglist = Db::argList($db, $argc, $argv);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRow(null);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	// returns one row of objects
	public static function
	getRowArgs($fn, array $argv) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = count($argv);
			$arglist = Db::argList($db, $argc, $argv, 0);
			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRow(null);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	//returns one result set of objects
	public static function
	getRows($fn) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = func_num_args();
			$argv = func_get_args();
			$arglist = Db::argList($db, $argc, $argv);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRows(null);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	//returns one result set of objects
	public static function
	getRowsArgs($fn, array $argv) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = count($argv);
			$arglist = Db::argList($db, $argc, $argv, 0);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRows(null);

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	//returns and array of result sets as objects
	public static function
	getRowsMulti($fn) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = func_num_args();
			$argv = func_get_args();

			$arglist = Db::argList($db, $argc, $argv);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRowsMulti();

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

	public static function
	getRowsMultiArgs($fn, array $argv) {
		try {
			$db = new DbHandler(Db::$dbc);
			$argc = count($argv);
			$arglist = Db::argList($db, $argc, $argv, 0);

			$db->multiquery("call {$fn}($arglist);");

			return $db->resultGetRowsMulti();

		} catch (DBException $e) {
			throw $e;
		} catch (DBConnectionError $e) {
			throw $e;
		} catch (Exception $e) {
			throw $e;
		}
	}

}
?>
