@echo off
set OWNER=LorenzoLeonardo

echo Start Deleting all artifacts . . .
for /f "delims=" %%R in ('gh repo list %OWNER% --json name --jq ".[].name"') do (
    echo Processing repository: %%R
    for /f "delims=" %%A in ('gh api repos/%OWNER%/%%R/actions/artifacts --paginate --jq ".artifacts[].id"') do (
        echo Deleting artifact ID: %%A from %%R
        gh api -X DELETE repos/%OWNER%/%%R/actions/artifacts/%%A
    )
)
echo End Deleting all artifacts . . .

echo Start Deleting all workflow runs . . .
for /f "delims=" %%R in ('gh repo list %OWNER% --json name --jq ".[].name"') do (
    echo Processing repository: %%R
    for /f "delims=" %%W in ('gh api repos/%OWNER%/%%R/actions/runs --paginate --jq ".workflow_runs[].id"') do (
        echo Deleting workflow run ID: %%W from %%R
        gh api -X DELETE repos/%OWNER%/%%R/actions/runs/%%W
    )
)
echo End Deleting all workflow runs . . .

echo Start Deleting all Caches . . .
for /f "delims=" %%R in ('gh repo list %OWNER% --json name --jq ".[].name"') do (
    echo Processing repository: %%R
    for /f "delims=" %%C in ('gh api repos/%OWNER%/%%R/actions/caches --paginate --jq ".actions_caches[].id"') do (
        echo Deleting cache ID: %%C from %%R
        gh api -X DELETE repos/%OWNER%/%%R/actions/caches/%%C
    )
)
echo End Deleting all Caches . . .
