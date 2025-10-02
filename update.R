### Install Latest Version of Package
devtools::install_github('Alex-At-Home/ncaawhoopR')

library(ncaahoopR)
library(readr)

fresh_scrape <- F ### rescrape old data from current season?
n <- nrow(ids)
if(!dir.exists('2024-25/rosters/')) {
  dir.create('2024-25') 
  dir.create('2024-25/rosters/') 
  dir.create('2024-25/pbp_logs/') 
  dir.create('2024-25/schedules/') 
  dir.create('2024-25/box_scores/') 
}

### Schedules + Rosters
# (not working for NCAAW anyway)

### Pull Games
date <- max(as.Date('2024-11-01'), as.Date(dir('2024-25/pbp_logs/')) %>% max(na.rm = T))
if(fresh_scrape) {
  date <- as.Date('2024-11-01')
}
while(date <= Sys.Date()) {
  print(date)
  schedule <- try(get_master_schedule(date))
  if(class(schedule) != 'try-error' & !is.null(schedule)) {
    if(!dir.exists(paste("2024-25/pbp_logs", date, sep = "/"))) {
      dir.create(paste("2024-25/pbp_logs", date, sep = "/")) 
    }
    write_csv(schedule, paste("2024-25/pbp_logs", date, "schedule.csv", sep = "/"))
    
    n <- nrow(schedule)
    for(i in 1:n) {
      if(!file.exists(paste("2024-25/pbp_logs", date, paste0(schedule$game_id[i], ".csv"), sep = "/")) | fresh_scrape) {
        print(paste("Getting Game", i, "of", n, "on", date))
        x <- try(get_pbp_game(schedule$game_id[i]))
        if(!is.null(x) & class(x) != "try-error") {
          write_csv(x, paste("2024-25/pbp_logs", date, paste0(schedule$game_id[i], ".csv"), sep = "/"))
        }
      }
    }
  }
  date <- date + 1
}

### Update Master Schedule
date <- as.Date('2024-11-01')
master_schedule <- NULL
while(date <= Sys.Date()) {
  print(date)
  schedule <- try(read_csv(paste("2024-25/pbp_logs", date, "schedule.csv", sep = "/")) %>%
                    mutate("date" = date))
  if(class(schedule)[1] != "try-error") {
    write_csv(schedule, paste("2024-25/pbp_logs", date, "schedule.csv", sep = "/"))
    master_schedule <- bind_rows(master_schedule, schedule)
  }
  
  date <- date + 1
}
write_csv(master_schedule, "2024-25/pbp_logs/schedule.csv")

### Box Scores
#(don't need this)
