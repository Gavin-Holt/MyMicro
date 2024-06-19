cls REM Clear the screen
@ REM Don't echo this line
echo $string REM Echo a line of text
echo. REM Echo a blank line
echo REM Toggle echoing of commands
@echo REM @ Lines are not echoed
cd /D "%~dp0" REM Change to current batch file location
%ALLUSERSPROFILE%
%APPDATA%
%CommonProgramFiles%
%CommonProgramFiles(x86)%
%CommonProgramW6432%
%COMPUTERNAME%
%ComSpec%
%DriverData%
%HOMEDRIVE%
%HOMEPATH%
%LOCALAPPDATA%
%LOGONSERVER%
%OS%
%PROCESSOR_ARCHITECTURE%
%PROCESSOR_ARCHITEW6432%
%PROCESSOR_IDENTIFIER%
%PROCESSOR_LEVEL%
%PROCESSOR_REVISION%
%ProgramData%
%ProgramFiles%
%ProgramFiles(x86)%
%ProgramW6432%
%PROMPT%
%PSModulePath%
%PUBLIC%
%SESSIONNAME%
%SystemDrive%
%SystemRoot%
%TEMP%
%TMP%
%USERDOMAIN%
%USERDOMAIN_ROAMINGPROFILE%
%USERNAME%
%USERPROFILE%
%windir%
if [var]==[var] () REM If will use %%vars or strings. there is no then and no elseif
) else ( REM Thbis works but there is no elseif command
for REM see \MyPrograms\Help\BAT\for.txt
for %%v in ($set|"$glob") do command REM How the glob is made matters!
for /F %%v in ($set|"$glob") do command REM For each file listed or matching directories
for /D %%v in ("$glob") do command REM For in each directory found
for /R $path  %%v IN ("$glob") do command REM Recursive for in each directory see help for $path=.
for /L %%v in ($start,$step,$end) do command REM Loop in bounds
for /F %%V in ("$string") do command REM
for /F %%V in ('$command') do command REM
for /F %%V in (`$command`) do command REM usebackq option
for /F %%V in ('$string') do command REM usebackq option
for /f "delims=" %%D in (Folders.txt) do REM Use a list of full file paths
for %I in (.) do set repo=%~nxI REM Gets the CD as a name only
set REM see \MyPrograms\Help\BAT\set.txt
set LONGNAME=%LONGNAME:\=/% REM Convert directory separators to unix
set REM string operations
set REM math operations
setlocal EnableDelayedExpansion REM Allows variables to change during run time - reference with !var! instead of %var%
Dism.exe /online /Cleanup-Image /StartComponentCleanup REM Clean winSxS
C:\ProgramData\Microsoft\Windows Defender\Platform\4.18.2108.7-0\MpCmdRun.exe -Scan -ScanType 3 -File .
reg REM see \MyPrograms\Help\BAT\reg.txt
reg ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V link /T REG_Binary /D 00000000 /F REM Disable - shortcut name part 1
reg ADD "HKEY_CLASSES_ROOT\.bat\ShellNew" /V "NullFile" /T REG_SZ REM Add Windows batch to new context menu
reg ADD "HKEY_CURRENT_USER\Control Panel\Accessibility" /V DynamicScrollbars /T REG_DWORD /D 0 /F REM Disable hiding scroll bars
reg ADD "HKEY_CURRENT_USER\Control Panel\Accessibility" /V DynamicScrollbars /T REG_DWORD /D 1 /F REM Enable hiding scroll bars
reg ADD "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /V BorderWidth /D 0 /F REM Thin borders part 1
reg ADD "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /V PaddedBorderWidth /D 0 /F REM Thin borders part 2
reg ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /V ShowDriveLettersFirst /T REG_DWORD /D 1 /F REM Show Drive Letters First in File Explorer
reg ADD "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /T REG_DWORD /D 1 /F REM Disable Bing Searches
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V HubMode /T REG_DWORD /D 1 /F REM Remove Quicklinks Menu
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /V AllowPrelaunch /T REG_DWORD /D 0 /F REM Prevent Edge "Preload"
reg ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /T REG_DWORD /D 1 /F REM Disable Bing Searches
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" /V EnablePeriodicBackup /T REG_DWORD /D 1 /F REM Make registry backups
reg DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /V ShortcutNameTemplate /F REM Disable - shortcut name part 2
reg DELETE "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /F REM Enable Bing Searches
reg DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V DisableSearchBoxSuggestions /F REM Enable Bing Searches
paths.bat  REM List path with parts on separate lines
pathed.exe -h REM Pathed helps add, remove, query or sanitize the path variable
pathed.exe -p  >nul 2>nul REM Prune duplicates and none-existent parts of the path
wc.exe -l REM Count lines
sc stop "wsearch" && sc config "wsearch" start=disabled REM Kill searchIndexer

 | tr.exe -cd "\001-\177" ^ -- Remove unwanted characters
 | tr.exe -d "\012" | tr.exe "\015" "\012\015" ^ -- Change EOL
 | awk.exe "!a[$0]++" ^ -- remove all duplicate lines, not only repeating lines
 | csvq.exe -f "csv" -n -t "%%c/%%e/%%y" "select `date_of_referral` as date, 1 as referrals, 0 as listed, 0 as operations, null as delay, null as outstanding from stdin order by `date` " ^
 | csvq.exe -f "csv" -n "select * from stdin where `delay` < 0 or `delay` >90 order by `date` " ^
 | csvq.exe -f "csv" -n "select * from stdin where `delay` between 0 and 90 order by `date` " ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `date` as ddate, `referrals:sum`, `listed:sum`, `operations:sum`, `delay:median`, `outstanding:sum` from stdin order by `date` asc" ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `date`, `referrals`, `listed`, `operations` , `delayhours` as delay, `outstanding` from stdin" ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `date`, `referrals`, `listed`, `operations` , integer(`delay`) * 24 as delayhours, `outstanding` from stdin" ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `date`, `referrals`, `listed`, `operations`, `delay`, `outstanding` from stdin where `date` is not null and `date` > datetime(1/4/2014) order by `date` " ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `date`, `referrals`, `listed`, `operations`, `delay`, `outstanding` from stdin where `delay` < 0 or `delay` > 90 order by `date` " ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `date`, `referrals`, `listed`, `operations`, `delay`, `outstanding` from stdin where `delay` between 0 and 90 order by `date` " ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `planned surgery date` as date, 0 as referrals, 0 as listed, 1 as operations, date_diff(`planned surgery date`,`referral date`) as delay, 0 as outstanding from stdin order by `date` " ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select `referral date` as date, 1 as referrals, if(date_diff(`planned surgery date`,`referral date`)>=0, 1, 0 ) as listed, 0 as operations, null as delay, null as outstanding from stdin order by `date` " ^
 | csvq.exe -f "csv" -t "%%c/%%e/%%y" "select format('%%04.2d',year(`ddate`))||format('%%02.2d',month(`ddate`))||format('%%02.2d',day(`ddate`)) as date, `referrals:sum`, `listed:sum`, `operations:sum`, `delay:median`, `outstanding:sum` from stdin order by `date` asc" ^
 | csvq.exe -f "csv" -t "%%d/%%m/%%y" "select `procedure_date` as date, 0 as referrals, 0 as listed, 1 as operations, date_diff(`procedure_date`,`booking_date`) as delay, 0 as outstanding from stdin order by `date` " ^
 | csvq.exe -f "csv" -t "%%y%%m%%d" "select `date`, `referrals:sum` as referrals, `listed:sum` as listed, `operations:sum` as operations, `delay:median`, `outstanding:sum`, integer(substring(`date`,1,6))+week_of_year(`date`) as week from stdin order by `week` asc " ^
 | csvq.exe -f "csv" -t "%%y%%m%%d" "select `date`, `referrals:sum` as referrals, `listed:sum` as listed, `operations:sum` as operations, `delay:median`, `outstanding:sum`, week_of_year(`date`) as week from stdin order by `week` asc " ^
 | csvq.exe -f "csv" -t "%y-%m-%d" "select *, if(`time to endpoint` > 0, `time to endpoint`, (date_diff(now(),`date of operation`)/365)) as observedyears from stdin" ^
 | csvq.exe -f "csv" -t "%y-%m-%d" "select *, if(`time to endpoint` > 0, `time to endpoint`, 0 ) as observedyears from stdin" ^
 | csvq.exe -f "csv" "select substring(`date`,1,4) as year, `referrals:sum` as referrals, `listed:sum` as listed, `operations:sum` as operations, `delay:median`, `outstanding:sum` from stdin order by `year` asc" ^
 | csvq.exe -f "csv" "select substring(`date`,1,6)||"15" as month, `referrals:sum` as referrals, `listed:sum` as listed, `operations:sum` as operations, `delay:median`, `outstanding:sum` from stdin order by `month` asc" ^
 | csvtk sort -k 5:nr ^
 | csvtk.exe concat --infile-list - ^
 | csvtk.exe csv2tab  >> _analysis%infile%.txt
 | csvtk.exe cut -f -19 ^
 | csvtk.exe cut -f -local_treatment_function,-local_treatment_function_code,-admitted_nonadmitted ^
 | csvtk.exe cut -f !fields! ^
 | csvtk.exe cut -f "femoraltype","endpoint" ^
 | csvtk.exe cut -f "femoraltype","endpoint","observedyears" ^
 | csvtk.exe cut -f "lead surgeon","endpoint" ^
 | csvtk.exe cut -f "lead surgeon","endpoint","observedyears" ^
 | csvtk.exe cut -f "leadsurgeon","endpoint" ^
 | csvtk.exe cut -f "leadsurgeon","endpoint","observedyears" ^
 | csvtk.exe cut -f "primary consultant","endpoint" ^
 | csvtk.exe cut -f "primary consultant","endpoint","observedyears" ^
 | csvtk.exe cut -f "primary consultant",totalyears ^
 | csvtk.exe cut -f "year","endpoint" ^
 | csvtk.exe cut -f "year","revisionreason" ^
 | csvtk.exe cut -f "yearquarter","endpoint" ^
 | csvtk.exe cut -f "yearquarter","revisionreason" ^
 | csvtk.exe cut -f "years","endpoint" ^
 | csvtk.exe cut -f 1,6 ^
 | csvtk.exe cut -f 1,6,3,4,5,7,8,9 ^
 | csvtk.exe cut -f 1,7,5,8,2,9,10 ^
 | csvtk.exe cut -f 12,13,9 ^
 | csvtk.exe cut -f 2-7 ^
 | csvtk.exe cut -f consultant,mrn,dob,postingdate,invoicevalue,suppliername,ordernotes ^
 | csvtk.exe cut -f consultant,speciality,invoicevalue ^
 | csvtk.exe cut -f femoraltype,totalyears ^
 | csvtk.exe cut -f leadsurgeon,totalyears ^
 | csvtk.exe cut -f suppliername,consultant,invoicevalue ^
 | csvtk.exe filter -f  "delay_from_booking<60" ^
 | csvtk.exe filter -f "delay_from_booking>=0" ^
 | csvtk.exe filter -f "invoicevalue>0" ^
 | csvtk.exe filter -f "tc>0" ^
 | csvtk.exe filter -f "total>50" ^
 | csvtk.exe filter2 -f "$date>20141231" ^
 | csvtk.exe filter2 -f "$date>20221231" ^
 | csvtk.exe filter2 -f "$joint=='hip'" ^
 | csvtk.exe filter2 -f "$joint=='knee'" ^
 | csvtk.exe filter2 -f "len($endpoint)>1" ^
 | csvtk.exe freq -f calc_removal_reason -n -r ^
 | csvtk.exe grep -f "procedure type" -r -p ".*primary" ^
 | csvtk.exe grep -f femoralcatno -r -p 5964 ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consfoot.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consfoot.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "conshand.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "conshand.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "conshipandknee.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "conshipandknee.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consshoulder.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consshoulder.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consspine.txt" ^
 | csvtk.exe grep -n -i -r -f "consultant" -p "consspine.txt" ^
 | csvtk.exe grep -n -i -r -f "speciality" -p "!spec!" ^
 | csvtk.exe grep -n -i -r -f "speciality" -p "registrar" ^
 | csvtk.exe grep -n -i -r -f "speciality" -p "unknown" ^
 | csvtk.exe mutate -f "date of operation" -n op_year_month -p "^(.{7})" ^
 | csvtk.exe mutate -f "date of operation" -n op_year_month -p "^.{3}(.{7})" ^
 | csvtk.exe mutate -f "femoraldetails" -n "knee" -p "^(\w+.\w+.\w+)" ^
 | csvtk.exe mutate -f "femoralmanufacturer" -n "manufacturer" -p "^(\w+)" ^
 | csvtk.exe mutate -f "observedyears" -n "year" -p "(\d*)\.\d*" ^
 | csvtk.exe mutate -f "observyears" -n "year" -p "(\d*)\.\d*" ^
 | csvtk.exe mutate -f "operation date" -n op_year_month -p "^(.{7})" ^
 | csvtk.exe mutate -f "time to endpoint" -n "observedyears" -p "(.*)" ^
 | csvtk.exe mutate -f date_of_referral -n month_of_referral -p "^(.{7})" ^
 | csvtk.exe mutate -f posting_date -n posting_date_month -p "^(.{7})" ^
 | csvtk.exe mutate -f postingdate -n postingmonth -p "^.{3}(.{2})" ^
 | csvtk.exe mutate -f postingdate -n postingyear -p "^.{6}(.{4})" ^
 | csvtk.exe mutate -f procedure_date -n month_of_procedure -p "^(.{7})" ^
 | csvtk.exe mutate -f referral_created -n date_of_referral -p "^(.{10})" ^
 | csvtk.exe mutate2 -n "cy" -w 3 -e "$revised / ($totalyears / 100)" ^
 | csvtk.exe mutate2 -n "dob"  -e "''" ^
 | csvtk.exe mutate2 -n "femoraltype" -e "$manufacturer + ' ' + $knee"  ^
 | csvtk.exe mutate2 -n "km" -w 2 -e "100*(($atrisk-$revised_rsum)/$atrisk)" ^
 | csvtk.exe mutate2 -n "km_cond" -w 2 -e "($atrisk-$revised_rsum)/$atrisk" ^
 | csvtk.exe mutate2 -n "meanfu" -w 1 -e "$totalyears / $total" ^
 | csvtk.exe mutate2 -n "mrn"  -e "''" ^
 | csvtk.exe mutate2 -n "percent" -w 2 -e "($4 * 100) / $6" ^
 | csvtk.exe mutate2 -n "percent" -w 2 -e "($revised * 100) / $total" ^
 | csvtk.exe mutate2 -n "percentunknown" -w 2 -e  "(100*$unknown)/($unknown+$death+$revised+$unrevised)" ^
 | csvtk.exe mutate2 -n "total" -w 0 -e "$2+$3+$4+$5"  ^
 | csvtk.exe mutate2 -n "total" -w 0 -e "$death+$revised+$unrevised"  ^
 | csvtk.exe mutate2 -n "total" -w 0 -e "$death+$revised+$viable"  ^
 | csvtk.exe mutate2 -n "totalyears" -w 0 -e "$2+$3+$4+$5"  ^
 | csvtk.exe mutate2 -n "totalyears" -w 0 -e "$death+$revised+$unrevised"  ^
 | csvtk.exe mutate2 -n "totalyears" -w 0 -e "$death+$revised+$viable"  ^
 | csvtk.exe mutate2 -n "totalyears" -w 2 -e "$death+$revised+$unrevised"  ^
 | csvtk.exe mutate2 -n "years" -w 0 -e "$year + 1" ^
 | csvtk.exe mutate2 -n atrisk -w 0 -e "!rows!-($censored_rsum+$death_rsum)" ^
 | csvtk.exe mutate2 -n postingyearmonth -e "$postingyear + '/' + $postingmonth" ^
 | csvtk.exe mutate2 -n tc -e "${total cost}*1.0" ^
 | csvtk.exe mutate2 -n year -w 0 -e "$1+1"^
 | csvtk.exe mutate2  -n primary_key -e "${referral_created} + ${nhs_number}" ^
 | csvtk.exe plot hist  -f delay_from_booking --title "delay from booking - all" --bins 30 -o _analysis%infile%.1.svg
 | csvtk.exe plot hist  -f delay_from_booking --title "delay from booking - lower limb" --bins 30 -o _analysis%infile%.5.svg
 | csvtk.exe plot hist  -f delay_from_booking --title "delay from booking - nof" --bins 30 -o _analysis%infile%.2.svg
 | csvtk.exe plot hist  -f delay_from_booking --title "delay from booking - spine" --bins 30 -o _analysis%infile%.3.svg
 | csvtk.exe plot hist  -f delay_from_booking --title "delay from booking - upper limb" --bins 30 -o _analysis%infile%.4.svg
 | csvtk.exe plot line -x year -y km --title "km plot : all tkr : 97.4% @ 10 years" ^
 | csvtk.exe plot line -x year -y km --title "km plot : lps flex : 98.90% @ 10 years" ^
 | csvtk.exe plot line -x yearquarter -y failurebeforetenyears --title "percentage failures before ten years" --y-max 20 --y-min 0  --x-min 2007.0 --x-max 2023.0  ^
 | csvtk.exe plot line -x years -y survival_rprod --title "km for !rows! nexgen lps flex with known endpoints" --y-max 1 --y-min 0 ^
 | csvtk.exe plot line -x years -y survival_rprod --title "km for !rows! tkr with known endpoints" --y-max 1 --y-min 0 ^
 | csvtk.exe plot line -x years -y survival_rprod --title "km for !rows! tkr with known endpoints" ^
 | csvtk.exe pretty -s " | " -r  ^
 | csvtk.exe pretty -s " | " -r  ^
 | csvtk.exe pretty -s " | " -r ^
 | csvtk.exe pretty -s " | " -r ^
 | csvtk.exe pretty -s " | " > %outfile%
 | csvtk.exe pretty ^
 | csvtk.exe rename -f 1 -n "primary consultant" ^
 | csvtk.exe rename -f 1 -n femoraltype  ^
 | csvtk.exe rename -f 1 -n leadsurgeon ^
 | csvtk.exe rename -f 1 -n years ^
 | csvtk.exe rename -f 1 -n years^
 | csvtk.exe rename -f 2 -n censored  ^
 | csvtk.exe rename -f 2 -n unknown  ^
 | csvtk.exe rename -f 2 -n unknown ^
 | csvtk.exe rename -f tc -n "total cost" ^
 | csvtk.exe replace -f date -p "^(..).(..).(....)" -r "$2/$1/$3" ^
 | csvtk.exe replace -f date_of_referral -p "^(..).(..).(....)" -r "$2/$1/$3" ^
 | csvtk.exe replace -f date_of_referral -p "^(..).(..).(....)" -r "$3-$2-$1" ^
 | csvtk.exe replace -f procedure_date -p "^(..).(..).(....)" -r "$3-$2-$1" ^
 | csvtk.exe sort -k "lead surgeon",endpoint ^
 | csvtk.exe sort -k "primary consultant",endpoint ^
 | csvtk.exe sort -k 1,2 ^
 | csvtk.exe sort -k 1,2 ^
 | csvtk.exe sort -k 1,5:nr ^
 | csvtk.exe sort -k 1:n ^
 | csvtk.exe sort -k 1:n ^
 | csvtk.exe sort -k 2:n ^
 | csvtk.exe sort -k 2:n ^
 | csvtk.exe sort -k 2:nr ^
 | csvtk.exe sort -k 5:nr ^
 | csvtk.exe sort -k cy:n ^
 | csvtk.exe sort -k cy:nr ^
 | csvtk.exe sort -k leadsurgeon,endpoint ^
 | csvtk.exe sort -k op_year_month:n ^
 | csvtk.exe sort -k percent:n ^
 | csvtk.exe sort -k percent:nr ^
 | csvtk.exe sort -k postingyearmonth:n ^
 | csvtk.exe sort -k totalyears:n ^
 | csvtk.exe sort -k totalyears:nr ^
 | csvtk.exe sort -k year:n ^
 | csvtk.exe sort -k year:n,endpoint ^
 | csvtk.exe sort -k years:n ^
 | csvtk.exe sort -k years:n,endpoint ^
 | csvtk.exe summary -i -f invoice_value:sum -g posting_date_month ^
 | csvtk.exe summary -i -f invoice_value:sum -g supplier_name
 | csvtk.exe summary -i -f invoice_value:sum,invoice_value:count,invoice_value:mean -g consultant ^
 | csvtk.exe summary -i -f invoicevalue:count,invoicevalue:max,invoicevalue:mean,invoicevalue:sum -g consultant ^
 | csvtk.exe summary -i -f invoicevalue:sum -g postingyearmonth ^
 | csvtk.exe summary -i -f invoicevalue:sum -g year ^
 | csvtk.exe summary -i -w 0 -f 1:first,2:sum,3:sum,4:sum,5:median,6:median -g 7 ^
 | csvtk.exe summary -i -w 0 -f 2:sum,3:sum,4:sum,5:median,6:median -g 1 ^
 | csvtk.exe summary -i -w 0 -f 2:sum,3:sum,4:sum,5:median,6:sum -g 1 ^
 | csvtk.exe summary  -i -f invoicevalue:sum -g suppliername ^
 | csvtk.exe summary  -i -f op_year_month:first,op_year_month:last  ^
 | csvtk.exe summary  -i -f postingyearmonth:first,postingyearmonth:last  ^
 | datamash.exe --field-separator=, --header-in --format="%%.2f" crosstab 1,2 sum 3 ^
 | datamash.exe  --field-separator=, --header-in --format="$%%.2f"  crosstab 1,2 sum 3 | sed.exe  s/N\/A//g ^
 | datamash.exe  --field-separator=, --header-in --format="$%%.2f" crosstab 1,2 sum 3 ^
 | datamash.exe  --field-separator=, --header-in --format="%%.2f" crosstab 14,46 mean 7 | sed.exe  s/N\/A//g ^
 | datamash.exe  --field-separator=, --header-in crosstab 1,2 count 2 ^
 | datamash.exe  --field-separator=, --header-in crosstab 1,2 sum 3 ^
 | datamash.exe  --field-separator=, --header-in crosstab 2,1 count 2 ^
 | head.exe -n -2 - ^
 | head.exe -n -5 - ^
 | head.exe -n1 | sed.exe s/,/\n/g | cat.exe -n ^REM List fields with numbers
 | mlr.exe --csv cut -o -f years,endpoint ^
 | mlr.exe --csv filter "$year > 2006" ^
 | mlr.exe --csv filter "$years < 17" ^
 | mlr.exe --csv format-values -f "%%.1f" ^
 | mlr.exe --csv format-values -f "%%.3f" ^
 | mlr.exe --csv format-values -f "%%.4f" ^
 | mlr.exe --csv label reason ^
 | mlr.exe --csv label yearquarter ^
 | mlr.exe --csv label yearquarter,unknown ^
 | mlr.exe --csv label yearquarter,unrevised ^
 | mlr.exe --csv label years ^
 | mlr.exe --csv put '$failurebeforetenyears = 100*($revised / $total)' ^
 | mlr.exe --csv put '$month = sub($date_of_operation,"(..)(.)(..)(.)([0-9][0-9][0-9][0-9])","\3")' ^
 | mlr.exe --csv put '$month = sub($date_of_operation,"([0-9][0-9][0-9][0-9])(.)(..)(.*)","\3")' ^
 | mlr.exe --csv put '$quarter = floor(float($month) / 4) + 1' ^
 | mlr.exe --csv put '$revisionreason = regextract($indrev_summaryrevisionreasons, "[^;]*")' ^
 | mlr.exe --csv put '$revisionreason = regextract($indrev_summaryrevisionreasons, "[^|]*")' ^
 | mlr.exe --csv put '$total = $2003 + $2004 + $2005 + $2006 + $2007 + $2008 + $2009 + $2010 + $2011 + $2012 + $2013 + $2014 + $2015 + $2016 + $2017 + $2018 + $2019 + $2020 + $2021 + $2022 + $2023' ^
 | mlr.exe --csv put '$total = $death + $revised + $unrevised' ^
 | mlr.exe --csv put '$total = $death + $revised + $viable' ^
 | mlr.exe --csv put '$year = regextract($date_of_operation,"[0-9][0-9][0-9][0-9]")' ^
 | mlr.exe --csv put '$yearquarter = $year . "." .  $quarter' ^
 | mlr.exe --csv put '$yearquarter = $year . "." .  ($quarter/4 )' ^
 | mlr.exe --csv put "$atrisk = !rows!-($total_rsum-$total)" ^
 | mlr.exe --csv put "$survival = $survived/$atrisk" ^
 | mlr.exe --csv put "$survival = ($atrisk-$revised_rsum)/$atrisk" ^
 | mlr.exe --csv put "$survived = $atrisk-$revised" ^
 | mlr.exe --csv put "$survived = $atrisk-$revised_rsum" ^
 | mlr.exe --csv put "$total = $death+$revised+$unrevised" ^
 | mlr.exe --csv put "$total = $death+$revised+$viable" ^
 | mlr.exe --csv put "$years = floor($observedyears)+1" ^
 | mlr.exe --csv sort -f year,revisionreason ^
 | mlr.exe --csv sort -f yearquarter,endpoint ^
 | mlr.exe --csv sort -f yearquarter,revisionreason ^
 | mlr.exe --csv sort -nr total ^
 | mlr.exe --csv sort -t yearquarter ^
 | mlr.exe --csv sort -t years ^
 | mlr.exe --csv sort -t years,endpoint ^
 | mlr.exe --csv step -a rprod -f survival ^
 | mlr.exe --csv step -a rsum -f censored ^
 | mlr.exe --csv step -a rsum -f death ^
 | mlr.exe --csv step -a rsum -f revised ^
 | mlr.exe --csv step -a rsum -f total ^
 | mlr.exe --csv step -a rsum -f unrevised ^
 | mlr.exe --csv step -a rsum -f viable ^
 | mlr.exe --csv uniq -a -c ^
 | mlr.exe --icsv --ocsv unspace -k ^
 | numfmt.exe -d, --header --field=2 --format="$%%'.2f" ^
 | numfmt.exe -d, --header --field=3,4,5 --format="$%%'.2f" ^
 | numfmt.exe -d, --header --field=5 --format="$%%'.2f" ^
 | pl.exe -svg -prefab chron data=- delim=comma header=yes x=1 y=2 y2=4 y3=5 y4=6 datefmt=yyyy mode=line title=!title!^
 | pl.exe -svg -prefab chron data=- delim=comma header=yes x=1 y=2 y2=4 y3=5 y4=6 datefmt=yyyymmdd mode=line curve=yes title=!title!^
 | pl.exe -svg -prefab chron data=- delim=comma header=yes x=1 y=5 y2=6 linedet="color=blue" linedet2="color=orange" datefmt=yyyymmdd mode=line curve=yes title=!title!^
 | sed.exe  s/n\/a//g ^
 | sed.exe "s/\,femoral component/\,tc plus ps /g" ^
 | sed.exe "s/\,femoralcomponent.ps/\,tc plus ps /g" ^
 | sed.exe "s/dr\s/mr /g" ^
 | sed.exe s/.left//g ^
 | sed.exe s/.right//g ^
 | sed.exe s/\sinvoicevalue\s/invoicevalue/g ^
 | sed.exe s/\t/,/g ^
 | sed.exe s/adverse\ssoft\stissue\sreaction\sto\sparticulate\sdebris/alval/g ^
 | sed.exe s/date\sof\soperation/date_of_operation/g ^
 | sed.exe s/error/unrevised/g ^
 | sed.exe s/invoicevalue\s/invoicevalue/g ^
 | sed.exe s/lrigg,registrar/lrigg,consultant/g ^
 | sed.exe s/n\/a/0/g ^
 | sed.exe s/revision\sindications\ssummary/indrev_summaryrevisionreasons/g ^
 | sed.exe s/tten,registrar/tten,consultant/g ^
 | tail.exe -n +2 - ^
 | tail.exe -n +4 - ^
 | tr.exe -d "\012" ^
 | tr.exe "\015" "\012\015" ^

