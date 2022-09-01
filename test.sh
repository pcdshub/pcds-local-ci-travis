#!/bin/bash

set -x

# shellcheck disable=SC1090
source ~/virtualenv/python3.9/bin/activate

git pull

python --version

export DISPLAY=:99

# sudo systemctl start xvfb || exit 1
/usr/bin/Xvfb ${DISPLAY} -screen 0 1024x768x24 &
sleep 1
herbstluftwm &
sleep 1

PYTEST_ARGS=(-v)
PYTEST_ARGS+=(--cov=.)
PYTEST_ARGS+=(--log-file="${AFTER_FAILURE_LOGFILE:-logs/run_tests_log.txt}")
PYTEST_ARGS+=(--log-format='%(asctime)s.%(msecs)03d %(module)-15s %(levelname)-8s %(threadName)-10s %(message)s')
PYTEST_ARGS+=(--log-file-date-format='%H:%M:%S')
PYTEST_ARGS+=(--log-level=DEBUG)

ulimit -c unlimited

pytest "${PYTEST_ARGS[@]}"

# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
  echo "Successful run"
else
  LOGFILE="${AFTER_FAILURE_LOGFILE:-logs/run_tests_log.txt}"
  if [ -f "${LOGFILE}" ]; then
    cat "${LOGFILE}"
  else
    echo "Logfile ${LOGFILE} not found"
  fi
fi

echo "add-auto-load-safe-path /opt/python/3.9.6/bin/python3.9-gdb.py" >> ~/.gdbinit

PYTHON_BIN="$(python -c 'import sys; print(sys.executable)')"
export PYTHON_BIN

# shellcheck disable=SC2016
echo '"$PYTHON_BIN" -m pytest -v "${PYTEST_ARGS[@]}"' >> ~/.bash_history
# shellcheck disable=SC2016
echo 'less logs/run_tests_log.txt' >> ~/.bash_history

if [ -f core ]; then
  # shellcheck disable=SC2016
  echo 'gdb "$PYTHON_BIN" core' >> ~/.bash_history
  # shellcheck disable=SC2016
  echo 'gdb --args "$PYTHON_BIN" -m pytest -v "${PYTEST_ARGS[@]}"' >> ~/.bash_history
  gdb "$PYTHON_BIN" core
fi

/bin/bash --login
