# Database Information
## Import Information
To use the database, import the file [Databases](/lib/Util/databases.dart)

## Data Querying Information
There are many ways to query data. The data is presented in [HouseDatabaseTable](/lib/Classes/databaseTables.dart) format. You can read more about that [here](HouseDatabaseTable.md).

All of the methods use async. Therefore, these methods can only be called in a async function.

As of 6-4-2025, here are the methods:
### Databases.queryHousesById(int id)
Query the HouseDataTable through an id. IDs can be found [here](https://docs.google.com/spreadsheets/d/1qSCx8z4FAC2crFKanxImvWnods6QUimWa4G1mcOSMc4/edit?gid=503268534#gid=503268534)

For Lakewood, use the id "0"
### Databases.queryHousesByPath(String path)
Query the HouseDataTable through a path. Paths can be found [here](https://docs.google.com/spreadsheets/d/1qSCx8z4FAC2crFKanxImvWnods6QUimWa4G1mcOSMc4/edit?gid=503268534#gid=503268534)

For Lakewood, use the path "lakewood-lakeoswego-oregon-unitedstates-earth-milkyway.sqlite"
### Databases.queryHouses(Database db)
Query the HouseDataTable using a database. Use other functions in the Databases class, such as getHouseDatabase(String path), to get a database to parse through here.

Use the other two as they are more user-friendly than this method.