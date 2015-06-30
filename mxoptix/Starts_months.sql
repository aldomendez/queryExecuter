SELECT CASE WHEN (item LIKE '1626%' OR item LIKE '1656%')
  AND (SubStr(item,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(item,-2)='77')
THEN '80km CWDM'
WHEN (item LIKE '1626%' OR item LIKE '1656%' OR item LIKE 'B-1626%')
  AND (Length(item)<8 OR (Length(item)<9 AND item LIKE 'B%'))
THEN '80km TDM'
WHEN (item LIKE '1626%' OR item LIKE '1656%' OR item LIKE 'B-1626%')
  THEN '80km DWDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE '1622%' OR item LIKE 'B-1625%')
  AND (SubStr(item,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(item,-2)='77')
THEN '40km CWDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE 'B-1625%' OR item LIKE '1622%')
  AND (Length(item)<8 OR (Length(item)<9 AND item LIKE 'B%'))
THEN '40km TDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE 'B-1625%' OR item LIKE '1622%')
  THEN '40km DWDM'
ELSE 'Other'
END TYPE, opn_code, opn_description, job, qty_in_queue+qty_in+qty_running starts,
qty_out outs, qty_running in_process, qty_in_queue in_queue,
total_reject scrap, job_start_date, queue_Start_date, item, process_lot,
CASE WHEN
To_Date(To_Char(queue_start_date,'hh24:mi:ss'),'hh24:mi:ss') >= To_Date('00:00:00','hh24:mi:ss') AND
To_Date(To_Char(queue_start_date,'hh24:mi:ss'),'hh24:mi:ss') <= To_Date('6:29:59','hh24:mi:ss')
  THEN
  To_Char(queue_start_date-1,'Mon-dd')
  ELSE
  To_Char(queue_start_date,'Mon-dd')
  END WORK_DAY,
  CASE WHEN
  To_Date(To_Char(queue_start_date,'hh24:mi:ss'),'hh24:mi:ss') >= To_Date('6:30:00','hh24:mi:ss') AND
  To_Date(To_Char(queue_start_date,'hh24:mi:ss'),'hh24:mi:ss') < To_Date('15:00:00','hh24:mi:ss')
  THEN
  '1st Shift'
  ELSE (
    CASE WHEN
      To_Date(To_Char(queue_start_date,'hh24:mi:ss'),'hh24:mi:ss') >= To_Date('15:00:00','hh24:mi:ss') AND
      To_Date(To_Char(queue_start_date,'hh24:mi:ss'),'hh24:mi:ss') < To_Date('23:00:00','hh24:mi:ss')
    THEN
    '2nd Shift'
    ELSE
    '3rd Shift'
    END)
  END SHIFT
FROM apps.XXBI_CYP_WIP_JOB_BUILD_V@osfm
WHERE organization_code='F07'
AND department_code='ENG10GTO'
--AND (job LIKE '1431%' OR job LIKE '1430%' OR job LIKE '1429%' OR job LIKE '1428%' OR job LIKE '1427%')
--AND (opn_code='NT19' OR opn_code='NT37')
AND queue_start_date between TRUNC(SYSDATE - 7) + 4.5/24
	AND TRUNC(SYSDATE-0) + 4.5/24
--AND job_start_date > SYSDATE-35
--AND job_start_date < SYSDATE-8
--AND job_start_date between TRUNC(SYSDATE - 55) + 4.5/24
--	AND TRUNC(SYSDATE-0) + 4.5/24
--AND (item LIKE '162%' or item LIKE '165%' or item LIKE 'B-162%' OR item LIKE 'XMD%')
/*GROUP BY CASE WHEN (item LIKE '1626%' OR item LIKE '1656%')
  AND (SubStr(item,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(item,-2)='77')
THEN '80km CWDM'
WHEN (item LIKE '1626%' OR item LIKE '1656%' OR item LIKE 'B-1626%')
  AND (Length(item)<8 OR (Length(item)<9 AND item LIKE 'B%'))
THEN '80km TDM'
WHEN (item LIKE '1626%' OR item LIKE '1656%' OR item LIKE 'B-1626%')
  THEN '80km DWDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE '1622%' OR item LIKE 'B-1625%')
  AND (SubStr(item,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(item,-2)='77')
THEN '40km CWDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE 'B-1625%' OR item LIKE '1622%')
  AND (Length(item)<8 OR (Length(item)<9 AND item LIKE 'B%'))
THEN '40km TDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE 'B-1625%' OR item LIKE '1622%')
  THEN '40km DWDM'
ELSE 'Other'
END, opn_code, opn_description */
ORDER BY CASE WHEN (item LIKE '1626%' OR item LIKE '1656%')
  AND (SubStr(item,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(item,-2)='77')
THEN '80km CWDM'
WHEN (item LIKE '1626%' OR item LIKE '1656%' OR item LIKE 'B-1626%')
  AND (Length(item)<8 OR (Length(item)<9 AND item LIKE 'B%'))
THEN '80km TDM'
WHEN (item LIKE '1626%' OR item LIKE '1656%' OR item LIKE 'B-1626%')
  THEN '80km DWDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE '1622%' OR item LIKE 'B-1625%')
  AND (SubStr(item,-3) IN('147','149','151','153','155','157','159','161') OR SubStr(item,-2)='77')
THEN '40km CWDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE 'B-1625%' OR item LIKE '1622%')
  AND (Length(item)<8 OR (Length(item)<9 AND item LIKE 'B%'))
THEN '40km TDM'
WHEN (item LIKE '1625%' OR item LIKE '1655%' OR item LIKE 'B-1625%' OR item LIKE '1622%')
  THEN '40km DWDM'
ELSE 'Other'
END, CASE WHEN opn_code ='NT39' THEN '1'
  WHEN opn_code ='NT99' THEN '1.1'
  WHEN opn_code ='NT19' THEN '2'
  WHEN opn_code ='NT20' THEN '3'
  WHEN opn_code ='NT21' THEN '4'
  WHEN opn_code ='NT22' THEN '5'
  WHEN opn_code ='NT23' THEN '6'
  WHEN opn_code ='NT24' THEN '7'
  WHEN opn_code ='NT25' THEN '8'
  WHEN opn_code ='NT26' THEN '9'
  WHEN opn_code ='NT27' THEN '9.10'
  WHEN opn_code ='NT30' THEN '9.11'
  WHEN opn_code ='NT31' THEN '9.12'
  WHEN opn_code ='NT32' THEN '9.13'
  WHEN opn_code ='NT33' THEN '9.14'
  WHEN opn_code ='NT34' THEN '9.15'
  WHEN opn_code ='NT35' THEN '9.16'
  WHEN opn_code ='NT36' THEN '9.17'
  WHEN opn_code ='NT37' THEN '9.18'
  ELSE opn_code END ASC 