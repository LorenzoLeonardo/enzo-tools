:: This script deletes all artifacts, workflow runs, and caches from all repositories owned by a specified GitHub user.
:: It uses the GitHub CLI to interact with the GitHub API.
:: It requires the user to have the GitHub CLI installed and authenticated.
:: Make sure to replace "LorenzoLeonardo" with your GitHub username or organization name.
:: Usage: clean-github.bat
:: Created by LorenzoLeonardo on 2023-04-01

@echo off

:: Check if gh CLI is installed
where gh >nul 2>nul
if errorlevel 1 (
    echo gh CLI could not be found. Please install it first.
    exit /b
)

set OWNER=LorenzoLeonardo

echo Start Deleting all artifacts . . .
for /f "delims=" %%R in ('gh repo list %OWNER% --limit 1000 --json name --jq ".[].name"') do (
    echo Processing repository: %%R
    for /f "delims=" %%A in ('gh api repos/%OWNER%/%%R/actions/artifacts --paginate --jq ".artifacts[].id"') do (
        echo Deleting artifact ID: %%A from %%R
        gh api -X DELETE repos/%OWNER%/%%R/actions/artifacts/%%A
    )
    echo No more artifacts to delete in %%R
)
echo End Deleting all artifacts . . .

echo Start Deleting all workflow runs . . .
for /f "delims=" %%R in ('gh repo list %OWNER% --limit 1000 --json name --jq ".[].name"') do (
    echo Processing repository: %%R
    for /f "delims=" %%W in ('gh api repos/%OWNER%/%%R/actions/runs --paginate --jq ".workflow_runs[].id"') do (
        echo Deleting workflow run ID: %%W from %%R
        gh api -X DELETE repos/%OWNER%/%%R/actions/runs/%%W
    )
    echo No more workflow runs to delete in %%R
)
echo End Deleting all workflow runs . . .

echo Start Deleting all Caches . . .
for /f "delims=" %%R in ('gh repo list %OWNER% --limit 1000 --json name --jq ".[].name"') do (
    echo Processing repository: %%R
    for /f "delims=" %%C in ('gh api repos/%OWNER%/%%R/actions/caches --paginate --jq ".actions_caches[].id"') do (
        echo Deleting cache ID: %%C from %%R
        gh api -X DELETE repos/%OWNER%/%%R/actions/caches/%%C
    )
    echo No more caches to delete in %%R
)
echo End Deleting all Caches . . .
