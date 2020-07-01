<?php 

$domains = array("hello.co.uk", "hello.com");

foreach ($domains as $d) {
    $country = geoip_country_name_by_name (gethostbyname("$d"));
    list($domain, $ext) = explode('.', $d, 2);
    echo "domain: $domain, extension: $ext, country: $country \n";
}

?>
