# ==================================== Parameters ===============================================
# $SERVICE_NAME      : Name of Service to Restart
# $SERVICE_USERNAME  : Username of Service Account
# $SERVICE_PASSWORD  : Password of Service Account
# $RESUME_ON_FAILURE : Whether script should gracefully exit or not on failure
# ==================================== Constants ===============================================

$SERVICE_STATUS_RUNNING_VALUE = "Running"

# ==================================== Script Execution ========================================

$Service = gwmi win32_service -filter "name='$SERVICE_NAME'"

If ( $Service ) {

  Echo "Changing Account for $SERVICE_NAME"
  $Service.Change($null,$null,$null,$null,$null,$null, $SERVICE_USERNAME, $SERVICE_PASSWORD)

  Restart-Service -name $SERVICE_NAME -Force

  # Check if service is running
  $Service = Get-Service | Where-Object { $_.name -eq "$SERVICE_NAME" }
  if ($Service.Status -ne $SERVICE_STATUS_RUNNING_VALUE ) {
      Echo "Error: Service $SERVICE_NAME is not running."

      if ($RESUME_ON_FAILURE -eq "False") {
        Exit 1
      }
  }
}
Else {
  Echo "Error: Service $SERVICE_NAME not Found"

  if ($RESUME_ON_FAILURE -eq "False") {
    Exit 1
  }
}
