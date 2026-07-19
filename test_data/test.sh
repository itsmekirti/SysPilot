echo "hello"
echo "first=$1"
echo "my name is $2"

check_report_directory() {
    REPORT_GENERATION_PATH="/var/log/syspilot"
    REPORT_NAME="report-$(date +%Y-%m-%d).txt"
    REPORT_FILE="$REPORT_GENERATION_PATH/$REPORT_NAME"

    if [ ! -d "$REPORT_GENERATION_PATH" ]
    then
        sudo mkdir -p "$REPORT_GENERATION_PATH"
    fi
}
generate_report(){

    check_report_directory

    {

    echo "========================================="
    echo "       SysPilot Security Report"
    echo
    echo "$(date)"
    echo
    echo "========================================="
    echo
    echo "===== Failed SSH Analysis ====="
    echo

    failed_ssh_analysis

    echo
    echo "========================================="
    echo
    echo "===== System Errors Analysis ====="
    echo

    system_error_analysis

    echo
    echo "========================================="
    echo
    echo "===== Successful Logins ======"
    echo

    successful_logins

    } | sudo tee "$REPORT_FILE"

}
