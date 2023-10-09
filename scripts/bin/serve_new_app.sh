#!/bin/bash
: ' ----------------------------------------
* Creation Time : Fri 18 Aug 2023 16:00:19 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

CONFIG_FILE="$HOME/.cloudflared/config.yml"
ACTION="deploy"
DOMAIN="charlesnchr.com"
DOCKERFILE="Dockerfile"
DRY_RUN=0

usage() {
    echo "Usage:"
    echo "  $0 --action [deploy|delete] --project PROJECT_NAME [--port DOCKER_PORT] [--dry-run]"
    echo ""
    echo "Options:"
    echo "  --project      Name of the project. Required."
    echo "  --port         Docker port. Required for deploy action."
    echo "  --action       The action to take: deploy or delete. Default is deploy."
    echo "  --dockerfile   Path to the Dockerfile. Default is $DOCKERFILE."
    echo "  --domain       Domain name. Default is $DOMAIN."
    echo "  --dry-run      Show commands without executing."
    exit 1
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --action)
            ACTION="$2"
            shift; shift ;;
        --project)
            PROJECTNAME="$2"
            shift; shift ;;
        --port)
            DOCKERPORT="$2"
            shift; shift ;;
        --dockerfile)
            DOCKERFILE="$2"
            shift; shift ;;
        --domain)
            DOMAIN="$2"
            shift; shift ;;
        --dry-run)
            DRY_RUN=1
            shift ;;
        *)
            echo "Unknown option: $1"
            usage ;;
    esac
done

# Validate project name
if [[ -z "$PROJECTNAME" ]]; then
    echo "Error: Project name is required."
    usage
fi

# Validate docker port for deploy action
if [[ "$ACTION" == "deploy" && -z "$DOCKERPORT" ]]; then
    echo "Error: Docker port is required for deploy action."
    usage
fi

execute_or_dryrun() {
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "$1"
    else
        eval "$1"
    fi
}

if [[ "$ACTION" == "delete" ]]; then
    # Delete from config.yml
    execute_or_dryrun "sed -i '/$PROJECTNAME.$DOMAIN/,+1d' $CONFIG_FILE"

    # Restart cloudflared service
    execute_or_dryrun "sudo systemctl restart cloudflared"

    # Stop and remove Docker image
    CONTAINER_ID=$(docker ps -aqf "name=$PROJECTNAME")
    if [ -n "$CONTAINER_ID" ]; then
        execute_or_dryrun "docker stop '$CONTAINER_ID'"
        execute_or_dryrun "docker rm '$CONTAINER_ID'"
    fi

    # Delete DNS record
    DNS_RECORD_ID=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?type=CNAME&name=$PROJECTNAME.$DOMAIN" -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $CLOUDFLARE_API_KEY" -H "Content-Type: application/json" | jq -r '.result[0].id')
    execute_or_dryrun "curl -X DELETE 'https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$DNS_RECORD_ID' -H 'X-Auth-Email: charles.n.chr@gmail.com' -H 'X-Auth-Key: $CLOUDFLARE_API_KEY' -H 'Content-Type: application/json'"

else
    # Deploy actions

    # Check if the entry exists already in the cloudflared config
    if grep -q "$PROJECTNAME.$DOMAIN" $CONFIG_FILE; then
        echo "Routing/networking/tunnelling has been configured."
        PROJECTPORT=$(awk -v project="$PROJECTNAME.$DOMAIN" '$0 ~ project {getline; split($0, arr, ":"); print arr[4]}' $CONFIG_FILE)
    else
        # Determine the next free port in the ingress section counting down from 8999
        PROJECTPORT=8999
        while grep -q "localhost:$PROJECTPORT" $CONFIG_FILE; do
            ((PROJECTPORT--))
        done

        # Add the new entry to the cloudflared config
        execute_or_dryrun "sed -i '/# Rules map traffic/a - hostname: $PROJECTNAME.$DOMAIN\n  service: http://localhost:$PROJECTPORT' $CONFIG_FILE"

        # DNS routing with cloudflared
        execute_or_dryrun "cloudflared tunnel route dns '$PROJECTNAME' '$PROJECTNAME.$DOMAIN'"

        # Restart the cloudflared service
        execute_or_dryrun "sudo systemctl restart cloudflared"
    fi

    # Docker build
    execute_or_dryrun "docker build -t '$PROJECTNAME' -f '$DOCKERFILE' ."

    # Check if a container with the project name is running; stop and remove it if so
    CONTAINER_ID=$(docker ps -aqf "name=$PROJECTNAME")
    if [ -n "$CONTAINER_ID" ]; then
        execute_or_dryrun "docker stop '$CONTAINER_ID'"
        execute_or_dryrun "docker rm '$CONTAINER_ID'"
    fi

    # Run the new docker image
    execute_or_dryrun "docker run -d --restart=always -p '$PROJECTPORT:$DOCKERPORT' --name $PROJECTNAME '$PROJECTNAME:latest'"

fi

if [[ $DRY_RUN -eq 1 ]]; then
    echo "Dry run completed."
else
    echo "Operation completed."
fi
