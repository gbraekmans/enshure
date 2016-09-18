test_query() {
  RESULT=$(enshure query current_task)
  assertTrue 1 "$?"
  assertEquals 2 "INFO: Current task is: ''" "$RESULT"

  RESULT=$(enshure query made_change)
  assertTrue 3 "$?"
  assertEquals 4 "INFO: No change made by enSHure." "$RESULT"

  printf '%s\n' "#CHANGE|1970-01-01 00:00:00|0|command|exit 3|executed|Command exit 3 is now executed." >> "$ENSHURE_LOG"
  RESULT=$(enshure query made_change)
  assertTrue 5 "$?"
  assertEquals 6 "INFO: enSHure made a change." "$RESULT"

  RESULT=$(enshure query summary)
  assertTrue 7 "$?"
  assertEquals 8 "INFO: 1 of 1 statements required changes" "$RESULT"

  RESULT=$(enshure query command_output)
  assertTrue 9 "$?"
  assertEquals 10 "INFO: " "$RESULT"

  RESULT=$(enshure query whatever)
  assertFalse 11 "$?"
  assertEquals 12 "ERROR: Query 'whatever' is unknown.
ERROR: Not all requirements are met." "$RESULT"

  RESULT=$(enshure query current_task task whatever)
  assertFalse 13 "$?"
  assertEquals 14 "ERROR: Can only supply the task argument with a summary query
ERROR: Not all requirements are met." "$RESULT"
}
