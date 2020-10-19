#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$SCRIPT_DIR" > /dev/null

CONF_FILE_PATH=./jenkins_job.ini
JOB_FOLDERS=("jobs")
SOPS_DECRYPT=true

if [[ "${#}" -lt "1" ]]; then
  echo "usage: $(basename "${0}") <function> <optional>

  Perform a jenkins job function

  function:
    update        Run JJB using jenkins_job.ini config
    test          Test JJB using jenkins_job.ini config
  
  optional:
    local         Run JJB using jenkins_job_local.ini config
"
  exit 0
fi

if [[ "${2:-}" == "local" ]]; then
  CONF_FILE_PATH=./jenkins_job_local.ini
  SOPS_DECRYPT=false
fi

case ${1} in
update)
  if [ "$SOPS_DECRYPT" = true ] ; then
      sops -i -d "${CONF_FILE_PATH}"
  fi

  for folder in "${JOB_FOLDERS[@]}"; do
    jenkins-jobs --conf "${CONF_FILE_PATH}" update "$folder"
  done
  ;;
test)

  for folder in "${JOB_FOLDERS[@]}"; do
    jenkins-jobs test "$folder"
  done
  ;;
*)
  echo 'Invalid argument'
  exit 1
  ;;
esac

