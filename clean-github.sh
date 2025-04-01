OWNER="LorenzoLeonardo"

# Deleting all artifacts
echo "Start Deleting all artifacts . . ."
gh repo list $OWNER --json name --jq '.[].name' | while read -r REPO; do
    echo "Processing repository: $REPO"

    # Handle pagination
    PAGE=1
    while :; do
        ARTIFACT_IDS=$(gh api repos/$OWNER/$REPO/actions/artifacts --paginate --jq '.artifacts[].id')

        if [ -z "$ARTIFACT_IDS" ]; then
            echo "No more artifacts to delete in $REPO"
            break
        fi

        for artifact_id in $ARTIFACT_IDS; do
            echo "Deleting artifact ID: $artifact_id from $REPO"
            gh api -X DELETE repos/$OWNER/$REPO/actions/artifacts/$artifact_id
        done

        ((PAGE++))
    done
done
echo "End Deleting all artifacts . . ."

echo "Start Deleting all workflow runs . . ."
gh repo list $OWNER --json name --jq '.[].name' | while read -r REPO; do
    echo "Processing repository: $REPO"

    # Get total workflow runs and process them in pages
    PAGE=1
    while :; do
        RUN_IDS=$(gh api repos/$OWNER/$REPO/actions/runs --paginate --jq '.workflow_runs[].id')

        if [ -z "$RUN_IDS" ]; then
            echo "No more workflow runs to delete in $REPO"
            break
        fi

        for run_id in $RUN_IDS; do
            echo "Deleting workflow run ID: $run_id from $REPO"
            gh api -X DELETE repos/$OWNER/$REPO/actions/runs/$run_id
        done

        ((PAGE++))
    done
done
echo "End Deleting all workflow runs . . ."

echo "Start Deleting all Caches . . ."
# Loop through all repositories
gh repo list $OWNER --json name --jq '.[].name' | while read -r REPO; do
    echo "Processing repository: $REPO"

    # Handle pagination
    PAGE=1
    while :; do
        CACHE_IDS=$(gh api repos/$OWNER/$REPO/actions/caches --paginate --jq '.actions_caches[].id')

        if [ -z "$CACHE_IDS" ]; then
            echo "No more caches to delete in $REPO"
            break
        fi

        for cache_id in $CACHE_IDS; do
            echo "Deleting cache ID: $cache_id from $REPO"
            gh api -X DELETE repos/$OWNER/$REPO/actions/caches/$cache_id
        done

        ((PAGE++))
    done
done
echo "End Deleting all Caches . . ."
