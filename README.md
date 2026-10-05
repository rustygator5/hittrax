# HitTrax Progress Tracker

Single-file web app (`index.html`) for tracking a hitter's development session over session
from HitTrax data. No install, no server needed — open the file, or run the local preview.

## Two ways to log a session
1. **Upload the HitTrax CSV** (or drag it onto the drop zone) — .csv, .tsv or .txt. Title/player
   rows above the real header are skipped, quoted fields and tab/comma/semicolon delimiters are
   handled, and rows without a usable exit velo are reported and skipped. Pasting the rows into
   the box works exactly the same way, including headerless "78.4 14 205" lines.
   Columns are auto-detected: Velo / Exit Velocity, LA / Launch Angle, Dist / Distance,
   Spray / Horiz Angle, Result / Play, Pitch Velo, Date. Every summary metric is computed,
   plus the LA-vs-EV scatter and the spray chart.
   If the file covers several dates it offers to save one session per date (previewed in a table
   before saving); pitch speed is averaged from the file when you leave that field blank.
2. **Type the summary** — key in whatever the HitTrax session report screen shows.

## Games (GameChanger)
A third discipline alongside Hitting and Catching, for what actually happened in games. Type the
line straight off a GameChanger box score - PA, AB, H, 2B, 3B, HR, RBI, R, BB, K, HBP, SF, SB, CS,
plus innings caught, passed balls, steals allowed and runners caught - and the slash line, rates
and season totals are derived: AVG, OBP, SLG, OPS, total bases, extra-base hits, K%, BB%, CS%.
Doubleheaders on one date add their counts together and the rates are recomputed, not averaged.

GameChanger's CSV export is staff-only, so there's nothing to upload on a family account; the
entry form takes the numbers off the screen (or off a screenshot) in under a minute. It covers
the Standard and Advanced batting tabs plus the Catching and Fielding ones - QAB, HHB, C%,
LD/FB/GB%, BABIP, BA/RISP, pitches seen, innings caught, PB, steals allowed, runners caught, PO,
A, E - and derives QAB%, pitches per PA and fielding % from them.

**Season-to-date lines are snapshots.** Set the type to *Season to date* (the app asks when GP is
above 1) and you can paste GameChanger's whole season line in after every game: each update only
contributes what it adds over everything before it, so a 4-game line followed by a 5-game line is
5 games, not 9. The difference between two updates becomes its own entry ("Game 5"), which gives
the game log and trends a line per update. Games logged one by one in between are subtracted, and a
game on the same date as an update is taken as already inside it.

**Innings are thirds.** 14.1 means 14⅓, so innings are added as outs (14.1 + 6.2 = 21, not 20.3).
That makes **passed balls per 6 innings** possible - the one receiving/blocking number a box score
gives - shown on the season card, the game report, and in the Coach's read once he has 12+ innings
caught and is above 1.5 per game.

The **Report** tab has its own game report on the Games side: season batting line and rates, the
catching and fielding lines, OPS season to date, and a game log.

Entries can also arrive as a link: a `#add=<base64 json>` URL opens a confirmation listing what
it contains - sessions, or a setting such as the strike-zone calibration - and applies it on approval - handy when someone reads a box score off a screenshot
for you. Nothing is replaced, and the link is stripped from the address bar afterwards.

**Cage vs game** sits on that dashboard and is the point of the whole thing: HitTrax's simulated
AVG and SLG next to the real ones, average exit velo next to strikeout rate, and best pop time
next to the share of runners actually thrown out.

## One day = one session
HitTrax writes a file per round, so a single trip to the cage can arrive as two or three uploads.
Anything logged on the same date (within the same discipline) is grouped into one session
everywhere - dashboard, trends, personal bests, report - so a day counts once instead of showing
up as several half-rounds. The rounds are kept underneath: open the session and each upload is
listed with its own ball/throw count and its own delete button.

Open a day and each round is listed with its own **avg pitch speed and avg exit velo** (avg pop
for catching) - the quickest way to spot that round 2 was a different pitcher or machine setting.
Each round then has a **Counts as** dropdown:

