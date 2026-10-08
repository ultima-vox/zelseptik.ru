document.addEventListener('DOMContentLoaded', function() {
    grecaptcha.ready(function () {
	
grecaptcha.execute('6LeGBsogAAAAACm0d6v7meUZwgPegL4J7V2CvsVD', {
	action: 'send'
	}).then(function(token) {
// add token to form
$('.formCallBack').prepend('<input type="hidden" name="g-recaptcha-response" value="' + token + '">');
//$('.formOrder').prepend('<input type="hidden" name="send" value="send">');
});	
});
});