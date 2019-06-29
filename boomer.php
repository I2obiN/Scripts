<?php

    ini_set('memory_limit', '-1');
    ini_set('error_reporting', E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED);

    //goddamn boomers need their tps reports and they need them NOW!

    /*
     * @author thood
     * @description will setup phphmailer to connect to an office 365 account
     *   then pulls all claims for yesterday (2019 only), puts them in a csv file
     *   will then decrypt the claims and put them into another decrypted csv file
     *   finally it will then email myself and the recepients the decrypted csv file.
     */

    //@TODO zip file with encryption and password ideally, remove personal email + pass

    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\PHPMailer;
    require 'vendor/phpmailer/phpmailer/src/PHPMailer.php';
    require 'vendor/phpmailer/phpmailer/src/SMTP.php';

    $dbh = new PDO('mysql:dbname=boomer.db;host=192.168.172.6', 'root', 'root');
    $mail = new PHPMailer(true);
    $mail->isSMTP();
    $mail->Host       = 'smtp.office365.com';
    $mail->SMTPSecure = 'starttls';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'thood@fakecomp.ie';
    $mail->Password   = '';
    $mail->SetFrom('thood@fakecomp.ie', 'Thomas Hood');
    $mail->addAddress('boomer@boomitup.com', 'Boomer, Baby');

    $mail->Subject = 'Daily Boomer Report';
    $mail->Body    = "Hey Boomer, here is the report. Please contact thood@fakecomp.ie for any issues. Have a good day!";
    $mail->AltBody = "Hey Boomer, here is the report. Please contact thood@fakecomp.ie for any issues. Have a good day!";

    echo 'Email Setup done.' . "\r\n";

    $query = $dbh->prepare("
    SELECT
        c.customer_first_name, c.customer_surname, cl.email_address, cl.flight_reservation_number, cl.ip_address, cl.ip_country, cl.ip_city, cl.vi,
	    DATE_FORMAT(FROM_UNIXTIME(timestamp), '%e %b %Y')
        FROM
        boomer.db.claims AS cl
        JOIN
        customer_details AS c
    WHERE
        cl.obfuscated_id = c.claim_id
        and from_unixtime(timestamp) between '2019-".date('m')."-".(date('d')-1)." 00:00:00' and '2019-".date('m')."-".(date('d')-1)." 23:59:59'
     ORDER BY timestamp DESC
     LIMIT 9999999999999999999
    ");

    $query->execute();
    $result = $query->fetchAll(PDO::FETCH_ASSOC);

    if(!empty($result)) {
        echo 'Email Setup done.' . "\r\n";
    }

    $fp = fopen('claims.csv', 'w');
    foreach ($result as $row) {
        fputcsv($fp, $row);
    }

    echo 'Encrypted done.' . "\r\n";

    function decode($value, $iv) {

        $secretKey =  "boomerkeygoeshere";

        return rtrim(
            mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $secretKey, base64_decode($value), MCRYPT_MODE_CBC, base64_decode($iv))
        );
    }

    $csv = fopen("claims.csv", "r");
    while (($data = fgetcsv($csv, 1000, ",")) !== FALSE) {
        $claimsArray[] = $data;
    }
    fclose($csv);
    unset($csv);

    $from = 'Windows-1252';
    $to = 'UTF-8';

    array_shift($claimsArray);

    $from = 'Windows-1252';
    $to = 'UTF-8';

    file_put_contents('decrypted_claims'.(date('d')-1).(date('M')).'.csv','customer_name,customer_surname,email,pnr,ip,country,city,time'."\r\n");

    foreach($claimsArray as $claim) {
        $first_name = decode($claim[0], $claim[7]);
        $surname = decode($claim[1], $claim[7]);
        $email = decode($claim[2], $claim[7]);
        $pnr = $claim[3];
        $ip = $claim[4];
        $country = $claim[5];
        $city = $claim[6];
        $time = $claim[8];

        file_put_contents('decrypted_claims'.(date('d')-1).date('M').'.csv',
            mb_convert_encoding($first_name . ',' . $surname . ',' . $email . ',' . $pnr . ',' . $ip . ',' . $country . ',' . $city . ',' . $time . "\r\n", $to),
            FILE_APPEND);

            unset($first_name);
            unset($surname);
            unset($email);
            unset($pnr);
            unset($ip);
            unset($country);
            unset($city);
            unset($time);
    }

    echo 'Decrypted csv done.' . "\r\n";

    $mail->addAttachment('decrypted_claims'. (date('d')-1).date('M').'.csv');
    $mail->Send();

    echo 'Email sent!' . "\r\n";

    unlink('claims.csv');
    unlink('decrypted_claims'. (date('d')-1).date('M').'.csv');

    die();
