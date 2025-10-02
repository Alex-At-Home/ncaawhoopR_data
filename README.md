# ncaahoopR_data

Data pulled from [ncaahoopR](https://github.com/lbenz730/ncaahoopR)

Schedules, Rosters, Box Scores, and Play by Play logs already scraped from [ncaahoopR](https://github.com/lbenz730/ncaahoopR) package.

Schedules and Rosters are in of the form of **season/schedule/team_schedue.csv** and **season/roster/team_roster.csv**. Box Scores are in the form **season/team/game_id.csv**, which linkage avaialable to the correspoding team schedule for that season. PBP logs are in the form **pbp_logs/date/game_id.csv**. Each date folder contains a schedule listing games (with teams, scores, and game_id) on that date, and the file **pbp_logs/schedule.csv** aggregates these schedules to create a game lookup for all games this season.

**load_data.R**: Demonstrates an example how to read and merge files all at once.

**analysis/** folder has some interesting data and scripts from analyzing this data, including a file of jump balls.

Running **update.R** gets the most up to date version of PBP, rosters, box scores, and schedules for the current season.

# Install Instructions on Mac 15.7

_(Note: I went through multiple iterations and ended up removing some graphics packages from my fork of ncaahoopR,
because I couldn't get homebrew/R to play nice with them, so many of these steps may not be needed.)_

- Install R (`brew install r`)

There's some other packages to install:

```bash
brew install fribidi
brew install libgit2
brew install pkg-config
brew install harfbuzz
brew install openssl

brew install freetype
brew install libpng
brew install libtiff
brew install jpeg
brew install webp

brew install imagemagick
brew install jpeg
```

- Ensure xcode is installed (`xcode select --install`, then restart Mac)
- Create a file called `~.R/Makevars`:

```bash
# ~/.R/Makevars for macOS SDK
# SDKROOT should be the output of SDKROOT
SDKROOT = /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

CFLAGS     = -isysroot $(SDKROOT)
CXXFLAGS   = -isysroot $(SDKROOT) -I$(SDKROOT)/usr/include/c++/v1
CPPFLAGS   = -isysroot $(SDKROOT) -I$(SDKROOT)/usr/include/c++/v1
OBJCFLAGS  = -isysroot $(SDKROOT)
OBJCXXFLAGS= -isysroot $(SDKROOT) -I$(SDKROOT)/usr/include/c++/v1
LDFLAGS    = -isysroot $(SDKROOT)
```

- We'll also set these as environment variables in the terminal while installing devtools:

```bash
export CC=clang
export CXX=clang++
export SDKROOT=$(xcrun --show-sdk-path)
export CPPFLAGS="-isysroot $SDKROOT -I$SDKROOT/usr/include/c++/v1 -I$(brew --prefix jpeg)/include"
export CXXFLAGS="$CPPFLAGS"
export CFLAGS="-isysroot $SDKROOT"
export LDFLAGS="-isysroot $SDKROOT -L$(brew --prefix jpeg)/lib"
```

- Run `R` from the command-line of the same terminal
- Execute `install.packages("devtools")` from the R shell (`CTRL+D` to exit)
- Now you can run `Rscript update.R` to kick off the crawl
  - (Unclear if you always need the above vars, probably safest! At least the first time it's compiling a bunch of stuff)
  - (I ran into some other errors but only for graphics functions update.R doesn't use so you can ignore them)
  - (Roster creation doesn't work, unclear why; I don't need it anyway)
