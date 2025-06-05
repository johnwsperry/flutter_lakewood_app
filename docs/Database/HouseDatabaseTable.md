# House Database Table
The house database table is a class that contains data and manipulates it to allow you to query for certain values.

### List<MapData> getAllData()
Returns all the data in a list

---

### MapData getDataByID(int id)
Returns the house data by its index in the list.

---

### Iterable<MapData>? getAllDataByName(String name)
Returns all data entries that have the corresponding `name`.

---

### Iterable<MapData>? getAllDataByAddress(String address)
Returns all data entries that have the corresponding `address`.

---

### Iterable<MapData>? getAllDataByYearBuilt(String yearBuilt)
Returns all data entries that have the corresponding `yearBuilt`.

---

### Iterable<MapData>? getAllDataByShortDescription(String shortDescription)
Returns all data entries that have the corresponding `shortDescription`.

---

### Iterable<MapData>? getAllDataByDescription(String description)
Returns all data entries that have the corresponding `description`.

---

### Iterable<MapData>? getAllDataByLocation(LatLng location)
Returns all data entries that have the corresponding `location`.

---

### Iterable<MapData>? getAllDataByImageCount(int imageCount)
Returns all data entries that have the corresponding `imageCount`.

---

### Iterable<MapData>? getAllDataBySortTag(SortTag tag)
Returns all data entries that contain the given `SortTag` in their tags.

---

### String toString()
Returns a string representation of all the data entries in the table.

## [Return Home](../Documentation.md)
