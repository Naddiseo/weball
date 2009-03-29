<?
require_once('config/Config.php');

class MCDummy {
	public static function
	getInstance() {}

	public function
	delete($token) { return false; }

	public function
	get($token) { return false; }

	public function
	set($token, $val, $timeOut = 30) { return false; }
}

// Singleton pattern
class Cache extends Memcache {
	private static $instance;

	// prevent external instances
	private function
	__construct() {}

	// stop cloning
	private function
	__clone() {}

	public static function
	getInstance() {
		global $MEM_CACHE;

		if (!self::$instance instanceof self) {
			self::$instance = new self;
			foreach ($MEM_CACHE as $host => $port) {
				self::$instance->addServer($host, $port);
			}
		}

		return self::$instance;
	}

	public function
	delete($token) {
		return self::$instance->delete(md5($token));
	}

	public function
	get($token) {
		if (MC_ENABLE) {
			return self::$instance->get(md5($token));
		}
		return false;
	}

	public function
	set($token, $val, $timeOut = 30) {
		return self::$instance->set(md5($token), $val, 0, $timeOut);
	}

	public function
	dbg() {
		memcache_debug(true);
	}

	public function
	getStats() {
		return self::$instance->getExtendedStats();
	}
}

// quick access
function Cache() {
	if (MC_ENABLE) {
		return Cache::getInstance();
	}

	return new MCDummy();
}

?>
