SELECT b.cpw_lot, device, facility, top, iop, vppk, vxovr, vea, wavelength, lfiber, ext_ratio, disp_penalty, mask_margin, 
smsr, rise_time, fall_time, overshoot, jitter, crossing, iss, rth, ipd, iphoto, 
device_fm, test_runs, state, product, first_fail_mode, test_dt,
CASE WHEN (a.product LIKE '%1626%')
  AND (SubStr(a.product,-3) IN('147','149','151','153','155','157','159') OR SubStr(a.product,-2)='77')
THEN '70km CWDM'
WHEN (a.product LIKE '%1626%' OR a.product LIKE '%1656%')
  AND SubStr(a.product,-3) IN('161')
THEN '70km CWDM 161'
WHEN (a.product LIKE '%1626%' OR a.product LIKE '%1656%')
  AND (Length(a.product)<8 OR (Length(a.product)<9 AND a.product LIKE 'B%'))
THEN '80km TDM'
WHEN (a.product LIKE '%1626%' OR a.product LIKE '%1656%')
  THEN '80km DWDM'
WHEN (a.product LIKE '%1625%' OR a.product LIKE '%1622%')
  AND (SubStr(a.product,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(a.product,-2)='77')
THEN '40km CWDM'
WHEN (a.product LIKE '%1625%' OR a.product LIKE '%1655%')
  AND (Length(a.product)<8 OR (Length(a.product)<9 AND a.product LIKE 'B%'))
THEN '40km TDM'
WHEN (a.product LIKE '%1625%' OR a.product LIKE '%1655%')
  THEN '40km DWDM'
ELSE 'Other'
END pkg_code
FROM dare_pkg.eml10gb_prod@prodmx a, ilm.bond@prodmx b
WHERE device IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm 
WHERE department_code='ENG10GTO'

) 
--a.test_dt > SYSDATE-8
AND a.state='C'
AND a.device = b.PACKAGE
ORDER BY device, test_runs 