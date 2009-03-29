<?

function
debug($message) {
	error_log($message . "\n", 3, ERROR_LOG_PATH);
}

function
check($assertion) {
	if (!$assertion) {
		debug('Check failed ' . print_r($assertion, true));
	}
	return $assertion;
}

// game error, recoverable
class GError extends Exception {
	public function // for aesthetic reasons..
	getError() { return $this->getMessage(); }
}
// game message
class GMessage extends Exception {}


// easy redirect..
class Redirect extends Exception {
	public function
	__construct($url) {
		header("Location: $url");
		exit;
	}
}

class DBException extends Exception {
	private $errornum;
	private $msg;

	public function
	__construct($link) {
		$this->errornum = $link->errno;
		$this->msg = $link->error;
		parent::__construct(
			"Database Exception ({$this->errornum}): {$this->msg}",
			$this->errornum
		);
	}

	public function
	getErrorNumber() {
		return $this->errornum;
	}

	public function
	getErrorMessage() {
		return $this->msg;
	}
}

class DBConnectionError extends Exception {
	private $errornum;
	private $msg;

	public function
	__construct($num, $emsg) {
		$this->errornum = $num;
		$this->msg = $emsg;
		parent::__construct(
			"Database Connection Error ({$this->errornum}): {$this->msg}",
			$this->errornum
		);
	}

	public function
	getErrorNumber() {
		return $this->errornum;
	}

	public function
	getErrorMessage() {
		return $this->msg;
	}
}
?>
