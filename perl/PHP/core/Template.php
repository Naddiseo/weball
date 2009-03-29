<?
require_once('config/Config.php');
require_once('core/Cache.php');
require_once('dbinterface/User.php');
require_once('dbinterface/Ranks.php');

class Template {
	private $isStatic = false;
	private $html = '';
	private $templateFile = '';
	private $err = '';
	private $msg = '';
	public $user = null;
	public $ranks = null;


	public function
	__construct($templateFile, $static = false, array $params = array()) {
		if ($params) {
			foreach ($params as $k => $v) {
				if ($this->$k) {
					throw new Exception(
						'Cannot overwrite template variable ' . $k
					);
				}
				$this->$k = $v;
			}
		}
		$this->templateFile = $templateFile;
		$this->isStatic = $static;
		
		$this->user = new User();

		if ($_SESSION['userId']) {
			$this->user->get($_SESSION['userId']);
			$this->ranks = new Ranks();
			$this->ranks->get($_SESSION['userId']);
		}

	}

	private function
	doHTML() {

		if (
			$this->isStatic and
			($html = Cache()->get(MC_TPL_SALT . $this->templateFile))
		) {
			$this->html = $html;
		} else {
			if (
				$this->templateFile and
				file_exists(TPL_DIR . $this->templateFile)
			) {
				$template = $this;
				ob_start();
				require_once(TPL_DIR . 'template.tpl.php');
				$this->html = ob_get_clean();
			} else {
				throw new Exception('Could not find template');
				$this->html = '';
			}
			if ($this->isStatic) {
				Cache()->set(
					MC_TPL_SALT . $this->templateFile,
					$this->html,
					MC_TPL_TO
				);
			}
		}
	}

	public function
	getHTML() {
		if (!$this->html) {
			$this->doHTML();
		}
		return $this->html;
	}

	public function
	load($tpl, $isStatic = false) {

		if (MC_ENABLE and $isStatic) {

			if ($this->isStatic){
				$html = Cache()->get(MC_TPL_SALT . $tpl);

			} else {
				if (!($html = Cache()->get(MC_TPL_SALT . $tpl))) {
					if ($tpl and file_exists(TPL_DIR . $tpl)) {
						// It's shorter to just use "$this"
						//$template = $this;
						ob_start();
						require_once(TPL_DIR . $tpl);
						$html = ob_get_clean();
						Cache()->set(MC_TPL_SALT . $tpl, $html, MC_TPL_TO);

					} else {
						throw new Exception('Could not load template');
					}
				}
			}
			echo $html;
		} else {
			if ($tpl and file_exists(TPL_DIR . $tpl)) {
				$template = $this;
				ob_start();
				require_once(TPL_DIR . $tpl);
				echo ob_get_clean();
			} else {
				throw new Exception('Could not load template');
			}
		}
	}

	public function
	setMessage($msg) {
		$this->msg = $msg;
	}

	public function
	setError($err) {
		$this->err = $err;
	}
}
?>
