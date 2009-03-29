<?
require_once('config/Config.php');

class Session {
	public function
	__construct(
		$level = SESSION_PUBLIC,
		$url = false,
		$page = SITE_URL
	) {
		session_start();

		if (!$this->validate($level)) {
			$redirect = $page;
			if ($url) $redirect .= '?url=' . $url;
			header("Location: $redirect");
			exit;
		}
	}

	public function
	validate($level) {
		switch ($level) {
			case SESSION_PUBLIC: return true;
			case SESSION_USER: return $this->loggedIn();
		}
	}

	public function
	loggedIn() {
		return $_SESSION['userId'] > 0;
	}

	public function
	logout() {
		session_destroy();
		$_SESSION['userId'] = 0;
	}

	public static
	function user() {
		return $_SESSION['userId'];
	}
}

?>
