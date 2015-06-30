SELECT cycles, pcs, fresh_mtl, fresh_rtst, rtst_mtl, retested, pass_prod, 
Round(pass_prod/(fresh_mtl+rtst_mtl),3) current_yield,
Round(fresh_mtl/pcs,3) pcnt_new, 
Round(rtst_mtl/pcs,3) pcnt_retest,
Round(fresh_rtst/fresh_mtl,3) new_retested,
Round(retested/rtst_mtl,3) retested_again,
Round(fpy_new/fresh_mtl,3) fpy_new_mtl,
Round((fpy_new+pass_rtst_new)/fresh_mtl,3) final_new,
Round(fpy_rtst/rtst_mtl,3) fpy_retst,
Round((fpy_rtst+Nvl(pass_rtst_final,0))/rtst_mtl,3) final_retest,
fpy_new, fpy_rtst,
pass_rtst_new, pass_rtst_final
FROM (
SELECT Count(device) cycles, Count(DISTINCT device) pcs 
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE work_day='Jun-25') a, 
(
SELECT Count(DISTINCT device) fresh_mtl
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'N%'
AND work_day='Jun-25') b,
(
SELECT Count(device) fresh_rtst
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'R%'
AND device IN(
  SELECT device FROM dare_pkg.mv_pkg10gfunct_rpt
  WHERE dev_status LIKE 'N%'
  AND work_day='Jun-25')
AND work_day='Jun-25'  ) c,
(
SELECT Count(DISTINCT device) rtst_mtl
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'R%'
AND device NOT IN(
  SELECT device FROM dare_pkg.mv_pkg10gfunct_rpt
  WHERE dev_status LIKE 'N%'
  AND work_day='Jun-25')
AND work_day='Jun-25') d,
(
SELECT Sum(retested) retested FROM (
SELECT device, Count(device), CASE WHEN Count(device)>1 THEN 1 END retested
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'R%'
AND device NOT IN(
  SELECT device FROM dare_pkg.mv_pkg10gfunct_rpt
  WHERE dev_status LIKE 'N%'
  AND work_day='Jun-25')
AND work_day='Jun-25'
GROUP BY device)) e,
(
SELECT Count(DISTINCT device) pass_prod
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE device_fm='PASS'
AND dev_status NOT LIKE 'S%'
AND work_day='Jun-25') f,
(
SELECT Count(DISTINCT device) fpy_new 
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'N%'
AND work_day='Jun-25'
AND device_fm='PASS') g,
(
SELECT Sum(retested) pass_rtst_new FROM (
SELECT device, Count(device), CASE WHEN Count(device)>=1 THEN 1 END retested
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'R%'
AND device_fm='PASS'
AND work_day='Jun-25'
AND device IN(
  SELECT device FROM dare_pkg.mv_pkg10gfunct_rpt
  WHERE dev_status LIKE 'N%'
  AND work_day='Jun-25')
GROUP BY device)) h,
(SELECT Sum(retested) fpy_rtst FROM (
SELECT device, Count(device), CASE WHEN Count(device)=1 THEN 1 END retested
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'R%'
AND device_fm='PASS'
AND work_day='Jun-25'
AND device NOT IN(
  SELECT device FROM dare_pkg.mv_pkg10gfunct_rpt
  WHERE dev_status LIKE 'N%'
  AND work_day='Jun-25')
GROUP BY device)) i,
(
SELECT Sum(retested) pass_rtst_final FROM (
SELECT device, Count(device), CASE WHEN Count(device)>1 THEN 1 END retested
FROM dare_pkg.mv_pkg10gfunct_rpt
WHERE dev_status LIKE 'R%'
AND device_fm='PASS'
AND work_day='Jun-25'
AND device NOT IN(
  SELECT device FROM dare_pkg.mv_pkg10gfunct_rpt
  WHERE dev_status LIKE 'N%'
  AND work_day=to_char(sysdate,'Mon-dd')
GROUP BY device)) j