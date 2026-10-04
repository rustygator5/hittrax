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

### Strike-zone heat map
HitTrax tags every pitch with a zone (1-9 inside the strike zone, 10-13 the out-of-zone
quadrants). The dashboard draws those as a heat map across every logged session - inner 3x3 grid
inside the zone box, four quadrants in the ring around it - coloured by average exit velo,
hard-hit % or ball count, with the same map per session in the session detail. Cells with one or
two balls are faded; the zone number sits in every cell so the layout can be checked against
HitTrax's own display. The left/right halves are inferred from the exports - the vertical tiers
are unambiguous in the data, the horizontal is not - so flag it if your zone grid is mirrored.

## Views
- **Dashboard** — latest session with deltas vs the previous one, PB badges, age benchmark bar, "what's moving"
- **Trends** — any metric over time with a 3-session rolling average; first / latest / total change
- **Sessions** — full history, tap for the breakdown (scatter, spray chart, every batted ball)
- **Report** — printable progress report (print to PDF or copy as text) for coaches
- **Player & Data** — player info, hard-hit threshold, JSON backup, CSV export, import

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
