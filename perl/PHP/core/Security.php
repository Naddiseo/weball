<?
require_once('config/Config.php');

class Security {
	//"timestamp" "ip" "user agent"
	// "request uri" "referrer uri"
	// "method" "ww2 action" "ww2id" "vars in key=var&key=var"
	public static function
	doLog($uId, $action, $vars) {

		$fp = fopen(LOGDIR . '/logfile', 'a+');
		if ($fp) {
			$line = Security::encodeline(
				time(),
				$_SERVER['REMOTE_ADDR'],
				$_SERVER['HTTP_USER_AGENT'],
				$_SERVER['REQUEST_URI'],
				$_SERVER['HTTP_REFERER'],
				$_SERVER['REQUEST_METHOD'],
				$action,
				$uId,
				Security::formatVars($vars)
			);
			fwrite($fp, $line);
			fclose($fp);
		}
	}

	private static function
	encodeline() {
		$ret = '';
		$argc = func_num_args();
		$argv = func_get_args();
		for ($i = 0; $i < $argc; $i++) {
			$ret .= '"' . addslashes($argv[$i]) . '" ';
		}
		return $ret . "\n";

	}

	private static function
	formatVars($vars) {
		$t = array();
		foreach ($vars as $key => $val) {
			$t[] = $key . '=' . urlencode($val);
		}

		return implode('&', $t);

	}

}
?>