- **Grouped** (default) - merged into the day's numbers
- **Separate** - stays its own session on that date, so a 35 mph machine round and a 21 mph toss
  round never average together; it shows up as its own row marked SEPARATE ROUND
- **Excluded** - kept but left out of every total, trend and personal best; excluded rounds get
  their own card at the bottom of the Sessions tab, with the same dropdown to bring them back

When every round of the day has raw rows, the day's numbers are recomputed from the pooled rows,
so they are exact. If one round was typed in as a summary instead, counts are summed, bests take
the best, and averages are weighted by round size.

## Bat speed (estimated)
Exit velo depends on how fast the pitch arrives, so a front-toss round and a machine round can't be
compared directly. Bat speed takes the pitch out: a batted ball's speed is roughly
q x pitch speed + (1 + q) x bat speed (Alan Nathan's collision model), so each ball is turned back
into a bat speed using its own pitch speed, and the hardest-hit quarter is averaged - a mishit
transfers less and would understate the swing.

q is the bat's collision efficiency: 0.20 for wood and BBCOR (the default, and the safe choice if
unsure), about 0.24 for hot youth barrels - set it under Player & Data -> Bat. Like the hard-hit
line, it is frozen on each session at save time, so switching bats changes new sessions only
(re-scoring the old ones is an explicit choice). Because q is constant session to session, the
change in this number is real even if the absolute value is a few mph off.

The dashboard card shows it against Blast Motion's sensor ranges for the age group (a different
measurement, there for context), and when a day has rounds off different feeds it compares them:
on 10/4 he swung 44.0 mph against the 35 mph machine and 38.8 against 21 mph front toss - the
slower pitch explained only 2.8 of the 8.9 mph exit-velo gap. "What's moving" also tests exit velo
with every ball moved to a common pitch speed, which separates the swing from the feed.

## How progress is judged
A single session is too small to read on its own: at 16 swings, his exit velo has a standard
error of about 2 mph, so two sessions need to differ by roughly 6 mph before the gap means
anything. So:

- **What's moving** pools the actual batted balls (or clean throws, or plate appearances), compares
  the most recent window with the one before it, and only calls a change when it clears a 95% bar
  (Welch test for averages, two-proportion test for rates). Everything else is listed as "inside the
  noise" with how big a change it would take to count. With too little data it says so rather than
  guessing.
- **Trends** size each dot by its sample, hollow when too small to trust, and the rolling average
  is weighted by sample size so a 5-ball session can't swing it.
- **Rolling by ball** (a toggle on Trends) ignores sessions entirely and walks through every batted
  ball or clean throw in order: each point is the last N, drawn with its 95% band (a t-interval for
  averages, a Wilson interval for rates) against a strip showing where he started. The window
  defaults to the biggest that leaves two non-overlapping windows, and the readout tests the first
  window against the latest one - "Real improvement", "Not yet distinguishable", or how many more
  balls it needs. Covers exit velo, exit velo at a common pitch speed, bat speed, hard-hit,
  sweet-spot, line-drive and ground-ball rates and launch angle; pop time, exchange, arm strength
  and projected outs for catching.
- **Personal bests** for averages and rates need a minimum sample (10 balls, 8 throws); single-event
  bests like max exit velo or best pop count from any session.
- **Games** trend as the season line after each game, because one game is 3-5 plate appearances.
  Rate stats have no single-game "best"; counting stats show single-game highs.
- **Hard-hit is frozen per session** at the threshold in force when it was logged, so changing his
  age (or the threshold) never silently re-scores history. Re-scoring everything is an explicit
  choice offered when the threshold changes.

## Data hygiene
Every way data enters - import links, backup files, the cloud, and local storage - is rebuilt from
a whitelist of fields with known types before it is kept, and everything rendered is escaped.
That matters more than usual here: the app shares an origin with the hub and the budget app.

## Coaching layer
- **Coach's read** (top of the dashboard) picks one thing going well and one thing to work on, with
  a drill, from all three sides of his game - but only from evidence that holds up: changes that
  cleared the noise, recent windows, age benchmarks, the feed-speed bat-speed gap, the cage-vs-game
  batted-ball mix, and arm-care load (which outranks everything).
