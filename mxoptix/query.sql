SELECT DISTINCT 
a.CARRIER_SERIAL_NUM,
a.CARRIER_SITE,
a.SERIAL_NUM,
a.STATUS,
b.STATUS savedStatus,
b.COMMENTS,
b.component,
b.failmode
           
FROM phase2.carrier_site@mxoptix a 
,apogee.fallas_lr4@mxapps b
WHERE a.serial_num = b.serial_num (+)
AND a.carrier_serial_num = '155772978'       
ORDER BY a.carrier_site