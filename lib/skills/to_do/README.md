## ToDo
Tod
- todoist api
  
- work from phone
- ToPlan ToDo without due date or without due time
- error handeling
- handle saving empty task
- make task edit nois
- make work for time
  - daily
  - monthly
- labels for displaying tasks
  - today, upcoming are a sum of labels
- be able to move tasks
- sort them automatically by date
- work for phone
- if you hover over date you get more details
- terminal looking instead of scaffoldmessager
- highlight time part from task
- pause task
  - right click, have a list of perdiods of working instead of only start and end
- calendar should show interval, not only dates

## Done
- refactor
  - make ctrl q work: just wrap the child of shortcut in focus with autofocus
- show ok instead of add and cancell
- subtasks
  - solve empty subtask
  - show them nais
- ordrer by date
- refactor
- Create/view page
- edit task when clicking on it
- show planned time in edit task
- priority from input parser
- load only not done tasks
- after completing a task
- 1 task
  - i want to be able to work on it multiple times: jarvis / to buy
  - list of time (without reccuranceGap)
- see when task is started
  - play/stop
- start, do task
- see reccurance icon
- Planned, actual start, enddate
- delete time park from task
- make tom work
- no date and time should work
- shouldn't flicker when adding a new task
- finish writing the dateTime options
- implement the dateTime options


Home page: scrollable 
  1st page
    Upper half: todo (button to add task)
      Tasks to do now
      ToBuy
      ToPlan
    Lower half: notes (button to add note)
Before going to sleep: day review + score
Keep track of score (hours efficient /hours inneficient)
+ plan next day
Remind me of bdays + exams some time before


## Tasks operations
- add a new task
- modify a task (by id)
- delete a task (by id)
- sort tasks by date

## Sync
- Log
  - id: dateTime + deviceId (document name)
  - action: add, modify, delete
  - taskId

- Lists of log ids to sync
  - Server
  - For every device
- General sync


- When
  - opening ToDo
  - adding a new task (when you close the dialog)
  - modifying a task
  - deleting a task
  - refreshing tasks
- What
  - list of tasks
    - a task: data + subTasks + parentTask
    - ideea: not worh it (archived tasks) have a map with all the tasks
      - everything uses only the id

start DateTime, reccurance, planned duration, actual duration 
- firestore storage
- display: string (simpler string)
  - if reccurent just show the reccurent icon
  - start DateTime -> end DateTime
  - DateTime
    - can be none (no date no time)
    - time if optional (can have only date)
    - if date not present (only time) it's today
    - Date
      - 12 mar 22
      - 12 mar
      - mon
    - Time
      - 12:00
- input ~ display more complex string
  - date
      no date
      12.5.25
      12 jan 25
      12.5
      12 jan
      this/every 12
      tod/tom
      in/every 5d/w/m/y
      /every mon/tue/wed/thu/fri/sat/sun
      /every end of jan
  - time
      12:34
      no time
  - date & time
      in 5m/h
      date time
  - end date / duration
      date time -> time: 12 jan 12:00 -> 13:00
      date time -> date time 12 jan 12:00 -> 13 jan 15:00
      date time -> duration: 21 jan 12:00 for 1m/h/d/w/m/y
- mark it as done
  - if reccurent set it to next startDate
    - every 5d/w/m/y
    - every mon
- order by DateTime for calendar

## Task
### View in app
- Done % / #ToPlan
- Title
- Description
- Start date -> end date
- Planned time -> actual time
- Priority
  - 0 = red = cannot change it: exam/business meeting
  - 1 = orange = should not change it: meeting/doctor apoointment/gym
  - 2 = no colour = everything else
- Subtasks

### Add a new task
- press + button
- press q

