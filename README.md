# Covid Contact-Tracing Dashboard

##Features

- Syncfusion datatable to display and sort data
- Login via firebaseAuth, PW reset function provided - no register frontend necessary,
all clients (data protection officials) set up in firebase console.

- supports export to .xlsx

- All entries are deleted after 28 - days, no firebase function/ cronjob, but via the application itself - 
so that free firebase versions can run it. 

##App

Dashboard to display data from guests registered according to Contact Tracing laws in Austria.

Currently hosted via firebase hosting on the web,
availabe for mobile and windows desktop with minor changes to the export. Is the "backend" for my other Covid-App written in Flutter,
where guests can register themselves.