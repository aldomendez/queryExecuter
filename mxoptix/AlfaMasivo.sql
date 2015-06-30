SELECT a.package, a.pkg_id, a.codigo, a.laser, a.osa_pack_id, a.osa_position, a.operacion, a.fecha, a.resultado,
x.operacion, x.fecha, x.equipo, x.codigo, x.runs, x.resultado, x.modo_de_falla,
b.operacion, b.fecha, b.equipo, b.codigo, b.runs, b.resultado, b.modo_de_falla,
c.operacion, c.fecha, c.equipo, c.codigo, c.runs, c.resultado, c.modo_de_falla,
d.operacion, d.fecha, d.equipo, d.codigo, d.runs, d.resultado, d.modo_de_falla,
e.operacion, e.fecha, e.equipo, e.codigo, e.runs, e.resultado, e.modo_de_falla, e.real_test_mode FROM
(SELECT PACKAGE, cpw_lot pkg_id, laser, osa_pack_id, osa_position,
'ensamble' operacion,test_date fecha, 'kitting' equipo, code codigo, 0 runs,
'PASS' resultado, 'NINGUNO' modo_de_falla
FROM ilm.bond@prodmx WHERE PACKAGE IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm
WHERE department_code='ENG10GTO'
)) a,(SELECT device, 'Screening' operacion, test_dt fecha, facility equipo, product codigo, test_run runs,
device_fm resultado, fail_mode modo_de_falla
FROM pkg.screen_test@mxapps WHERE DEVICE IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm
WHERE department_code='ENG10GTO'
) AND state='C') x, (SELECT device, 'Weld' operacion, test_dt fecha, facility equipo, product codigo,
test_runs runs, device_fm resultado, fail_mode modo_de_falla
FROM dare_pkg.fiber_weld_prod@prodmx
WHERE DEVICE IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm
WHERE department_code='ENG10GTO'
) AND state='C' ) b, (SELECT device, 'LIV1' operacion, test_dt fecha, facility equipo, product codigo,
test_runs runs, device_fm resultado, fail_mode modo_de_falla
FROM dare_pkg.mtemp_qube_prod@prodmx jackie
WHERE DEVICE IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm
WHERE department_code='ENG10GTO'
) AND temp_cycle='PRE'
AND test_runs=(SELECT Max(test_runs) FROM dare_pkg.mtemp_qube_prod@prodmx
  WHERE device=jackie.device
  AND temp_cycle='PRE')) c, (SELECT device, 'LIV2' operacion, test_dt fecha, facility equipo,
product codigo, test_runs runs,device_fm resultado, fail_mode modo_de_falla
FROM dare_pkg.mtemp_qube_prod@prodmx
WHERE DEVICE IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm
WHERE department_code='ENG10GTO'
) AND temp_cycle='POST' AND state='C') d, (SELECT device, 'BER' operacion, test_dt fecha,
facility equipo, product codigo, test_runs runs, device_fm resultado, first_fail_mode modo_de_falla, real_test_mode
FROM dare_pkg.eml10gb_prod@prodmx
WHERE DEVICE IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm
WHERE department_code='ENG10GTO'
) AND state='C' ) e
WHERE a.PACKAGE = b.device (+)
AND a.PACKAGE = c.device (+)
AND a.PACKAGE = d.device (+)
AND a.PACKAGE = e.device (+)
AND a.PACKAGE = x.device (+)
ORDER BY A.CODIGO, A.RESULTADO, X.RESULTADO, B.RESULTADO, C.RESULTADO, D.RESULTADO, E.RESULTADO 