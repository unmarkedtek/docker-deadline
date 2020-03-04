#!/bin/bash

# Loop check for maya-worker1
while ! $(/opt/Thinkbox/Deadline10/bin/deadlinecommand SlaveExists maya-worker1 > /dev/null); do
    sleep 5  
done

#  Add Spot Pool
/opt/Thinkbox/Deadline10/bin/deadlinecommand addpool spot -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to add pool: $status"
  exit $status
fi

# Loop Check for Pool
while ! $(/opt/Thinkbox/Deadline10/bin/deadlinecommand GetPoolNames| grep spot > /dev/null); do
    sleep 5
done

#  Add Spot-fleet group
/opt/Thinkbox/Deadline10/bin/deadlinecommand addgroup spot-fleet
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to add spot-fleet: $status"
  exit $status
fi

# Loop Check for Group
while ! $(/opt/Thinkbox/Deadline10/bin/deadlinecommand GetGroupNames| grep spot-fleet > /dev/null); do
    sleep 5
done

# Add pool to maya-worker1 
/opt/Thinkbox/Deadline10/bin/deadlinecommand AddPoolToSlave maya-worker1 spot
if [ $status -ne 0 ]; then
  echo "Failed to add spot group to maya-worker1: $status"
  exit $status
fi

# Add Group to maya-worker1 
/opt/Thinkbox/Deadline10/bin/deadlinecommand AddGroupToSlave maya-worker1 spot-fleet
if [ $status -ne 0 ]; then
  echo "Failed to add spot-fleet group to maya-worker1: $status"
  exit $status
fi
