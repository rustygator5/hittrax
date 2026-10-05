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

### Pitch location
Three views of the same thing:

- **Contact point in the zone** - the hitter's own strike zone, taken from the export's
  `Strike Zone Bottom/Top/Width`, with every ball plotted at its measured contact height and
  coloured by exit velo. Left-to-right is the pitch's zone column, because the export gives no
  pitch coordinates - only the zone number. (`POI X` is in the file but doesn't behave like a
  clean left/right coordinate, so it is deliberately not used as one.)
- **By pitch location** - in-zone (1-9) against chased pitches (10-13): balls, avg EV, hard-hit %,
  LD%, and the simulated AVG and SLG for each.

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
that session automatically - no second login.

**One-time setup:** run `supabase-setup.sql` in the Supabase SQL editor to create the `hittrax`
table. Until then the header pill reads "Setup needed" and everything stays local (nothing is lost -
it uploads on the first successful sync).

Export a JSON backup before clearing browser history on a device that has never synced.

## Local preview
```
python -m http.server 8776 --directory "C:/Users/user/Documents/HitTrax"
```
(also registered in .claude/launch.json as "hittrax")
