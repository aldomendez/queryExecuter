SELECT b.cpw_lot, a.device, a.facility, a.top, a.iop, a.vppk, a.vxovr, a.vea, a.lfiber, a.ext_ratio, a.disp_penalty, a.mask_margin,
a.disp_penalty_tune, a.device_fm, a.test_runs, a.state, a.product, first_fail_mode, a.test_dt, real_test_mode,c.test_dt,
c.iop, c.top, c.vea, c.vppk, c.vxovr, c.von_eff, c.lfiber, c.wl, c.x_opt, c.er, c.mm, c.dp
FROM dare_pkg.eml10gb_prod@prodmx a, ilm.bond@prodmx b, dare_pkg.eml10gb_prod_tune_history@prodmx c
WHERE a.test_dt > SYSDATE-7
AND a.device IN(
SELECT job FROM apps.xxbi_cyp_wip_job_inv_v@osfm 
WHERE department_code='ENG10GTO'
)
AND a.device_fm <> 'PASS'
AND a.state='C'
AND a.device = b.PACKAGE
AND a.device = c.device
AND b.PACKAGE = c.device
ORDER BY a.device, a.test_runs 