<?
require_once('config/Config.php');
require_once('core/Template.php');
require_once('core/Session.php');
class Page {
	protected $params = array();
	protected $T;
	private $isStatic = false;

	public function
	__construct(
		array $filtersG,
		array $filtersP,
		$session = SESSION_PUBLIC,
		$isStatic = false
	) {

		new Session($session);

		$this->params = filter_input_array(INPUT_GET, $filtersG);

		if (!$this->params) {
			$this->params = array();
		}

		$P = filter_input_array(INPUT_POST, $filtersP);
		if ($P) {
			foreach ($P as $k => $v) {
				$this->params[$k] = $v;
			}
		}
		$this->isStatic = $isStatic;
		$this->T = new Template(
			strtolower(get_class($this)) . '.tpl.php',
			$this->isStatic,
			$this->params
		);
		$this->T->pageTitle = $this->pageTitle;

		// to stop repetitive code
		$this->process();
		$this->setT(); //set template stuff
		$this->display();
	}

	public function
	display() {
		echo $this->T->getHTML();
	}

	public function
	process() {}

	public function
	setT() {}


}
?>
