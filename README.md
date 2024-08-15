<div align = "center">
<pre>
     ██╗ █████╗ ██████╗ ██╗   ██╗██╗███████╗    ██████╗ 
     ██║██╔══██╗██╔══██╗██║   ██║██║██╔════╝    ╚════██╗
     ██║███████║██████╔╝██║   ██║██║███████╗     █████╔╝
██   ██║██╔══██║██╔══██╗╚██╗ ██╔╝██║╚════██║    ██╔═══╝ 
╚█████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║███████║    ███████╗
 ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝    ╚══════╝
---------------------------------------------------
Personal assistant
</pre>
</div>

# Website
https://teoneag.github.io/jarvis-2-web/

## Goal
- Personal assistant (like Jarvis form Iron Man)
- Just a rather intelligent system"
- = app that helps with daily + professional tasks
- combine the functionality of Alexa + Todoist + OneNote + ...


### Milestone 2: add text interface
- make MWApi detect verbs

### Milestone 3: add custom commands
- Ex: when I say "buy x", and x is a noun, add it to shopping list
- Description
    * Make chat like interface 
    * Make it able to detect from props parts of data in ("learning") and data out ("giving responses")
- Storage
    - TopGun
    * name
    * movie
    * toWatch (-> toDo)
    - Jarvis
    * name
        * toWork (-> toCode -> toDo)
            * dueDate
            * plan
                * milestones
                    * name 
                    * dueDate
                    * description
                    * subtasks
                        * name

### Milestone x: later
    - (then add sound -> text, text -> sound, then also img...)
    - connect to chatGPT API
    - add voice recognition
    - Navigate the web + laptop


## Mechanism
Stores information "like the brain": connections between data, so it can do what it's been thought with 100% accuracy, unlike AI.

## ToDo 
1. make this work
I am teo. / My name is Teon
Who am I? / what is my name
when somebody greets u, u should greet back
"hello" is a greeting
hello


1. Detect questions
- ? at the end
- inversion
Auxiliary verbs used in quesions:
can, could, may, might, will, would, shall, should;
be (am, is, are, was, were);
do (does, did);
have (has, had);
need, dare, ought to;
- maybe wh word?

2. Random
- adapt nav rail to screen width, make it scrolable, add another delete method, add keyboard shortcuts
- make the sync button work
- when pressing shift, make multi line message

## To find out
- When should a new conv start automatically? (after how much time)

### information model
Ex: pi = 3.141592
- date of information aqured
- source
    - trust score

## Example of functioning
plan my day
= todo for today


## Types of questions
1. Yes/No
- Do you like this country? 
- Does Jane know about your new job?
- Can I call my sister?
- Is it cold outside?
- Are they ready for the trip?
- Are you hungry? 


2. Wh-: who, what, where, when, why, how, how many
- Where is he from? 
- When did you come here? 
- How did you meet her?
- How many eggs do we need for this cake?
- Whose children are playing in the yard?

2. 1. It can be indirect
- Could you please tell me where the bookstore is? 
- Do you know where the bookstore is?

2. 2. Pay attention to
- Where you go, I will follow.
- Where there's a will, there's a way.
- Where there is love, there is life.
- Wherever you are, I'll be there.


3. Choice
- Does she like ice cream or sweets?
- Where would you go, to the cinema or the theatre?
- Is he a teacher or a student?

4. Disjunctive/Tag
She sent him an invitation, didn’t she?
You aren’t getting married, are you?
Jane isn’t in France, is she?
Our dad will come soon, won’t he?

## Info about the brain
10^15 (1 thousand trilion) op/second
86 billion neuron cells
10.000 connections/neuron
Domain i have to study: neural coding
