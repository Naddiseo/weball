<?
require_once('config/Config.php');
require_once('core/Db.php');

class BaseClass {

	public function
	__destruct() { }

	public function
	insert() {
		try {
			$argv = func_get_args();
			return Db::callSPArgs('create' . get_class($this), $argv);

		} catch (Exception $e) {
			throw $e;
		}
	}
	
	public function
	get() {
		try {

			$argv =  func_get_args();
			$ret = Db::getRowArgs('get' . get_class($this), $argv);
			if ($ret) {
				foreach ($ret as $k => $v) {
					$this->$k = $v;
				}
			}
		} catch (Exception $e) {
			throw $e;
		}
	}

	public function
	update() {
		try {
			$argv = func_get_args();
			return Db::callSPArgs('update' . get_class($this), $argv);
		} catch (Exception $e) {
			throw $e;
		}
	}

	public function
	delete() {
		try {
			$argv = func_get_args();
			return Db::callSPArgs('delete' . get_class($this), $argv);
		} catch (Exception $e) {
			throw $e;
		}
	}

}
?>