- **Goals** - pick a measure and a target; "now" is read off his recent balls or throws (or the
  season line for games), never one good day, with progress from where he was when it was set.
  Goals sync between devices like sessions, deletes included.
- **Cage vs game** compares like with like first - line-drive, fly-ball and ground-ball share, and
  hard contact - and keeps results (simulated vs real AVG) separate, because those mostly measure
  the opponent. It calls out the gap worth coaching, e.g. 67% fly balls in games vs 29% in the cage.
- **Arm care** counts throws per week and flags a week 1.5x or more above his recent average.
- **Spreads** - launch-angle spread and exchange spread track how repeatable the swing path and the
  exchange are, not just their averages.

## Throws to third
HitTrax's catching export doesn't say which base, so the session type does. Rounds typed
*Throw-downs to 3B* stay their own entry (even on a day with 2B rounds) and are kept out of 2B pop-time
trends, personal bests, the age chart, What's moving and the Coach's read - a shorter throw isn't a
faster catcher.

## Two disciplines
A **Hitting / Catching** switch sits under the tabs (it appears once a catching session exists).
Each discipline keeps its own sessions, trends, personal bests, benchmarks and report.

### Catching
HitTrax's catching module measures the throw to second: **pop time**, **exchange (transfer) time**,
**arm strength** (peak throw velocity), **throw accuracy** and a projected **out / safe** call.
Upload that export the same way as a hitting CSV, or type the session summary. The app adds:
- Best / average / top-25% pop time, best and average exchange, max and average arm strength
- On-target % (within 24 in of the bag, or the file's own flag) and projected outs %
- A "where the pop time goes" split - exchange vs. ball flight - which says whether footwork or
  arm strength is the thing worth training
- Pop time by throw, with the age benchmark lines drawn behind it
- Age benchmarks for pop time (lower is better), from the NextCommit / TopVelocity / Catching-101 charts

Confirmed against a real export whose header is:
`#, Date, Time Stamp, Pitch, Throw, Pop, Exchg, Res, +/- Sec, Catcher`
(Throw = arm strength, Res = out/safe, +/- Sec = time vs. the runner, Pitch = pitch speed in).
Other names are matched too - Pop Time, Exchange / Transfer, Velo / Arm Strength, Accuracy / Miss,
Outcome, Base, Date. Milliseconds convert to seconds, feet to inches, and anything unrecognised
is listed under the preview.

### Throw-down visuals
HitTrax reports the pop time and a +/- second differential against the runner, so the runner's own
time is recoverable (runner = pop - differential). Checked against the real export: that
reconstruction predicts HitTrax's own Out/Safe call on every clean rep.

- **Throw-downs to second** - an animated overhead diamond racing the ball (home to second) against
  the runner (first to second) on each rep, with a live clock, exchange and arm strength, and the
  OUT / SAFE verdict and margin. Plays every rep in order or one you pick. Bases are drawn at the
  age-appropriate distance (70 ft at 12U and under, 80 at 14U, else 90).
- **Where each rep was won or lost** - one bar per throw split into exchange and ball flight, with
  a red line where the runner reaches second. Anything finishing left of the line is an out.

### Clean reps vs. misfires
A real session is not 22 clean throw-downs. HitTrax logs every pitch, so a dropped ball or a
double clutch shows up as a pop time of 5-6 seconds, and a rep with no throw at all shows up as
0.00. Averaging those in buries real progress, so the headline numbers (pop, exchange, arm
strength) use **clean reps only** - pop between 1.2 and 4.0 s - and the rest become
**Clean Rep %**, a metric worth tracking in its own right. Every rep still appears in the
session's throw table, tagged "misfire" or "no throw".

## What it tracks
Max EV, Avg EV, Top-25% Avg EV, hard-hit average, barrel %, avg launch angle, sweet-spot LA %,
LD / FB / GB / PU mix, max & avg distance, BA, SLG, balls in play.

Definitions: GB <10 deg, LD 10-25, FB 25-50, PU >50. Sweet spot = 8-32 deg.
Hard hit = at or above the threshold on the Player & Data tab (defaults to the age group's
"good" floor). Barrel = hard hit AND 8-32 deg.

### 3D flight paths (and video)
Each batted ball's flight is rebuilt and animated over a 3D field: projectile motion at the
measured exit velocity and launch angle, launched along the spray direction from the measured
contact height, with the horizontal scaled so the ball lands exactly on HitTrax's projected
distance (that scale stands in for drag). Three cameras - behind the plate, third-base side,
high home - plus a ball picker to isolate one swing, and ground shadows for depth. The park is
drawn to fit the hitter, so a 12U round fills the frame instead of rattling around a 320 ft field.

**Save video** records the canvas to a real video file (WebM/MP4 via MediaRecorder) and downloads
it - a couple of seconds of animation is about 100 KB. Browsers without canvas recording say so
instead of failing silently.

Rendered with a hand-rolled pinhole camera on a plain canvas: no 3D library, works offline.

### Spray chart on a real field
Balls in play are plotted on a drawn field - dirt infield, foul lines, fence arc with distance
rings - using the export's own `Spray Chart X/Z` landing coordinates when present, and distance
plus horizontal angle when not. Dots are coloured by the simulated outcome (single / double /
triple / home run / out), falling back to batted-ball type for rounds logged before the app read
the `Res` column - re-upload those CSVs and the outcomes fill in (a re-upload of the same round
refreshes it in place instead of duplicating it), and the fence is drawn at 300 ft or further if the hits need it, so the
picture stays field-shaped rather than zooming to a 12U cage.

### Simulated at-bats
HitTrax plays every ball in play against a defence - that's where its AVG and SLG come from. The
dashboard and each session show that line: batting average with hits over at-bats, slugging, total
bases, outs, and a count of each outcome (1B x 15, Out x 15 ...). Fouls are excluded, as they are
not at-bats.

### Launch angle vs exit velo
The report's LA-vs-velocity chart: average exit velo in each 10-degree launch-angle band from
-30 to +70, drawn as one line per session so the last three sit on top of each other (newest
first), with ball counts per band as bars underneath. Hollow dots mark a band holding a single
ball. A session's own line also appears in its breakdown, above the per-ball scatter.

### Left / Centre / Right splits
The report's L/C/R block: fair territory in three 30-degree wedges from the catcher's view
(left -45 to -15, centre -15 to +15, right +15 to +45). Share of balls, count, avg exit velo, avg
launch angle, avg distance, hard-hit % and the simulated AVG for each third, with the pull and
oppo sides labelled from the hitter's handedness. Fouls and balls with no direction are excluded.

### Pitch location
Three views of the same thing:

- **Contact point in the zone** - the hitter's own strike zone, taken from the export's
  `Strike Zone Bottom/Top/Width`, with every ball plotted at its measured contact height and
  coloured by exit velo. Left-to-right is the pitch's zone column, because the export gives no
  pitch coordinates - only the zone number. (`POI X` is in the file but doesn't behave like a
  clean left/right coordinate, so it is deliberately not used as one.)
- **By pitch location** - in-zone (1-9) against chased pitches (10-13): balls, avg EV, hard-hit %,
  LD%, and the simulated AVG and SLG for each.

### Strike-zone calibration
A facility's plate reference can sit off-centre, which shows up as every pitch landing in one
column with nothing down the middle. The heat-map card calls that out when it sees it ("91% of
pitches crossed on the right side · nothing at all down the middle · only 31% were in the zone")
and suggests the test that settles it: feed one ball deliberately down the middle and see which
zone HitTrax logs. If a centred pitch comes back in a side column, Player & Data →
**Strike-zone calibration** can mirror the columns or shift them one to the left or right. It
relabels zones for display only - exit velo, angles and distances are never touched - and while it
is on, the heat-map card carries a badge saying so.

The heat map is drawn as a lattice of positions rather than HitTrax's fixed 13 cells, so a shift
moves every cell including the out-of-zone ones: there is no "above middle" zone number, but there
is an above-middle place on the plate, and the grid can draw it. The in-zone vs out-of-zone split
is deliberately left alone, because zones 10-13 are vertical misses that a sideways shift should
not rescue.

### Strike-zone heat map
HitTrax tags every pitch with a zone (1-9 inside the strike zone, 10-13 the out-of-zone
quadrants). The dashboard draws those as a heat map across every logged session - inner 3x3 grid
inside the zone box, four quadrants in the ring around it - coloured by average exit velo,
hard-hit %, simulated batting average or ball count, with the same map per session in the session detail. Cells with one or
two balls are faded; the zone number sits in every cell so the layout can be checked against
HitTrax's own display. The left/right halves are inferred from the exports - the vertical tiers
are unambiguous in the data, the horizontal is not - so flag it if your zone grid is mirrored.

## Views
- **Dashboard** — latest session with deltas vs the previous one, PB badges, age benchmark bar,
  "what's moving". When that date has more than one entry (a grouped day plus rounds kept
  separate) a picker switches between them — it opens on the grouped day
- **Trends** — any metric over time with a 3-session rolling average; first / latest / total change
- **Sessions** — full history with pitch speed per session, tap for the breakdown (scatter, spray
  chart, every batted ball). Session type is a dropdown you can change after the fact — HitTrax
  doesn't record it, so the upload has to guess; editing a grouped day retypes every round in it,
  or set each round individually in the day's breakdown
- **Report** — printable progress report (print to PDF or copy as text) for coaches
- **Player & Data** — player info, hard-hit threshold, JSON backup, CSV export, import

## Source files are kept
Every upload (and every pasted batch) is stored with its session, and the parser carries a
version number. When the app learns to read a new HitTrax column, the next load re-reads those
stored files and fills the new data into old sessions on its own - no re-uploading, and a banner
says how many sessions were refreshed. Roughly 5 KB per session; Player & Data shows the total
and offers "Re-read them now" or "Delete stored files".

Sessions logged before this existed don't have a file to re-read; those still show the amber
"missing data the app can now read" notice with a one-click jump to re-upload, which refreshes the
round in place and attaches the file for next time.

## Data & sync
Every session is saved to the browser's localStorage first, so the app works with no signal at
the cage. Sign in (Player & Data -> Sync across devices, or the pill in the header) with the same
account as the Budget app and it also syncs through Supabase, so the phone and the laptop share
one history.

Merge rules: sessions are unioned by id, the newest edit of a session wins, and deletes leave a
tombstone so a removed session doesn't come back from another device. Nothing is last-write-wins
except the player profile, which follows whichever device was touched most recently.

If a browser is already signed in to the Budget app or the hub on this domain, HitTrax borrows
that session automatically - no second login. If that borrowed sign-in has expired, the app says
so and offers a re-sign-in rather than sitting on "Offline": a refresh the server rejects (as
opposed to a network failure) retires that token, so it is not picked up again, while a fresh
login in any of the apps is borrowed as normal.

**One-time setup:** run `supabase-setup.sql` in the Supabase SQL editor to create the `hittrax`
table. Until then the header pill reads "Setup needed" and everything stays local (nothing is lost -
it uploads on the first successful sync).

Export a JSON backup before clearing browser history on a device that has never synced.

## Local preview
```
python -m http.server 8776 --directory "C:/Users/user/Documents/HitTrax"
```
(also registered in .claude/launch.json as "hittrax")

## Regression tests
Open `tests.html` (locally at http://localhost:8776/tests.html, or `/hittrax/tests.html` on the live site) — the tab
title reads `✓ 96/96` when everything passes. It loads the real app as `index.html?test=1`, which uses its own storage
key (`hittrax.test.v1`), never signs in, never syncs and ignores `#add=` links, and it deletes that key when done, so
it's safe on a device holding real data. The fixtures are synthetic but use HitTrax's exact export headers; every
expected number is worked out by hand in the comments. Covers the parsers (dates, decimal commas, scorebook results,
Type column, takes, misfires, HTML-instead-of-CSV), hitting / catching / game math, bat speed, the significance tests
behind "What's moving", frozen thresholds, sync merge + tombstones, zone calibration, the sanitizer and escaping.
Run it after any change to parsing or stats, before pushing. The footer of the app shows the build stamp
(`APP_BUILD`), so you can tell which version a phone is actually running.
