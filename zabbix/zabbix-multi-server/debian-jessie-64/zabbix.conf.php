<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'POSTGRESQL';
$DB['SERVER']   = 'srvpgsql01';
$DB['PORT']     = '5432';
$DB['DATABASE'] = 'zabbixdb';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = '123456789';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'srvzbx01';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
