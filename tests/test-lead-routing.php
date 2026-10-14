<?php
// Execute the real routing functions with local mail stubs; no network or email.
$source = file_get_contents(__DIR__ . '/../templates/template1/template.htm');
$start = strpos($source, 'function zs_has_valid_phone(');
$end = strpos($source, "\nzs_handle_any_form();");
if ($start === false || $end === false) throw new RuntimeException('Missing routing functions');
eval(substr($source, $start, $end - $start));
function zs_verify_recaptcha(): bool { return true; }
function zs_build_message(array $post): string { return 'test'; }
function zs_json_response(bool $status, string $message = 'ok'): void { throw new RuntimeException($message); }
class Core_Mail {
    public static $sent = 0;
    public static function instance() { return new self(); }
    public function __call($name, $arguments) { if ($name === 'send') self::$sent++; return $this; }
}
$lead = ['_zs_action'=>'lead', 'phone'=>'+7 (999) 123-45-67'];
$cases = [
    ['GET', $lead, 0],
    ['POST', ['filter'=>'1'], 0],
    ['POST', $lead + ['filter'=>'1'], 0],
    ['POST', $lead + ['sorting'=>'1'], 0],
    ['POST', $lead + ['property_6_from'=>'4'], 0],
    ['POST', ['phone'=>'+7 (999) 123-45-67'], 0],
    ['POST', $lead, 1],
];
foreach ($cases as [$method, $post, $expected]) {
    $_SERVER['REQUEST_METHOD']=$method; $_POST=$post; Core_Mail::$sent=0;
    try { zs_handle_any_form(); } catch (RuntimeException $e) {
        if ($expected !== 1 || $e->getMessage() !== 'ok') throw $e;
    }
    if (Core_Mail::$sent !== $expected) throw new RuntimeException('Unexpected mail route');
}
echo "Server routing: catalog controls never send mail; explicit POST lead does.\n";
