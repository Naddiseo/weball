<?
class Email{
	private $headers = array(
		'From' => "\"WW2Admin\" <admin@ww2game.net>",
		'Reply-To' => "\"WW2Admin\" <admin@ww2game.net>",
		'MIME-Version' => '1.1',
		"Return-Path" => "<admin@ww2game.net>",
		"Organization" => "WW2game"
	);

	private $boundary = '';
	private $message = '';
	private $to = '';
	private $subject = '';


	function __construct($to, $subject, $html, $plain){
		$this->headers["X-Mailer"] = "PHP/".phpversion();
		$this->GenerateBoundary();
		$this->addheader('Content-Type',  "Multipart/Alternative; boundary=\"{$this->boundary}\"");
		$this->to = $to;
		$this->addTEXTPart($plain);
		$this->addHTMLPart($html);
		$this->message .= '--' . $this->boundary . '--';
		$this->subject = $subject;
	}

	function addHTMLPart($msg){
		$this->message .= '--' . $this->boundary."\r\nContent-Type: text/html; charset=UTF-8\r\n\r\n".$msg."\r\n";
	}

	function addTEXTPart($msg){
		$this->message .= '--' . $this->boundary."\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\n".$msg."\r\n";
	}

	function _buildheaders(){

		$h = '';
		foreach ($this->headers as $k => $v){
			$h .= "$k: $v\r\n";
		}
		return $h;

	}

	function addheader($name, $value){
		$this->headers[$name] = $value;
	}

	function GenerateBoundary(){
		$this->boundary = "==" . time() . chr(rand(ord('a'), ord('z'))) . chr(rand(ord('a'), ord('z'))) . chr(rand(ord('A'), ord('Z')));

	}

	function send(){
		ini_set('sendmail_from', 'admin@ww2game.net');
		$headers = $this->_buildheaders();
		return mail($this->to, $this->subject, $this->message, $headers);

	}



 }?>
